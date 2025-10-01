variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "allowed_ip" {
  type        = string
  description = "Your public IP (no /32)"
}

variable "ami_id" {
  type        = string
  description = "Amazon Linux 2023 AMI"
}

variable "docker_image" {
  type        = string
  description = "Docker image to run on EC2"
}
