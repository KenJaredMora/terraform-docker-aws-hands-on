variable "project_name" {
  type = string
}

variable "bucket_suffix" {
  type    = string
  default = "docker-images"
}

variable "force_destroy" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
