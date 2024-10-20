from fastapi import HTTPException
from dbtester.database import mongo_db
from dbtester.schemas import TaskResponse, TaskCreate
from dbtester.test_runner import run_tests
from config import BROKER_HOST, BROKER_PORT
from celery import Celery
import requests

celery_app = None

try:
    celery_app = Celery('tasks', broker=f'redis://{BROKER_HOST}:{BROKER_PORT}')
    print("[+] Celery broker connection OK")
except Exception as e:
    print("[-] Celery broker connection ERROR:\n", e)
    exit()

@celery_app.task
def process_task(task_id: str):
    task = mongo_db.task_collection.find_one({"_id": task_id})
    if task:
        result = run_tests(task['initial_script'], task['tests'], task['answer'])
        mongo_db.task_collection.update_one({"_id": task_id}, {"$set": {"status": "completed", "result": result}})
        
        # Отправка вебхука
        webhook_url = task.get('webhook_url')
        if webhook_url:
            webhook_data = {
                "task_id": task_id,
                "status": "completed",
                "result": result
            }
            requests.post(webhook_url, json=webhook_data)



def create_task(task: TaskCreate):
    task_id = mongo_db.task_collection.insert_one(task.model_dump()).inserted_id
    process_task.delay(str(task_id))
    return TaskResponse(id=str(task_id))

    # try:
    #     task_id = mongo_db.task_collection.insert_one(task.model_dump_json()).inserted_id
    #     process_task.delay(str(task_id))
    #     return TaskResponse(id=str(task_id))
    # except:
    #     return {"status" : "error", "code" : "500"}

def get_task(task_id: str):
    task = mongo_db.task_collection.find_one({"_id": task_id})
    if task is None:
        raise HTTPException(status_code=404, detail="Task not found")
    return TaskCreate(**task)

def  list_tasks():
    tasks = list(mongo_db.task_collection.find())
    return [TaskCreate(**task) for task in tasks]

def search_tasks(query: str):
    tasks = list(mongo_db.task_collection.find({"$text": {"$search": query}}))
    return [TaskCreate(**task) for task in tasks]