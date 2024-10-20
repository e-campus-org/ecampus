from dotenv import load_dotenv
import os

load_dotenv()
API_HOST = os.environ.get("API_HOST")
API_PORT = int(os.environ.get("API_PORT"))

BROKER_HOST = os.environ.get("BROKER_HOST")
BROKER_PORT = os.environ.get("BROKER_PORT")

MONGO_DB_HOST = os.environ.get("MONGO_DB_HOST")
MONGO_DB_PORT = os.environ.get("MONGO_DB_PORT")
MONGO_DB_USER = os.environ.get("MONGO_DB_USER")
MONGO_DB_PASS = os.environ.get("MONGO_DB_PASS")
MONGO_DB_NAME = os.environ.get("MONGO_DB_NAME")

DB_HOST = os.environ.get("DB_HOST")
DB_PORT = os.environ.get("DB_PORT")
DB_NAME = os.environ.get("DB_NAME")
DB_USERNAME = os.environ.get("DB_USERNAME")
DB_PASSWORD = os.environ.get("DB_PASSWORD")