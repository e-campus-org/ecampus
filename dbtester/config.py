from dotenv import load_dotenv
import os

load_dotenv()
API_HOST = os.environ.get("API_HOST")
API_PORT = int(os.environ.get("API_PORT"))

BROKER_HOST = os.environ.get("BROKER_HOST")
BROKER_PORT = os.environ.get("BROKER_PORT")
REDIS_PASSWORD = os.environ.get("REDIS_PASSWORD")
REDIS_USER = os.environ.get("REDIS_USER")
REDIS_USER_PASSWORD = os.environ.get("REDIS_USER_PASSWORD")

MONGO_DB_HOST = os.environ.get("MONGO_DB_HOST")
MONGO_DB_PORT = os.environ.get("MONGO_DB_PORT")
MONGO_DB_USER = os.environ.get("MONGO_DB_USER")
MONGO_DB_PASS = os.environ.get("MONGO_DB_PASS")
MONGO_DB_NAME = os.environ.get("MONGO_DB_NAME")

DB_HOST = os.environ.get("DB_HOST")
DB_PORT = os.environ.get("DB_PORT")
POSTGRES_DB = os.environ.get("POSTGRES_DB")
POSTGRES_USER = os.environ.get("POSTGRES_USER")
POSTGRES_PASSWORD = os.environ.get("POSTGRES_PASSWORD")