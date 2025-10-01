resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name != "" ? var.bucket_name : "devops-hands-on-${random_string.suffix.result}"
  tags = {
    Name = var.bucket_name != "" ? var.bucket_name : "devops-hands-on"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}
