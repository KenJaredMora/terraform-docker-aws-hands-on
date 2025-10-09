#!/bin/bash
set -eux
amazon-linux-extras install -y docker
yum install -y unzip curl

systemctl enable docker
systemctl start docker

until curl -s -f http://169.254.169.254/latest/meta-data/; do
  echo "Waiting for metadata service..."
  sleep 5
done

docker pull ${dockerhub_image}
docker save ${dockerhub_image} -o /tmp/image.tar
chmod 644 /tmp/image.tar
aws s3 cp /tmp/image.tar "s3://${bucket_name}/image.tar"


docker rmi "${dockerhub_image}" || true
docker load -i /tmp/image.tar
docker run -d --restart unless-stopped -p 80:80 "${dockerhub_image}"