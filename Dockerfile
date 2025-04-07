FROM python:3.12-alpine

RUN apk --update-cache add \
  bash \
  openssl

WORKDIR /app

COPY requirements.txt /app/

RUN pip install -r requirements.txt

COPY backup.sh /app/

CMD ["/app/backup.sh"]
