# resource "aws_ebs_volume" "ebs" {
#   availability_zone = aws_instance.ec2.availability_zone
#   size              = 20
#   type              = "gp2"
#   lifecycle {
#     prevent_destroy = false
#   }
#   depends_on = [
#     aws_instance.ec2,
#   ]
# }

locals {
  rds_endpoint     = aws_db_instance.rds.endpoint
  endpoint_no_port = split(":", local.rds_endpoint)[0]
}

# resource "aws_instance" "ec2" {
#   ami                    = var.ami_id # the ID of the Amazon Machine Image you want to use
#   instance_type          = "t2.micro" # the type of EC2 instance you want to 
#   vpc_security_group_ids = [aws_security_group.sg.id]
#   subnet_id              = aws_subnet.public[1].id
#   key_name               = "ec2"
#   iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
#   ebs_block_device {
#     device_name = "/dev/xvda"
#     volume_size = 10
#     volume_type = "gp2"
#   }
#   root_block_device {
#     volume_size           = 50
#     volume_type           = "gp2"
#     delete_on_termination = true
#   }
#   user_data = <<-EOF
#   #!/bin/bash
#     sudo chmod -R 775 /home/ec2-user/webapp
#     printf "\n" >> /home/ec2-user/webapp/.env
#     printf "DB_ENDPOINT = '${local.endpoint_no_port}'\n" >> /home/ec2-user/webapp/.env
#     printf "DB_NAME = '${aws_db_instance.rds.name}'\n" >> /home/ec2-user/webapp/.env
#     printf "DB_USERNAME = '${aws_db_instance.rds.username}'\n" >> /home/ec2-user/webapp/.env
#     printf "DB_PASSWORD = '${aws_db_instance.rds.password}'\n" >> /home/ec2-user/webapp/.env
#     printf "BUCKET_NAME = '${aws_s3_bucket.private_bucket.bucket}'\n" >> /home/ec2-user/webapp/.env
#     printf "REGION = '${var.region}'\n" >> /home/ec2-user/webapp/.env
#     printf "PORT = '3030'\n" >> /home/ec2-user/webapp/.env
#     printf "filename = 'file'\n" >> /home/ec2-user/webapp/.env
#     sleep 15
#     sudo chmod 777 /home/ec2-user/webapp
#     sudo chmod 777 /home/ec2-user/webapp/uploads
#     # sudo systemctl enable webapp.service
#     # sudo systemctl start webapp.service
#     # sleep 5
#     sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/cloudwatch-config.json -s
#     sudo chmod 777 /home/ec2-user/webapp/logs
#     sleep 15
#     sudo systemctl enable webapp.service
#     sudo systemctl start webapp.service
#     sudo yum install polkit
#     sudo systemctl restart amazon-cloudwatch-agent.service
#     sleep 20
#     sudo systemctl restart webapp.service
#     sleep 15
#   EOF
#   tags = {
#     Name = "ec2-instance"
#   }
#   disable_api_termination = true
# }
