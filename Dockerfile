# syntax=docker/dockerfile:1.3

FROM ubuntu:20.04 AS REQUIREMENTS

ARG DEBIAN_FRONTEND=noninteractive

ENV POETRY_VERSION=1.1.11

RUN apt update -y \
  && apt install -y \
    python3 \
    python3-pip \
    gcc \
    wget \
    cmake

RUN pip install "poetry==$POETRY_VERSION"

COPY ./poetry.lock /tmp/poetry.lock
COPY ./pyproject.toml /tmp/pyproject.toml

WORKDIR /tmp/

RUN poetry export \
    --format requirements.txt \
    --without-hashes \
    --extras mongo \
    --extras rest-server \
    --output /tmp/requirements.txt

# ------------------------------------------------------------------------

FROM ubuntu:20.04 AS APP

RUN apt update -y \
  && apt install -y \
    sudo \
    docker.io \
    python3 \
    python3-pip

WORKDIR /app/

COPY --from=REQUIREMENTS /tmp/requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY ./auth_fastapi/ /app/auth_fastapi/

# EXPOSE 50053
