#!/bin/bash

apt update -y
sudo su
mkdir docker
cd docker
apt install docker.io -y

docker run -d -p 8080:80 --name wordpress --env WORDPRESS_DB_HOST=192.168.128.72:3306 --env WORDPRESS_DB_USER=admin --env WORDPRESS_DB_PASSWORD=admin --env WORDPRESS_DB_NAME=wordpress wordpress:latest
