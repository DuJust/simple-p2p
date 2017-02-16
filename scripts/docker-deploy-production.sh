#!/usr/bin/env bash

set -e

# Better using production environment variable than hard code in script here.
PORT=80

APP_NAME='app'
APP_NGINX="${APP_NAME}_nginx"
DB_USER='root'
DB_PASSWORD='secret'
DB_HOST="${APP_NAME}_db"

app_container_id=$(docker ps -a -q -f name=${APP_NAME})
if [[ ${app_container_id} ]]; then
  echo "There was an ${APP_NAME} container ${app_container_id} running, going to stop and delete it..."
  docker stop ${app_container_id}
  docker rm ${app_container_id}
else
  echo "There is no running ${APP_NAME} container..."
fi

nginx_container_id=$(docker ps -a -q -f name=${APP_NGINX})
if [[ ${nginx_container_id} ]]; then
  echo "There was ${APP_NGINX} container ${nginx_container_id} running, going to stop and delete it..."
  docker stop ${nginx_container_id}
  docker rm ${nginx_container_id}
else
  echo "There is no running ${APP_NGINX} container..."
fi

echo "Running a new ${APP_NAME} container..."
docker build -t ${APP_NAME} .

db_container_id=$(docker ps -a -q -f name=${DB_HOST})
if [[ ${db_container_id} ]]; then
  echo "There was a ${DB_HOST} container $db_container_id running, skipping..."
else
  echo "There is no running ${DB_HOST} container, going to run a new one..."
  docker run --name ${DB_HOST} -v $(pwd)/docker/mysql:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=${DB_PASSWORD} -d mysql

  echo "Waiting ${DB_HOST} container starting..."
  sleep 10

  echo "Running rails db rake tasks..."
  docker run --name ${APP_NAME} --link ${DB_HOST}:${DB_HOST} -e DB_USER=${DB_USER} -e DB_PASSWORD=${DB_PASSWORD} -e DB_HOST=${DB_HOST} -e DB_NAME=${APP_NAME} --rm ${APP_NAME} rake db:drop db:create db:migrate db:seed
fi

echo "Running a new ${APP_NAME} container..."
docker run --name ${APP_NAME} --link ${DB_HOST}:${DB_HOST} -e DB_USER=${DB_USER} -e DB_PASSWORD=${DB_PASSWORD} -e DB_HOST=${DB_HOST} -e DB_NAME=${APP_NAME} -e RAILS_ENV=production -d ${APP_NAME}

echo "Building a new ${APP_NGINX} image..."
docker build -t ${APP_NGINX} -f docker/nginx/Nginx-Dockerfile docker/nginx

echo "Running a new ${APP_NGINX} container..."
docker run --name ${APP_NGINX} --link ${APP_NAME}:${APP_NAME} --volumes-from=${APP_NAME} -p ${PORT}:80 -d ${APP_NGINX}

echo "Deploy successfully!"
