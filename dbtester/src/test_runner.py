import pytest
import tempfile
import os
import time

def run_tests(initial_script, tests, answer):
    with tempfile.TemporaryDirectory() as tmpdir:
        test_file_path = os.path.join(tmpdir, f"test_{os.urandom(4).hex()}.py")

        with open(test_file_path, "w") as f:
            f.write(f"""
import pytest
import psycopg2
from testcontainers.postgres import PostgresContainer

postgres = (PostgresContainer("postgres:13")
    .with_env("POSTGRES_USER", "test")
    .with_env("POSTGRES_PASSWORD", "test")
    .with_env("POSTGRES_DB", "test"))

@pytest.fixture(scope="module", autouse=True)
def db_connection(request):
    postgres.start()
    
    conn = psycopg2.connect(
        dbname="test",
        user="test",
        password="test",
        host="host.docker.internal",
        port=postgres.get_exposed_port(5432)
    )
    
    yield conn
    
    conn.close()
    postgres.stop()

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
        
        time.sleep(1)
        result = pytest.main(["-v", test_file_path])
        
    return "Tests passed" if result == 0 else "Tests failed"


# if __name__ == "__main__":
#     in_s = "CREATE TABLE sales (id INT, amount INT);\nINSERT INTO sales VALUES (1, 100), (2, 200), (3, 300);"
#     t = ["def test_sum(get_result): assert get_result == [(600,)]"]
#     a = "SELECT SUM(amount) FROM sales;"
#     print(run_tests(in_s, t, a))