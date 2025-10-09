# Trust EC2 to assume this role
# Trust policy for EC2
data "aws_iam_policy_document" "assume_ec2" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task3_role" {
  name               = "${var.project_name}-task3-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ec2.json
}

data "aws_iam_policy_document" "s3_read" {
  statement {
    actions   = ["s3:GetObject","s3:ListBucket","s3:GetBucketLocation"]
    resources = [module.s3.bucket_arn, "${module.s3.bucket_arn}/*"]
  }
}

resource "aws_iam_policy" "task3_s3_read" {
  name   = "${var.project_name}-task3-s3-read"
  policy = data.aws_iam_policy_document.s3_read.json
}

resource "aws_iam_role_policy_attachment" "attach_task3_s3_read" {
  role       = aws_iam_role.task3_role.name
  policy_arn = aws_iam_policy.task3_s3_read.arn
}

resource "aws_iam_instance_profile" "task3_profile" {
  name = "${var.project_name}-task3-instance-profile"
  role = aws_iam_role.task3_role.name
}











resource "aws_iam_role" "task2_role" {
  name               = "${var.project_name}-task2-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ec2.json
}

# Allow write to our specific S3 bucket
data "aws_iam_policy_document" "s3_write" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      module.s3.bucket_arn,
      "${module.s3.bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "task2_s3_write" {
  name   = "${var.project_name}-task2-s3-write"
  policy = data.aws_iam_policy_document.s3_write.json
}

resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.task2_role.name
  policy_arn = aws_iam_policy.task2_s3_write.arn
}

resource "aws_iam_instance_profile" "task2_profile" {
  name = "${var.project_name}-task2-instance-profile"
  role = aws_iam_role.task2_role.name
}
