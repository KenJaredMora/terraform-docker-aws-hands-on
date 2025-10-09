output "task1_public_dns" { value = module.task1_ec2.public_dns }
output "task1_public_ip" { value = module.task1_ec2.public_ip }

output "task2_public_dns" { value = module.task2_ec2.public_dns }
output "task2_public_ip" { value = module.task2_ec2.public_ip }

output "s3_bucket_name" { value = module.s3.bucket_name }

output "task3_public_dns" { value = module.task3_ec2.public_dns }
output "task3_public_ip"  { value = module.task3_ec2.public_ip }