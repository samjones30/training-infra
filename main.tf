##########################
###Provider and backend###
##########################

provider "aws" {
  region      = var.aws_region
  version     = "~> 2.7"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket          = "training-infra-tf-state-management"
    key             = "global/s3/terraform.tfstate"
    region          = "eu-west-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table  = "training-infra-tf-lock-management"
    encrypt         = true
  }
}

#########################
###Set up data sources###
#########################

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
  length  = 16
  special = true
}

data "aws_elb_service_account" "main" {}
data "aws_caller_identity" "current" {}

##################################
###Create VPC, Subnets and ACLs###
##################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "infra-training-vpc"
  cidr = "${var.vpc_cidr}"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  database_subnets = ["${var.private_subnet1_cidr}", "${var.private_subnet2_cidr}"]
  public_subnets  = ["${var.public_subnet1_cidr}", "${var.public_subnet2_cidr}"]

  enable_dns_hostnames = true
  instance_tenancy     = "default"
  enable_dns_support   = true

  public_dedicated_network_acl     = true
  public_inbound_acl_rules        = concat(
    local.network_acls["default_inbound"],
    local.network_acls["public_inbound"],
  )
  public_outbound_acl_rules       = local.network_acls["default_outbound"]

  database_dedicated_network_acl  = true
  database_inbound_acl_rules      = local.network_acls["database_inbound"]
  database_outbound_acl_rules     = local.network_acls["database_outbound"]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "public-subnet-webs"
    Terraform = "true"
  }

  database_subnet_tags = {
    Name = "database-subnet"
    Terraform = "true"
  }
}
#######################
###ACL configuration###
#######################

locals {
  network_acls = {
    default_inbound = [
      {
        rule_number = 900
        rule_action = "allow"
        icmp_code   = -1
        icmp_type   = -1
        protocol    = "icmp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
    default_outbound = [
      {
        rule_number = 900
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
    public_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 110
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 120
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      }
    ]
    database_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_block  = "${var.vpc_cidr}"
      }
    ]
    database_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_block  = "${var.vpc_cidr}"
      }
    ]
  }
}


###################
###Create RDS DB###
###################
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "${var.database_name}"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.micro"
  allocated_storage = 20

  name     = "${var.database_name}"
  username = "${var.database_user}"
  password = "${random_string.db_pwd.result}"
  port     = "3306"

  iam_database_authentication_enabled = true
  vpc_security_group_ids = ["${aws_security_group.dbsg.id}"]
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  backup_retention_period	= "0"

  tags = {
    Name      = "Web DB Server"
    Terraform = true
    Engine    = "MySQL"
  }

  # DB subnet group
  subnet_ids = ["${module.vpc.database_subnets[0]}", "${module.vpc.database_subnets[1]}"]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"
}

resource "aws_security_group" "dbsg" {
  name        = "db-sg"
  description = "Allow incoming database connections."
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web-sg.id}"]
  }

  tags = {
    Name      = "Database-SG"
    Terraform = true
  }
}

########################
###Create EC2 Servers###
########################

module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "web-server-cluster"
  instance_count         = "${var.ec2_instances}"

  ami                    = "${data.aws_ami.aws_linux_ami.id}"
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"
  monitoring             = true
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
  subnet_ids              = "${module.vpc.public_subnets}"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "web-sg" {
  name        = "web-server-sg"
  description = "Allow incoming HTTP(S) connections."
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_internet}"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_internet}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_internet}"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.cidr_internet}"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_internet}"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_internet}"]
  }
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.private_subnet1_cidr}"]
  }
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.private_subnet2_cidr}"]
  }

  tags = {
    Name      = "Web Server SG"
    Terraform = true
  }
}

#########################
###Create ELB for Webs###
#########################

module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  name = "web-lb"

  subnets         = module.vpc.public_subnets
  security_groups = ["${aws_security_group.web-lb-sg.id}"]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    }
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  // ELB attachments
  number_of_instances = "${var.ec2_instances}"
  instances           = module.ec2_cluster.id

  tags = {
    Name      = "web-lb"
    Terraform = true
  }
}

resource "aws_security_group" "web-lb-sg" {
  name        = "web-lb-sg"
  description = "Allow traffic to load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_internet}"]
  }
  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web-sg.id}"]
  }

  tags = {
    Name      = "web-lb-sg"
    Terraform = true
  }
}
