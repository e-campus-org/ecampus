from pydantic import BaseModel
from typing import List

class TaskCreate(BaseModel):
    initial_script: str
    tests: List[str]
    answer: str

class TaskResponse(BaseModel):
    id: str