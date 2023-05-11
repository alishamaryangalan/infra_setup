data "aws_route53_zone" "aws_zone" {
  name = var.aws_route53_zone_name
}

resource "aws_route53_record" "aws_record" {
  zone_id = data.aws_route53_zone.aws_zone.zone_id
  name    = var.aws_route53_record_name
  type    = "A"
  ttl     = "60"

  records = [
    aws_instance.ec2.public_ip,
  ]
}