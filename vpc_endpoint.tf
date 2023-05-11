# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = aws_vpc.vpc_demo.id
#   service_name = "com.amazonaws.${var.region}.s3"
#   #   vpc_endpoint_type = "Gateway"
#   route_table_ids = [aws_route_table.rt_private.id] // Add route_table_ids in the aws_vpc_endpoint resource.
#   policy          = <<POLICY
#     {
#     "Statement": [
#         {
#         "Action": "*",
#         "Effect": "Allow",
#         "Resource": "*",
#         "Principal": "*"
#         }
#     ]
#     }
#     POLICY

#   tags = {
#     Name = "VPC endpoint"
#   }
# }
# output "s3_id" {
#   depends_on = [aws_vpc_endpoint.s3]
#   value      = aws_vpc_endpoint.s3.id
# }

# resource "time_sleep" "delay" {
#   depends_on      = [aws_vpc_endpoint.s3]
#   create_duration = "30s"
# }

# resource "aws_vpc_endpoint_route_table_association" "rt_association_endpoint" {
#   depends_on      = [aws_vpc_endpoint.s3]
#   route_table_id  = aws_route_table.rt_private.id
#   vpc_endpoint_id = aws_vpc_endpoint.s3.id
# }

# resource "aws_route" "private_s3" {
#   depends_on     = [aws_vpc_endpoint.s3, aws_route_table.rt_private, aws_vpc_endpoint_route_table_association.rt_association_endpoint]
#   route_table_id = aws_route_table.rt_private.id
#   # vpc_endpoint_id        = aws_vpc_endpoint.s3.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = "local"
# }

# output "s3id" {
#   depends_on = [aws_route.private_s3]
#   value      = aws_vpc_endpoint.s3.id
# }
