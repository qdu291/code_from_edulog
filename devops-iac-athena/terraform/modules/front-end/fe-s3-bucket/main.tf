locals {
  bucket_name = "ath-fe-${var.fe_bucket}"
}

resource "aws_iam_role" "this" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "fe-bucket-policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this.arn]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
    ]
  }
}

module "fe_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.1.1"

  bucket = local.bucket_name
  acl    = "public-read"
  website = {
    index_document = "index.html"
    error_document = "error.html"
  }
  cors_rule = [
    {
      allowed_methods = ["PUT", "POST"]
      allowed_origins = ["*"]
      allowed_headers = ["*"]
      max_age_seconds = 3600
    }
  ]

  object_lock_configuration = {
    rule = {
      default_retention = {
        mode = "GOVERNANCE"
        days = 1
      }
    }
  }

  attach_policy = true
  policy        = data.aws_iam_policy_document.fe-bucket-policy.json
}

