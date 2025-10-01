resource "aws_iam_role" "s3_upload_role" {
  name = "ec2-s3-upload-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "s3_upload_policy" {
  name = "AllowS3PutObject"
  role = aws_iam_role.s3_upload_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["s3:ListBucket"], Resource = module.s3_bucket.bucket_arn },
      { Effect = "Allow", Action = ["s3:PutObject"],  Resource = "${module.s3_bucket.bucket_arn}/*" }
    ]
  })
}

resource "aws_iam_instance_profile" "s3_upload_profile" {
  name = aws_iam_role.s3_upload_role.name
  role = aws_iam_role.s3_upload_role.name
}
