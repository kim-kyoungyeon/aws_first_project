FROM golang:1.16.3-stretch AS builder
LABEL AUTHOR kyoungyeon kim (marycarychin@gmail.com)
# change directory from container to  /build directory(working)
RUN mkdir -p /build
WORKDIR /build 

COPY . .
RUN go mod tidy && go mod vendor
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bin/server ./cmd/server

# change directory from container to  /dist directory(working-back)
RUN mkdir -p /dist
WORKDIR /dist
RUN cp /build/bin/server ./server

FROM python:3.8.3-alpine
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
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt
# Now copy in our code, and run it
COPY . /app/