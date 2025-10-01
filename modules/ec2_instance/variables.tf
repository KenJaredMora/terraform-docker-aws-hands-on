variable "instance_name" {
    description = "Name tag for the EC2 instance"
    type        = string
}

variable "ami_id" {
    description = "AMI ID to use for the EC2 instance"
    type        = string
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t3.micro"
}

variable "key_name" {
    description = "Key pair name for SSH access"
    type        = string
    default     = ""
}

variable "allowed_cidr" {
    description = "CIDR block allowed to access the instance"
    type        = string
}

variable "user_data" {
    description = "User data script to run on instance launch"
    type        = string
    default     = ""
}

variable "iam_instance_profile" {
    description = "IAM instance profile name"
    type        = string
    default     = ""
}

variable "vpc_id" {
    description = "VPC ID where the instance will be deployed"
    type        = string
}

variable "subnet_id" {
    description = "Subnet ID for the EC2 instance"
    type        = string
}
