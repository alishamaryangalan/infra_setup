resource "aws_db_instance" "rds" {
  identifier              = var.rds_identifier
  engine                  = "postgres"
  engine_version          = "13.4"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10
  db_name                 = var.rds_db_name
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = "default.postgres13"
  backup_retention_period = 7
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.sg_db.id]
  multi_az                = false
  db_subnet_group_name    = aws_db_subnet_group.subnet_rds.name
}



