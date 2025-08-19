FROM python:3.14.0rc2-alpine3.22

RUN apk update

RUN pip install --upgrade pip && pip install detect-secrets

CMD ["detect-secrets", "--help"]
