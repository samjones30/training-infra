
variable "aws_region" {
    default = "eu-west-2"
}

variable "vpc_cidr" {
    default = "10.2.0.0/16"
}

variable "public_subnet1_cidr" {
    default = "10.2.1.0/24"
}

variable "public_subnet2" {
    default = "eu-west-2b"
}

variable "public_subnet1_cidr" {
    default = "10.2.0.0/24"
}

variable "public_subnet1" {
    default = "eu-west-2a"
}

variable "mgmt_subnet1_cidr" {
    default = "10.2.10.0/24"
}

variable "mgmt_subnet1" {
    default = "eu-west-2a"
}

variable "private_subnet2_cidr" {
    default = "10.2.2.0/24"
}

variable "private_subnet2" {
    default = "eu-west-2b"
}

variable "private_subnet1_cidr" {
    default = "10.2.3.0/24"
}

variable "private_subnet_1" {
    default = "eu-west-2a"
}

variable "cidr_internet" {
    default = "0.0.0.0/0"
}

variable "aws_key_name" {
    default = "management-key"
}

variable "database_name" {
    default = "mysql-web-db"
}

variable "database_user" {
    default = "aws_dba_user"
}
