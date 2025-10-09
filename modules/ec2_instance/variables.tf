variable "name" {
  type = string
}

variable "ami_id" {
  type    = string
  default = null
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "user_data" {
  type    = string
  default = ""
}
variable "allowed_cidr" {
  type        = string
  description = "e.g., 203.0.113.25/32"
}
variable "enable_ssh" {
  type    = bool
  default = false
}
variable "ssh_cidr" {
  type    = string
  default = "127.0.0.1/32"
}
variable "key_name" {
  type    = string
  default = null
}
variable "iam_instance_profile" {
  type    = string
  default = null
}
variable "vpc_id" {
  type    = string
  default = null
}
variable "subnet_id" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
