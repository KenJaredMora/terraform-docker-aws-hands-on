variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "allowed_ip" {
  type        = string
  description = "Here my public IP (no needed the termination /32 because the module appends it)"
}

variable "ami_id" {
  type        = string
  description = "Amazon Linux 2023 AMI"
}

variable "docker_image" {
  type        = string
  description = "Docker image to run on EC2"
}

variable "s3_bucket_name" {
  type        = string
  default     = ""
  description = ""
}
