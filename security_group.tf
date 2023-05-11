resource "aws_security_group" "sg" {
  name        = "WebAppSecurityGroup"
  description = "Security group for ec2"
  vpc_id      = aws_vpc.vpc_demo.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.load_balancer_security_group.id]
  }
  # ingress {
  #  from_port   = 80
  #  to_port     = 80
  #  protocol    = "tcp"
  #  cidr_blocks = ["0.0.0.0/0"]
  # }
  # ingress {
  #  from_port   = 443
  #  to_port     = 443
  #  protocol    = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  #  security_groups = [aws_security_group.load_balancer_security_group.id]
  # }
  ingress {
    from_port = var.webapp_port
    to_port   = var.webapp_port
    protocol  = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "application Security Group"
  }
}

resource "aws_security_group" "sg_db" {
  name_prefix = "sg_database"
  description = "Security group for database - postgres"
  vpc_id      = aws_vpc.vpc_demo.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "database Security Group"
  }
}
resource "aws_security_group" "load_balancer_security_group" {
  name_prefix = "load_balancer_security_group"
  description = "security group for load balancer"
  vpc_id      = aws_vpc.vpc_demo.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "load_balancer_security_group"
  }
}