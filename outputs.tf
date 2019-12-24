output "vpc_id" {
  value = "${aws_vpc.infra-training-vpc.id}"
}

output "bastion-ip" {
  value       = "${aws_instance.bastion.public_ip}"
  description = "The public IP of the bastion server."
}

output "web1-ip" {
  value       = "${aws_instance.webserver-1}"
  description = "The private IP of web server1."
}

output "web2-ip" {
  value       = "${aws_instance.webserver-2}"
  description = "The private IP of web server2."
}

output "db_user" {
  value       = "${aws_db_instance.web_db.username}"
  description = "The password for logging in to the database."
}

output "db_password" {
  value       = "${aws_db_instance.web_db.password}"
  description = "The password for logging in to the database."
}

output "db_dns" {
  value       = "${aws_db_instance.web_db.endpoint}"
  description = "The password for logging in to the database."
}
