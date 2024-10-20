from config import API_HOST, API_PORT
from dbtester.router import router
from fastapi import FastAPI
import uvicorn


app = FastAPI(title="dbTestPy",
              description="Author - Vess",
              version="0.5.0",)

app.include_router(router)

if __name__ == "__main__": 
    uvicorn.run(app, host=API_HOST, port=API_PORT, log_level="info")