#!/bin/bash

apt-get update
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
docker run -d --name wordpress -p 8080:80 wordpress
iptables -A INPUT -s 192.168.56.11 -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j DROP