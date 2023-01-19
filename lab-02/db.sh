#!/bin/bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker vagrant
sudo systemctl enable docker
sudo systemctl start docker
cd /vagrant
docker-compose up -d
sudo docker ps