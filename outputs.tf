output "web_public_ip" {
  value       = module.web_server.public_ip
  description = "Public IP of the NGINX web server"
}

output "s3_bucket_name" {
  value       = module.s3_bucket.bucket_name
  description = "Name of the S3 bucket created for Task 2"
}
