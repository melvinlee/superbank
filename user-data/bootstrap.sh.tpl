#! /bin/bash
set -e

# Make sure we have all the latest updates when we launch this instance
yum update -y

# Configure docker
amazon-linux-extras install docker 
yum install -y docker
service docker start
usermod -a -G docker ec2-user

# Start docker nginx
docker run -d -p 80:80 nginx 
docker container ls 

echo 'Done initialization'