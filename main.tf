# Terraform - .tf file for automate the AWS Cloud Infrastructure

provider "aws" {
    access_key = "AKIA5CYNUHQPY34NIV4B"
    secret_key = "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"
    region = "us-east-1"
}
resource "aws_db_instance" "db" {
  allocated_storage    = 10
  db_name              = "database1"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "octet"
  password             = "Yoctet3290"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

resource "aws_s3_bucket" "b" {
  bucket = "octet-bucket"
}

resource "aws_ecr_repository" "ecr-repo" {
  name                 = "godigital"
  image_tag_mutability = "MUTABLE"
}

resource "aws_lambda_function" "lambda" {
  function_name = "s3_to_rds_lambda"
  package_type  = "Image"  # Set package type to Image

  # Docker image URI from ECR
  image_uri = "899287366687.dkr.ecr.us-east-1.amazonaws.com/godigital:latest"

  timeout = 900  # Adjust based on your processing time

  environment {
    variables = {
      RDS_HOST        = "mydatabase.example.com"
      RDS_DB_NAME     = "database1"
      RDS_USER        = "octet"
      RDS_PASSWORD    = "Yoctet3290"
      S3_BUCKET_NAME  = "octet-bucket"
    }
  }

  # Lambda needs permissions, defined via IAM role
  role = aws_iam_role.lambda_role.arn
}


resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "rds:DescribeDBInstances",
          "rds:ExecuteStatement",
          "rds:BatchExecuteStatement"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}


