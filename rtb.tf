resource "aws_route_table" "public-rtb" {
    vpc_id = "${aws_vpc.infra-training-vpc.id}"
    route {
        cidr_block = "${var.cidr_internet}"
        gateway_id = "${aws_internet_gateway.infra-training-igw.id}"
    }

    tags = {
        Name = "Public RTB"
        Terraform = true
    }
}

resource "aws_route_table" "mgmt-rtb" {
    vpc_id = "${aws_vpc.infra-training-vpc.id}"
    route {
        cidr_block = "${var.cidr_internet}"
        gateway_id = "${aws_internet_gateway.infra-training-igw.id}"
    }

    tags = {
        Name = "Mgmt RTB"
        Terraform = true
    }
}

resource "aws_route_table_association" "public1-rtb-assoc" {
    subnet_id = "${aws_subnet.eu-west-2a-public.id}"
    route_table_id = "${aws_route_table.public-rtb.id}"
}

resource "aws_route_table_association" "public2-rtb-assoc" {
    subnet_id = "${aws_subnet.eu-west-2b-public.id}"
    route_table_id = "${aws_route_table.public-rtb.id}"
}

resource "aws_route_table_association" "mgmt-rtb-assoc" {
    subnet_id = "${aws_subnet.mgmt_subnet1.id}"
    route_table_id = "${aws_route_table.mgmt-rtb.id}"
}
