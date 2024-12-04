import pymongo
from config import MONGO_DB_HOST, MONGO_DB_PORT, MONGO_DB_USER, MONGO_DB_PASS, MONGO_DB_NAME

collection_name = "tasks"
MONGO_URL = f"mongodb://{MONGO_DB_USER}:{MONGO_DB_PASS}@{"mongo"}:{MONGO_DB_PORT}"

def init_mongo():
    mongo_client = pymongo.MongoClient(MONGO_URL)
    try:
        mongo_client.server_info()
    except pymongo.errors.ConnectionFailure as e:
        print("[-] MongoDB connection ERROR:\n", e)
        exit()

    mongo_db = mongo_client[MONGO_DB_NAME]

    if MONGO_DB_NAME in mongo_client.list_database_names():
        print(f"[+] MongoDB:{MONGO_DB_NAME} already exists")

    task_collection = mongo_db[collection_name]

    if collection_name in mongo_db.list_collection_names():
        print("[+] MongoDB:{MONGO_DB_NAME}:{collection_name} already exists")

    return mongo_client, mongo_db, task_collection

# Инициализация при импорте
mongo_client, mongo_db, task_collection = init_mongo()

# Экспорт объектов для использования в других модулях
__all__ = ['mongo_client', 'mongo_db', 'task_collection']
