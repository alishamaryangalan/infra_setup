resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_demo.id
  tags = {
    Name = "Private Subnet Route Table"
  }
}

resource "aws_route_table_association" "rt_associate_private" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rt_private.id
}
