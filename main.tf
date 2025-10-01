# Use default VPC for the lab
data "aws_default_vpc" "default" {}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_default_vpc.default.id]
  }
}

locals {
  default_subnet_id = data.aws_subnets.default_vpc_subnets.ids[0]

  # Install Docker and run your Docker Hub image
  web_user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl enable docker
    systemctl start docker
    docker run -d -p 80:80 ${var.docker_image}
  EOF
}

module "web_server" {
  source        = "./modules/ec2_instance"
  instance_name = "devops-web"
  ami_id        = var.ami_id
  instance_type = "t2.micro"

  vpc_id   = data.aws_default_vpc.default.id
  subnet_id = local.default_subnet_id

  # lock to your IP only (port 80 and 22)
  allowed_cidr = "${var.allowed_ip}/32"

  # optional: set an existing EC2 key pair name if you want SSH
  key_name = ""

  user_data = local.web_user_data
}
