FROM python:3.8.3-alpine
LABEL AUTHOR kyoungyeon kim (marycarychin@gmail.com)
ENV PYTHONUNBUFFERED 1
RUN mkdir /app
WORKDIR /app 
# change directory from container to  /app directory(working -front)

# dependencies for psycopg2-binary
# mariadb 

RUN apk add --no-cache mariadb-connector-c-dev
RUN apk update && apk add python3 python3-dev mariadb-dev build-base && pip3 install mysqlclient && apk del python3-dev mariadb-dev build-base
# By copying over requirements first, we make sure that Docker will cache
# our installed requirements rather than reinstall them on every build


FROM ubuntu:18.04.6
RUN apt-get update
RUN apt-get install locales

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install dependencies
ENV FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -qq wget unzip build-essential cmake gcc libcunit1-dev libudev-dev

# Grab the checked out source
RUN mkdir -p /nginx
WORKDIR /nginx
COPY . /nginx

EXPOSE 80 443
