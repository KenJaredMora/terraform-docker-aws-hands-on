data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  default_subnet_id = data.aws_subnets.default_vpc_subnets.ids[0]

  web_user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    if grep -q "Amazon Linux release 2" /etc/system-release 2>/dev/null; then
      yum update -y
      amazon-linux-extras install docker -y
    elif grep -q 'Amazon Linux 2023' /etc/os-release 2>/dev/null; then
      dnf update -y
      dnf install -y docker
    else
      yum update -y || true
      yum install -y docker || dnf install -y docker || true
    fi

    systemctl enable docker
    systemctl start docker

    docker run -d -p 80:80 ${var.docker_image}
  EOF
}


module "web_server" {
  source        = "./modules/ec2_instance"
  instance_name = "devops-web"
  ami_id        = var.ami_id
  instance_type = "t3.micro"

  vpc_id    = data.aws_vpc.default.id
  subnet_id = local.default_subnet_id

  # lock to my IP only (port 80 and 22)
  allowed_cidr = "${var.allowed_ip}/32"

  # optional: set an existing EC2 key pair name if we want SSH
  key_name = ""

  user_data = local.web_user_data
}
