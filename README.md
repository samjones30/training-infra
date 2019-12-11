# Overview
Example infrastructure in AWS for learning tooling, created with Terraform

## Purpose
The terraform plan will create the following:
- A VPC
- Two private subnets, two public subnets
- Two EC2 web servers (in public subnet)
- One RDS Multi-AZ database, MySQL, within the private subnets
- A management VPC containing an EC2 for a bastion/Ansible host
- Internet Gateway and VPN endpoint for the VPC



