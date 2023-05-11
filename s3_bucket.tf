resource "aws_s3_bucket" "private_bucket" {
  bucket        = "s3-bucket-${var.profile}-${var.region}-${uuid()}"
  force_destroy = true
  acl           = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
  lifecycle_rule {
    prefix  = "config/"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
  tags = {
    Name = "s3-bucket-${var.profile}-${var.region}-${uuid()}"
  }
}

#Block public access for S3 bucket
resource "aws_s3_bucket_public_access_block" "s3_pub_accessBlock" {
  bucket              = aws_s3_bucket.private_bucket.id
  block_public_acls   = true
  block_public_policy = true
}

