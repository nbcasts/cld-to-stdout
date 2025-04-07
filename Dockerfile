FROM python:3.12-alpine

RUN apk --update-cache add \
  bash

WORKDIR /app

COPY requirements.txt /app/

RUN pip install -r requirements.txt

COPY backup.sh /app/
