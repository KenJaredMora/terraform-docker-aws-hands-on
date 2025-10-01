module "s3_bucket" {
  source            = "./modules/s3_bucket"
  bucket_name       = var.s3_bucket_name  # leave empty to auto-generate
  enable_versioning = true
}

module "image_packer" {
  source        = "./modules/ec2_instance"
  instance_name = "devops-image-packer"
  ami_id        = var.ami_id
  instance_type = "t3.micro"
  vpc_id        = data.aws_vpc.default.id
  subnet_id     = local.default_subnet_id
  allowed_cidr  = "${var.allowed_ip}/32"
  key_name      = ""
  iam_instance_profile = aws_iam_instance_profile.s3_upload_profile.name

  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    if grep -q "Amazon Linux release 2" /etc/system-release 2>/dev/null; then
      yum update -y
      yum install -y docker awscli
    elif grep -q 'Amazon Linux 2023' /etc/os-release 2>/dev/null; then
      dnf update -y
      dnf install -y docker awscli
    else
      yum update -y || true
      yum install -y docker awscli || dnf install -y docker awscli || true
    fi

    systemctl enable docker
    systemctl start docker

    docker pull ${var.docker_image}
    docker save -o /tmp/devops_image.tar ${var.docker_image}

    aws s3 cp /tmp/devops_image.tar s3://${module.s3_bucket.bucket_name}/devops_image.tar

    rm -f /tmp/devops_image.tar
    docker rmi ${var.docker_image} || true
  EOF
}
