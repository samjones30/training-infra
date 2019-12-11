resource "aws_vpc" "infra-training-vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    instance_tenancy     = "default"
    enable_dns_support   = true
    tags = {
        Name = "infra-training-vpc"
        Terraform = true
    }
}

resource "aws_internet_gateway" "infra-training-igw" {
    vpc_id = "${aws_vpc.infra-training-vpc.id}"

    tags = {
        Name = "infra-training-igw"
        Terraform = true
    }
}
