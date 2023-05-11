resource "aws_db_parameter_group" "custom_pg" {
  name        = "custom-params-group"
  family      = "postgres13"
  description = "Custom parameter group for Postgres 13"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_db_instance" "rds" {
  identifier              = var.rds_identifier
  engine                  = "postgres"
  engine_version          = "13.4"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10
  db_name                 = var.rds_db_name
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = aws_db_parameter_group.custom_pg.name
  backup_retention_period = 7
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.sg_db.id]
  multi_az                = false
  db_subnet_group_name    = aws_db_subnet_group.subnet_rds.name
  kms_key_id              = aws_kms_key.rds_encryption_key.arn
  storage_encrypted       = true
}