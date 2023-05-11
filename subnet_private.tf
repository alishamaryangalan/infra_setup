resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.vpc_demo.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "private-${count.index + 1}"
  }
}
resource "aws_db_subnet_group" "subnet_rds" {
  name       = "aws-db-subnet-group"
  subnet_ids = [element(aws_subnet.private.*.id, 1), element(aws_subnet.private.*.id, 2), element(aws_subnet.private.*.id, 3)]
}