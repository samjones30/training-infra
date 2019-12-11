data "aws_ami" "aws_linux_ami" {
  most_recent = true
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }
  owners = ["137112412989"] # Amazon
}

resource "random_string" "db_pwd" {
 length = 16
 special = true
}
