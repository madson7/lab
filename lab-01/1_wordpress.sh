#!/bin/bash

sudo su
apt update -y
mkdir docker
mv docker-compose.yml ./docker
cd docker
apt install docker.io -y
apt install docker-compose -y
docker-compose up -d

