resource "aws_subnet" "eu-west-2a-public" {
    vpc_id = "${aws_vpc.infra-training-vpc.id}"
    availability_zone = "${var.public_subnet1}"
    cidr_block = "${var.public_subnet1_cidr}"
    map_public_ip_on_launch = true
    tags = {
        Name = "Infra Training Public Subnet 1 (eu-west-2a)"
        Terraform = true
    }
}

resource "aws_subnet" "eu-west-2b-public" {
    vpc_id = "${aws_vpc.infra-training-vpc.id}"
    availability_zone = "${var.public_subnet2}"
    cidr_block = "${var.public_subnet2_cidr}"
    map_public_ip_on_launch = true
    tags = {
        Name = "Infra Training Public Subnet 2 (eu-west-2b)"
        Terraform = true
    }
}

resource "aws_subnet" "eu-west-2a-private" {
    vpc_id = "${aws_vpc.infra-training-vpc.id}"
    cidr_block = "${var.private_subnet1_cidr}"
    availability_zone = "${var.private_subnet1}"

    tags = {
        Name = "Infra Training Private Subnet 1 (eu-west-2a)"
        Terraform = true
    }
}

resource "aws_subnet" "eu-west-2b-private" {
    vpc_id = "${aws_vpc.infra-training-vpc.id}"
    cidr_block = "${var.private_subnet2_cidr}"
    availability_zone = "${var.private_subnet2}"

    tags = {
        Name = "Infra Training Private Subnet 2 (eu-west-2b)"
        Terraform = true
    }
}

resource "aws_subnet" "mgmt_subnet1" {
    vpc_id = "${aws_vpc.infra-training-vpc.id}"
    availability_zone = "${var.mgmt_subnet1}"
    cidr_block = "${var.mgmt_subnet1_cidr}"

    tags = {
        Name = "Management Subnet 1 (eu-west-2a)"
        Terraform = true
    }
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name        = "db-subnet-group"
  description = " MySQL RDS subnet group"
  subnet_ids  = ["${aws_subnet.eu-west-2b-private.id}", "${aws_subnet.eu-west-2a-private.id}" ]
}
