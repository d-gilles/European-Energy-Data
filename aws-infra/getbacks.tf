
provider "local" {
}

resource "local_file" "bucket_name_file" {
  content  = aws_s3_bucket.datalake.bucket
  filename = "${path.module}/infra_details/bucketname.txt"
}

resource "local_file" "alb_dns_name_file" {
  content  = aws_alb.application_load_balancer.dns_name
  filename = "${path.module}/infra_details/alb_dns_name.txt"
}

