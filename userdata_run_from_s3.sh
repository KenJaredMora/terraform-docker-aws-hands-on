#!/bin/bash
set -eux

# AL2: Docker + AWS CLI
amazon-linux-extras install -y docker
yum install -y awscli

systemctl enable docker
systemctl start docker

# pull the tar from S3, load, and run
aws s3 cp s3://${BUCKET}/${KEY} /tmp/image.tar
docker load -i /tmp/image.tar
docker run -d --restart unless-stopped -p 80:80 ${IMAGE}
