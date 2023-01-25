#!/bin/bash

sudo su
apt update -y
apt install nginx -y
mkdir proxy
cd proxy
cat ./proxy >  /etc/nginx/sites-available/default
systemctl restart nginx


