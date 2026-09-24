# L02

A small FastAPI service that counts visits in Redis. Each request to the home page increments a shared counter; a second endpoint reads the current value without changing it.

## Stack

- Python 3.11
- [FastAPI](https://fastapi.tiangolo.com/) and [Uvicorn](https://www.uvicorn.org/)
- [Redis](https://redis.io/) (`redis:alpine`)
- Docker Compose

## Endpoints

| Method | Path | Behavior |
| --- | --- | --- |
| `GET` | `/` | Increments the `hits` counter and returns a greeting with the new count. |
| `GET` | `/current` | Returns the current `hits` value without incrementing it. |

The app listens on port `8000` inside the container. Compose publishes it on host port `9000`.

## Run with Docker Compose

Create a `.env` file in the project root:

```env
TAG=v1
DOCKER_HUB=your-dockerhub-user/l02:${TAG}
```

`DOCKER_HUB` is the image name used by the `fast-api` service. `TAG` is included so you can change the image tag in one place.

Start the stack:

```bash
docker compose up
```

Then open:

- http://localhost:9000/
- http://localhost:9000/current

Stop the stack with `Ctrl+C`, or run `docker compose down` from another terminal.

## Build the image locally

`docker-compose.yml` pulls a prebuilt image by default. To build from this repo instead, comment out `image` and uncomment `build` in the `fast-api` service:

```yaml
services:
  fast-api:
    build: .
    # image: ${DOCKER_HUB}
    ports:
      - "9000:8000"
```

Then rebuild and start:

```bash
docker compose up --build
```

The image installs `gcc` and `musl-dev`, then installs Python dependencies from `requirements.txt` and starts Uvicorn with `main:app`.

## Project layout

```
.
├── Dockerfile
├── docker-compose.yml
├── main.py
└── requirements.txt
```

- `main.py` defines the FastAPI app and the Redis client (`host=redis`, `port=6379`, matching the Compose service name).
- `get_hit_count()` retries up to 10 times if Redis is not ready yet, waiting 0.5 seconds between attempts.
