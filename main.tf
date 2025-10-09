locals {
  image_ref        = "${var.dockerhub_repo}:${var.dockerhub_tag}"
  tags             = { Project = var.project_name }
  ami_id_effective = coalesce(var.ami_id, data.aws_ssm_parameter.al2_ami.value)
}

# ---------------- Task 2 prerequisite: S3 bucket ----------------
module "s3" {
  source        = "./modules/s3_bucket"
  project_name  = var.project_name
  bucket_suffix = "docker-images"
  tags          = local.tags
}


# Replace IMAGE_REF within the userdata file (simple and readable)
# ---------------- Task 1: EC2 runs NGINX container ----------------
data "template_file" "task1_userdata" {
  template = file("${path.module}/userdata_run_nginx.sh")
  vars = {
    dockerhub_image = local.image_ref # e.g., kenyonjared/nginx-hands-on:latest
  }
}

module "task1_ec2" {
  source        = "./modules/ec2_instance"
  name          = "${var.project_name}-task1"
  ami_id        = local.ami_id_effective
  instance_type = var.instance_type
  user_data     = data.template_file.task1_userdata.rendered
  allowed_cidr  = var.allowed_cidr
  enable_ssh    = false
  key_name      = var.key_name
  tags          = local.tags
}

# ---------------- Task 2: EC2 pulls image -> uploads to S3 ----------
data "template_file" "task2_userdata" {
  template = file("${path.module}/userdata_pull_save_upload.sh")
  vars = {
    dockerhub_image = local.image_ref
    bucket_name     = module.s3.bucket_name
  }
}

module "task2_ec2" {
  source               = "./modules/ec2_instance"
  name                 = "${var.project_name}-task2"
  ami_id               = local.ami_id_effective
  instance_type        = var.instance_type
  user_data            = data.template_file.task2_userdata.rendered
  allowed_cidr         = var.allowed_cidr
  enable_ssh           = false
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.task2_profile.name
  tags                 = local.tags
}

# Task 3: verify by running from S3 tar
data "template_file" "task3_userdata" {
  template = file("${path.module}/userdata_run_from_s3.sh")
  vars = {
    BUCKET = module.s3.bucket_name
    KEY    = "image.tar"
    IMAGE  = local.image_ref           # kenyonjared/nginx-hands-on:latest
  }
}

module "task3_ec2" {
  source        = "./modules/ec2_instance"
  name          = "${var.project_name}-task3"
  ami_id        = local.ami_id_effective
  instance_type = var.instance_type
  user_data     = data.template_file.task3_userdata.rendered
  allowed_cidr  = var.allowed_cidr     # keeps HTTP limited to your IP
  enable_ssh    = false
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.task3_profile.name
  tags          = local.tags
}
