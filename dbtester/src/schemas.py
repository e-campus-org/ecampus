from pydantic import BaseModel
from typing import List

class TaskCreate(BaseModel):
    initial_script: str
    tests: List[str]
    answer: str

class TaskID(BaseModel):
    id: str

class TaskResponse(BaseModel):
    initial_script: str
    tests: List[str]
    answer: str
    status: str
    result: str