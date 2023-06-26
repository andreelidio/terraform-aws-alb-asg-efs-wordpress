resource "aws_db_instance" "mysql" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.m3.2xlarge"
  username               = "admin"
  password               = "xyz789$X"
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = "${aws_db_subnet_group.aws_db_subnet_group_for_database.id}"
  vpc_security_group_ids = [aws_security_group.sg_mysql.id]
  skip_final_snapshot    = true
}