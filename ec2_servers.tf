

resource "aws_instance" "webserver-1" {
    ami = "${data.aws_ami.aws_linux_ami.id}"
    availability_zone = "${var.public_subnet1}"
    instance_type = "t3.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
    subnet_id = "${aws_subnet.eu-west-2a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags = {
        Name = "Webserver 1"
        Terraform = true
    }
}

resource "aws_instance" "webserver-2" {
    ami = "${data.aws_ami.aws_linux_ami.id}"
    availability_zone = "${var.public_subnet2}"
    instance_type = "t3.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
    subnet_id = "${aws_subnet.eu-west-2b-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags = {
        Name = "Webserver 2"
        Terraform = true
    }
}

resource "aws_instance" "bastion" {
    ami = "${data.aws_ami.aws_linux_ami.id}"
    availability_zone = "${var.mgmt_subnet1}"
    instance_type = "t3.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.mgmt-sg.id}"]
    subnet_id = "${aws_subnet.mgmt_subnet1.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags = {
        Name = "Bastion and Ansible Server"
        Terraform = true
    }
}
