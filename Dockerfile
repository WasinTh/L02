FROM python:3.11-bullseye
WORKDIR /code
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y \
    gcc \
    musl-dev && \
    rm -rf /var/lib/apt/lists/*
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .
CMD ["uvicorn", "main:app", "--host", "0.0.0.0"]

