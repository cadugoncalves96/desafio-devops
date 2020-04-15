LABEL maintainer="cadugoncalves96@gmail.com"

FROM python:3.6-slim-stretch

EXPOSE 8080

ADD ./base-test-api/ /app

WORKDIR /app

RUN pip3 install pipenv

RUN pipenv install \
 && pipenv run python sstart.py runserver