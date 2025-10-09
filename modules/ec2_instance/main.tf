terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

# Use default VPC/subnet automatically if none passed
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
  chosen_vpc_id    = coalesce(var.vpc_id, data.aws_vpc.default.id)
  chosen_subnet_id = coalesce(var.subnet_id, data.aws_subnets.default_vpc_subnets.ids[0])
}

# IMPORTANT: resource name is "web" (not "this")
resource "aws_security_group" "web" {
  name        = "${var.name}-sg"
  description = "HTTP from allowed_cidr; optional SSH"
  vpc_id      = local.chosen_vpc_id

  # HTTP locked to your laptop IP (allowed_cidr)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  # Optional SSH rule, controlled by enable_ssh
  dynamic "ingress" {
    for_each = var.enable_ssh ? [1] : []
    content {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.ssh_cidr]
    }
  }

  egress {
    description = "all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = local.chosen_subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile
  user_data            = var.user_data
  user_data_replace_on_change = true

  tags = merge(var.tags, { Name = var.name })
}
