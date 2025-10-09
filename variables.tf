variable "project_name" {
  type    = string
  default = "tf-docker-hands-on"
}
variable "region" {
  type    = string
  default = "us-east-1"
}
variable "profile" {
  type    = string
  default = "default"
}

variable "ami_id" {
  type    = string
  default = null
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "key_name" {
  type    = string
  default = null
}

# Your Docker Hub repo and tag, e.g. "kenyon/nginx-hands-on" and "latest"
variable "dockerhub_repo" {
  type = string
}
variable "dockerhub_tag" {
  type    = string
  default = "latest"
}

# Restrict HTTP to your laptop: pass X.X.X.X/32 (find your public IP in a browser: "what is my ip")
variable "allowed_cidr" {
  type = string
}
