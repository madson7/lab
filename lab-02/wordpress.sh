		   
#!/bin/bash
ip -br a
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable --now docker docker.socket containerd
sudo su
docker-compose up -d
docker ps
exit