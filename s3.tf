resource "aws_s3_bucket" "s3_lb_logs" {
  bucket = "infra-training-s3"
  acl    = "private"

  tags = {
    Name        = "Load balancer access log bucket"
    Terraform   = true
  }
}
