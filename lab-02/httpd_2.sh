#!/bin/bash

apt update -y
sudo su
mkdir docker
cd docker
apt install docker.io -y

docker run -d -p 3306:3306 --name maria-db1 --env MARIADB_USER=admin --env MARIADB_PASSWORD=admin --env MARIADB_ROOT_PASSWORD=root --env MARIADB_DATABASE=wordpress  mariadb:latest



      
      
      
      
      