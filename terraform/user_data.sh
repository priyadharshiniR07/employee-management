#!/bin/bash
apt update -y
apt install -y docker.io
systemctl start docker
usermod -aG docker ubuntu

docker pull priyadharshiniro7/employee-management
docker run -d -p 8000:8000 priyadharshiniro7/employee-management
