from fastapi import APIRouter
from src.schemas import TaskCreate, TaskResponse, TaskID
import src.service as service

router = APIRouter()

@router.post("/tasks/create", response_model=TaskID)
async def create_task(task: TaskCreate):
    return await service.create_task(task)

@router.get("/tasks/{task_id}", response_model=TaskResponse)
async def get_task(task_id: str):
    return await service.get_task(task_id)

@router.get("/tasks", response_model=list[TaskResponse])
async def list_tasks():
    return await service.list_tasks()

@router.get("/tasks/search")
async def search_tasks(query: str):
    return await service.search_tasks(query)