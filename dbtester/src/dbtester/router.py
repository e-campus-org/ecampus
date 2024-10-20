from fastapi import APIRouter
from dbtester.schemas import TaskCreate, TaskResponse
import dbtester.service as service

router = APIRouter()

@router.get("/home")
def get_home():
    return  { "status": "привет сексуалка" }

@router.post("/tasks/create", response_model=TaskResponse)
async def create_task(task: TaskCreate):
    return service.create_task(task)

@router.get("/tasks/{task_id}", response_model=TaskCreate)
async def get_task(task_id: str):
    return service.get_task(task_id)

@router.get("/tasks", response_model=list[TaskCreate])
async def list_tasks():
    return service.list_tasks()

@router.get("/tasks/search")
async def search_tasks(query: str):
    return service.search_tasks(query)