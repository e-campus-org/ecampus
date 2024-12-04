from fastapi import HTTPException
from src.database import mongo_db
from src.schemas import TaskResponse, TaskCreate, TaskID
from src.test_runner import run_tests
from config import BROKER_HOST, BROKER_PORT
from celery import Celery
from bson import ObjectId
from os import getenv
import requests


def init_celery():
    app = Celery('tasks')
    redis_password = getenv('REDIS_PASSWORD')
    app.conf.broker_url = f'redis://:{redis_password}@redis:6379/0'
    app.conf.result_backend = f'redis://:{redis_password}@redis:6379/0'
    return app

celery_app = init_celery()
def to_ObjectId(id):
    return ObjectId(id)

@celery_app.task(bind=True, max_retries=3)
def process_task(self, task_id: str):
    print("[+] Task started")
    task_id = to_ObjectId(task_id)
    task = mongo_db.task_collection.find_one({"_id": task_id})
    print(task)
    if task:
        try:
            result = run_tests(task['initial_script'], task['tests'], task['answer'])
            mongo_db.task_collection.update_one(
                {"_id": task_id}, 
                {"$set": {"status": "completed", "result": result}}
            )
            
        except Exception as exc:
            self.retry(exc=exc, countdown=3)

async def create_task(task: TaskCreate):
    task_id = mongo_db.task_collection.insert_one(task.model_dump()).inserted_id
    process_task.delay(str(task_id))
    return TaskID(id=str(task_id))

async def get_task(task_id: str):
    task_id = to_ObjectId(task_id)
    task = mongo_db.task_collection.find_one({"_id": task_id})
    if task is None:
        raise HTTPException(status_code=404, detail="Task not found")
    return TaskResponse(**task)

async def  list_tasks():
    tasks = mongo_db.task_collection.find().to_list(length=None)
    return [TaskResponse(**task) for task in tasks]