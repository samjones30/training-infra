resource "aws_subnet" "web_subnet1" {
    vpc_id = "${aws_vpc.infra-training-vpc.id}"
    availability_zone = "${var.public_subnet1}"
    cidr_block = "${var.public_subnet1_cidr}"
    map_public_ip_on_launch = true
    tags = {
        Name = "Infra Training Public Subnet 1 (eu-west-2a)"
        Terraform = true
    }
}

resource "aws_subnet" "web_subnet2" {
    vpc_id = "${aws_vpc.infra-training-vpc.id}"
    availability_zone = "${var.public_subnet2}"
    cidr_block = "${var.public_subnet2_cidr}"
    map_public_ip_on_launch = true
    tags = {
        Name = "Infra Training Public Subnet 2 (eu-west-2b)"
        Terraform = true
    }
}

resource "aws_subnet" "db_subnet1" {
    vpc_id = "${aws_vpc.infra-training-vpc.id}"
    cidr_block = "${var.private_subnet1_cidr}"
    availability_zone = "${var.private_subnet1}"

    tags = {
        Name = "Infra Training Private Subnet 1 (eu-west-2a)"
        Terraform = true
    }
}

resource "aws_subnet" "db_subnet2" {
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


resource "aws_network_acl" "db-subnet-acl" {
  vpc_id = "${aws_vpc.infra-training-vpc.id}"
  subnet_ids = ["${aws_subnet.db_subnet1.id}","${aws_subnet.db_subnet2.id}"]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${aws_vpc.infra-training-vpc.cidr_block}"
    from_port  = 3306
    to_port    = 3306
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${aws_vpc.infra-training-vpc.cidr_block}"
    from_port  = 3306
    to_port    = 3306
  }

  tags = {
  Name = "DB Subnet ACL"
  Terraform = true
  }
}

resource "aws_network_acl" "web-subnet-acl" {
  vpc_id = "${aws_vpc.infra-training-vpc.id}"
  subnet_ids = ["${aws_subnet.web_subnet1.id}","${aws_subnet.web_subnet2.id}"]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.cidr_internet}"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.cidr_internet}"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "ssh"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${aws_vpc.infra-training-vpc.cidr_block}"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "icmp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${aws_vpc.infra-training-vpc.cidr_block}"
    from_port  = -1
    to_port    = -1
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${var.cidr_internet}"
    from_port  = 1024
    to_port    = 65536
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${aws_vpc.infra-training-vpc.cidr_block}"
    from_port  = 0
    to_port    = 65536
  }

  tags = {
  Name = "Web Subnet ACL"
  Terraform = true
  }
}

resource "aws_network_acl" "mgmt-subnet-acl" {
  vpc_id = "${aws_vpc.infra-training-vpc.id}"
  subnet_ids = ["${aws_subnet.mgmt_subnet1.id}"]

  ingress {
    protocol   = "ssh"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${aws_vpc.infra-training-vpc.cidr_block}"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "icmp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${aws_vpc.infra-training-vpc.cidr_block}"
    from_port  = -1
    to_port    = -1
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${var.cidr_internet}"
    from_port  = 0
    to_port    = 65536
  }

  tags = {
  Name = "Mgmt Subnet ACL"
  Terraform = true
  }
}
