locals {
  user_data_vars = {
    endpoint_port = local.endpoint_no_port
    db_name       = aws_db_instance.rds.name
    db_username   = aws_db_instance.rds.username
    db_password   = aws_db_instance.rds.password
    bucket_name   = aws_s3_bucket.private_bucket.bucket
    region        = var.region
  }
}
resource "aws_launch_template" "asg_launch_template" {
  name          = "asg_launch_template"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = "ec2"
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  network_interfaces {
    associate_public_ip_address = "true"
    security_groups             = ["${aws_security_group.sg.id}"]
  }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_size           = 50
      volume_type           = "gp2"
      kms_key_id            = aws_kms_key.ebs.arn
    }
  }
  user_data = base64encode(templatefile("${path.module}/user_data.tpl",
    {
      DB_ENDPOINT = "${local.endpoint_no_port}"
      DB_NAME     = "${aws_db_instance.rds.name}"
      DB_USERNAME = "${aws_db_instance.rds.username}"
      DB_PASSWORD = "${aws_db_instance.rds.password}"
      BUCKET_NAME = "${aws_s3_bucket.private_bucket.bucket}"
      REGION      = "${var.region}"
    }
  ))
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "webapp_autoscaling_group" {
  name             = "webapp_autoscaling_group"
  default_cooldown = 60
  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = "$Latest"
  }
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  health_check_grace_period = 300
  vpc_zone_identifier       = aws_subnet.public.*.id
  target_group_arns         = ["${aws_lb_target_group.alb_group.arn}"]
  tag {
    key                 = "Name"
    value               = "WebAppASG"
    propagate_at_launch = true
  }
}

#This is scale up policy
resource "aws_autoscaling_policy" "scaleUpPolicy" {
  name                   = "WebServerScaleUpPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_autoscaling_group.name
  # policy_type            = "TargetTrackingScaling"
}

#This is scale down policy
resource "aws_autoscaling_policy" "scaleDownPolicy" {
  name                   = "WebServerScaleDownPolicy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_autoscaling_group.name
  # policy_type            = "TargetTrackingScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_name          = "CPUUtilization_Above_5%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_autoscaling_group.name
  }

  alarm_description = "Metric used to monitor cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scaleUpPolicy.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_name          = "CPUUtilization_Below_3%"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "3"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_autoscaling_group.name
  }

  alarm_description = "Metric used to monitor cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scaleDownPolicy.arn]
}
