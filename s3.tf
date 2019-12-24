resource "aws_s3_bucket" "s3_lb_logs" {
  bucket = "infra-training-s3"
  acl    = "private"

  tags = {
    Name      = "Load balancer access log bucket"
    Terraform = true
  }
}

resource "aws_s3_bucket_policy" "s3_lb_log_policy" {
  bucket = "${aws_s3_bucket.s3_lb_logs.id}"
  policy = <<POLICY
{
    "Id": "Policy",
    "Version": "2012-10-17",
    "Statement": [{
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${data.aws_elb_service_account.main.arn}"
                ]
            },
            "Action": [
                "s3:PutObject"
            ],
            "Resource": "${aws_s3_bucket.s3_lb_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": [
                "s3:PutObject"
            ],
            "Resource": "${aws_s3_bucket.s3_lb_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": [
                "s3:GetBucketAcl"
            ],
            "Resource": "${aws_s3_bucket.s3_lb_logs.arn}"
        }
    ]
}
POLICY
}
