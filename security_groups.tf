resource "aws_security_group" "dbsg" {
    name = "db-sg"
    description = "Allow incoming database connections."
    vpc_id = "${aws_vpc.infra-training-vpc.id}"

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = ["${aws_security_group.web-sg.id}","${aws_security_group.mgmt-sg.id}"]
    }

    tags = {
        Name = "Database-SG"
        Terraform = true
    }
}

resource "aws_security_group" "web-sg" {
    name = "web-server-sg"
    description = "Allow incoming HTTP(S) connections."
    vpc_id = "${aws_vpc.infra-training-vpc.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.cidr_internet}"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.cidr_internet}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "ssh"
        security_groups = [$"{aws_security_group.mgmt-sg.id}"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        security_groups = [$"{aws_security_group.mgmt-sg.id}"]
    }
    egress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [$"{aws_security_group.dbsg.id}"]
    }

    tags = {
        Name = "Web Server SG"
        Terraform = true
    }
}

resource "aws_security_group" "mgmt-sg" {
    name = "mgmt-sg"
    description = "Allow incoming ssh connections."
    vpc_id = "${aws_vpc.infra-training-vpc.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "ssh"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "ssh"
        security_groups = [${aws_security_group.web-sg.id}]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        security_groups = [${aws_security_group.web-sg.id}]
    }
    egress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [${aws_security_group.dbsg.id}]
    }

    tags = {
        Name = "Mgmt-sg"
        Terraform = true
    }
}
