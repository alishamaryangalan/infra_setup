resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc_demo.id

  tags = {
    Name = "gateway"
  }
}

# resource "aws_internet_gateway_attachment" "attachment" {
#   internet_gateway_id = aws_internet_gateway.gateway.id
#   vpc_id              = aws_vpc.vpc_demo.id
# }