FROM python:3.12
RUN apt-get update && \
    apt-get install -y docker.io && \
    pip install pytest testcontainers

WORKDIR /app



COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


COPY main.py .
COPY config.py .
COPY .env .
COPY src/ ./src/


CMD ["python", "main.py"]