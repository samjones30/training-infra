

resource "aws_instance" "webserver-1" {
    ami = "${data.aws_ami.aws_linux_ami.id}"
    availability_zone = "${var.public_subnet1}"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
    subnet_id = "${aws_subnet.web_subnet1.id}"
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
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
    subnet_id = "${aws_subnet.web_subnet2.id}"
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
    instance_type = "t2.micro"
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

resource "aws_lb_target_group" "web-tg" {
  name     = "web-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.infra-training-vpc.id}"
}

resource "aws_lb_target_group_attachment" "web-tg-attach1" {
  target_group_arn = "${aws_lb_target_group.web-tg.arn}"
  target_id        = "${aws_instance.webserver-1.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "web-tg-attach2" {
  target_group_arn = "${aws_lb_target_group.web-tg.arn}"
  target_id        = "${aws_instance.webserver-2.id}"
  port             = 80
}

resource "aws_lb" "web-lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.web-lb-sg.id}"]
  subnets            = ["${aws_subnet.web_subnet1.id}","${aws_subnet.web_subnet2.id}"]

  enable_deletion_protection = false

  tags = {
      Name = "Web load balanacer"
      Terraform = true
  }
}

resource "aws_lb_listener" "web_lb_listener" {
  load_balancer_arn = "${aws_lb.web-lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.web-tg.arn}"
  }
}
