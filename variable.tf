variable "region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  type    = string
  default = "dev"
}

variable "public_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.region]
  }
}
variable "my_ip" {
  type    = string
  default = "71.192.113.253"
}

variable "webapp_port" {
  type    = number
  default = 3030
}

variable "ami_id" {
  type    = string
  default = "ami-0e42e6e7b4f8c0f00"
}

variable "aws_access_key" {
  type    = string
  default = ""
}
variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "aws_s3_bucket_name" {
  type    = string
  default = "s3-bucket"
}

variable "db_username" {
  type    = string
  default = "csye6225"
}

variable "db_password" {
  type    = string
  default = "justgowithit"
}
variable "rds_identifier" {
  type    = string
  default = "csye6225"
}

variable "rds_db_name" {
  type    = string
  default = "webapprds"
}