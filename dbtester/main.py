from config import API_HOST, API_PORT
from src.router import router
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from src.database import init_mongo
from src.service import init_celery
import uvicorn

if init_mongo():
    print("[+] MongoDB connection OK")

if init_celery():
    print("[+] Celery broker connection OK")

app = FastAPI(title="dbTestPy",
              description="Author - Vess",
              version="0.5.0",)

app.include_router(router)

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*']
)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=API_PORT, log_level="info")