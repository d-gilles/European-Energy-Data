# S3 Bucket für Data Lake
resource "aws_s3_bucket" "datalake" {
  bucket = "${var.app_name}-${var.bucket_name}"
}