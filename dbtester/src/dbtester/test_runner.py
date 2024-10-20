import pytest
import tempfile
import os
import sys

#from config import DB_HOST, DB_PORT, DB_NAME, DB_USERNAME, DB_PASSWORD

def run_tests(initial_script, tests, answer):
    # Получаем путь к корневой директории проекта
    project_root = os.path.dirname(os.path.abspath(__file__))
    
    # Создаем временную директорию в корне проекта
    with tempfile.TemporaryDirectory(dir=project_root) as tmpdir:
        # Создаем временные файлы для тестов
        with open(os.path.join(tmpdir, "test_task.py"), "w") as f:
            f.write(f"""
import pytest
import psycopg2
import os
from testcontainers.postgres import PostgresContainer

postgres = PostgresContainer("postgres:13")

@pytest.fixture(scope="module")
def db_connection(request):
    postgres.start()

    def remove_container():
        postgres.stop()
   
    request.addfinalizer(remove_container)

    # os.environ["DB_CONN"] = postgres.get_connection_url()
    # os.environ["DB_HOST"] = postgres.get_container_host_ip()
    # os.environ["DB_PORT"] = postgres.get_exposed_port(5432)
    # os.environ["DB_USERNAME"] = postgres.POSTGRES_USER
    # os.environ["DB_PASSWORD"] = postgres.POSTGRES_PASSWORD
    # os.environ["DB_NAME"] = postgres.POSTGRES_DB
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432"),
        user=os.getenv("DB_USERNAME", "test"),
        password=os.getenv("DB_PASSWORD", "test"),
        database=os.getenv("DB_NAME", "test")
    )

@pytest.fixture(scope="module", autouse=True)
def initial_script_realization(db_connection):
    with db_connection.cursor() as cursor:
        cursor.execute(\"\"\"{initial_script}\"\"\")
        db_connection.commit()

@pytest.fixture(scope="module")
def get_result(db_connection):
    with db_connection.cursor() as cursor:
        cursor.execute(\"\"\"{answer}\"\"\")
        return cursor.fetchall()


for test in {tests}:
    exec(test)
""")

        # Добавляем временную директорию в sys.path
        sys.path.insert(0, tmpdir)

        # Запускаем pytest
        result = pytest.main(["-v", os.path.join(tmpdir, "test_task.py")])

    return "Tests passed" if result == 0 else "Tests failed"

if __name__ == "__main__":
    in_s = "CREATE TABLE A (id INT, name VARCHAR(10));\nINSERT INTO A VALUES (1, 'Evgen'), (2, 'Niki');"
    t = ["def test_select(get_result):  assert get_result == [(3, 'Evgen'), (2, 'Niki')]"]
    a = "SELECT * FROM A;"
    print(run_tests(in_s, t, a))