#! /bin/bash
set -e

# Make sure we have all the latest updates when we launch this instance
yum update -y

# Configure docker
amazon-linux-extras install docker 
yum install -y docker
service docker start
usermod -a -G docker ec2-user

# Start docker cash-api
docker run --platform linux/amd64 -d -p 80:8443 docker.io/melvinlee/cash-api:0.2.0
docker container ls 

echo 'Done initialization'