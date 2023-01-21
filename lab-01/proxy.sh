#!/bin/bash

apt-get update
apt-get install -y nginx

cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://192.168.56.10:8080;
    }
}
EOF

systemctl restart nginx
