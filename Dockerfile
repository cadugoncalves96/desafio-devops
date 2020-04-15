LABEL maintainer="cadugoncalves96@gmail.com"

FROM python:3.6-slim-stretch

ADD ./base-test-api/ /app

WORKDIR /app

RUN pipenv install \
 && pipenv run python sstart.py runserver