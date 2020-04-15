
FROM python:3.6-slim-stretch

LABEL maintainer="cadugoncalves96@gmail.com"

EXPOSE 8080

ADD ./base-test-api/ /app

WORKDIR /app

RUN pip3 install pipenv && pipenv install 

ENTRYPOINT pipenv run python start.py runserver