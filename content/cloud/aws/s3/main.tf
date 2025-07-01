terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

## Cria um Bucket com nome bucket-example-xpto
resource "aws_s3_bucket" "example" {
  bucket = "bucket-example-xpto"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


## Cria uma Politica de Lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.example.bucket

  rule {
    id = "logs"
    status = "Enabled"

    filter {
      prefix = "logs/"
    }

    transition {
      days = 30
      storage_class   = "STANDARD_IA"
    }

    transition {
      days = 60
      storage_class   = "GLACIER"
    }
    
    expiration {
      days = 90
    }
  }
}