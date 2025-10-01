output "web_public_ip" {
  value       = module.web_server.public_ip
  description = "Public IP of the NGINX web server"
}