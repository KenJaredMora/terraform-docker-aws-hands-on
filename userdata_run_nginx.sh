#!/bin/bash
set -eux
amazon-linux-extras install -y docker
systemctl enable docker
systemctl start docker

docker pull ${dockerhub_image}
docker run -d --restart unless-stopped -p 80:80 ${dockerhub_image}
