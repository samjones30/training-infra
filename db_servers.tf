# Create new DB
resource "aws_db_instance" "web_db" {
  identifier = "${var.database_name}"
  allocated_storage = 20
  storage_type = "gp2"
  engine  = "mysql"
  engine_version = "5.6.40"
  instance_class = "db.t3.micro"
  name     = "${var.database_name}"
  username = "${var.database_user}"
  password = "${random_string.db_pwd.result}"
  parameter_group_name = "default.mysql5.6"
  db_subnet_group_name = "${aws_db_subnet_group.db-subnet-group.id}"
  vpc_security_group_ids = ["${aws_security_group.dbsg.id}"]
  backup_retention_period = 0
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"

  tags = {
      Name = "Web DB Server"
      Terraform = true
      Engine = "MySQL"
  }
}
