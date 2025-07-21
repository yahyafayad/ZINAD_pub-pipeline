FROM python:3.9.23-alpine3.22

RUN apk update

RUN pip install --upgrade pip && pip install detect-secrets

CMD ["detect-secrets", "--help"]
