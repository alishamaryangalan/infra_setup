resource "aws_vpc" "vpc_demo" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "vpc_demo"
  }
}
