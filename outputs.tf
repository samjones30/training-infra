# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# Subnets
output "database_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.database_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# Network ACLs
output "public_network_acl_id" {
  description = "ID of the public network ACL"
  value       = module.vpc.public_network_acl_id
}

output "database_network_acl_id" {
  description = "ID of the database network ACL"
  value       = module.vpc.database_network_acl_id
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = module.vpc.default_network_acl_id
}

output "module_vpc" {
  description = "Module VPC"
  value       = module.vpc
}

output "this_db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db.this_db_instance_address
}

output "this_db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db.this_db_instance_arn
}

output "this_db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db.this_db_instance_availability_zone
}

output "this_db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db.this_db_instance_endpoint
}

output "this_db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.db.this_db_instance_hosted_zone_id
}

output "this_db_instance_id" {
  description = "The RDS instance ID"
  value       = module.db.this_db_instance_id
}

output "this_db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.db.this_db_instance_resource_id
}

output "this_db_instance_status" {
  description = "The RDS instance status"
  value       = module.db.this_db_instance_status
}

output "this_db_instance_name" {
  description = "The database name"
  value       = module.db.this_db_instance_name
}

output "this_db_instance_username" {
  description = "The master username for the database"
  value       = module.db.this_db_instance_username
}

output "this_db_instance_port" {
  description = "The database port"
  value       = module.db.this_db_instance_port
}

output "this_db_instance_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  value       = module.db.this_db_instance_ca_cert_identifier
}

output "this_db_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.db.this_db_subnet_group_id
}

output "this_db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.db.this_db_subnet_group_arn
}

output "this_db_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.db.this_db_parameter_group_id
}

output "this_db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.db.this_db_parameter_group_arn
}

# DB option group
output "this_db_option_group_id" {
  description = "The db option group id"
  value       = module.db.this_db_option_group_id
}

output "this_db_option_group_arn" {
  description = "The ARN of the db option group"
  value       = module.db.this_db_option_group_arn
}

##ec2 output
output "id" {
  description = "List of IDs of instances"
  value       = module.ec2_cluster.*.id
}

output "arn" {
  description = "List of ARNs of instances"
  value       = module.ec2_cluster.*.arn
}

output "availability_zone" {
  description = "List of availability zones of instances"
  value       = module.ec2_cluster.*.availability_zone
}

output "placement_group" {
  description = "List of placement groups of instances"
  value       = module.ec2_cluster.*.placement_group
}

output "key_name" {
  description = "List of key names of instances"
  value       = module.ec2_cluster.*.key_name
}

output "password_data" {
  description = "List of Base-64 encoded encrypted password data for the instance"
  value       = module.ec2_cluster.*.password_data
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = module.ec2_cluster.*.public_dns
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = module.ec2_cluster.*.public_ip
}

output "ipv6_addresses" {
  description = "List of assigned IPv6 addresses of instances"
  value       = module.ec2_cluster.*.ipv6_addresses
}

output "primary_network_interface_id" {
  description = "List of IDs of the primary network interface of instances"
  value       = module.ec2_cluster.*.primary_network_interface_id
}

output "private_dns" {
  description = "List of private DNS names assigned to the instances. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = module.ec2_cluster.*.private_dns
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = module.ec2_cluster.*.private_ip
}

output "security_groups" {
  description = "List of associated security groups of instances"
  value       = module.ec2_cluster.*.security_groups
}

output "vpc_security_group_ids" {
  description = "List of associated security groups of instances, if running in non-default VPC"
  value       = module.ec2_cluster.*.vpc_security_group_ids
}

output "subnet_id" {
  description = "List of IDs of VPC subnets of instances"
  value       = module.ec2_cluster.*.subnet_id
}

output "credit_specification" {
  description = "List of credit specification of instances"
  value       = module.ec2_cluster.*.credit_specification
}

output "instance_state" {
  description = "List of instance states of instances"
  value       = module.ec2_cluster.*.instance_state
}

output "tags" {
  description = "List of tags of instances"
  value       = module.ec2_cluster.*.tags
}

output "volume_tags" {
  description = "List of tags of volumes of instances"
  value       = module.ec2_cluster.*.volume_tags
}
