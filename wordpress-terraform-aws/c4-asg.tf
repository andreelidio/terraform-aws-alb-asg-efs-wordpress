#### Create EC2
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

data "aws_key_pair" "ranger-labs" {
  key_name = "ranger-labs"
}

resource "aws_launch_configuration" "wordpress_as_conf" {
  name_prefix     = "wordpress"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t2.2xlarge"
  key_name        = data.aws_key_pair.ranger-labs.key_name
  user_data       = file("${path.module}/wordpress.sh")
  security_groups = ["${aws_security_group.sg_wordpress.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

#### Create ASG
resource "aws_autoscaling_group" "wordpress" {
  name                 = "wordpress_asg"
  launch_configuration = aws_launch_configuration.wordpress_as_conf.name
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = ["${aws_subnet.public_subnets_wordpress_A.id} ", " ${aws_subnet.public_subnets_wordpress_B.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

#### Create ASGP
resource "aws_autoscaling_policy" "wordpress_autoscale" {
  name                   = "Wordpress-Autoscaling-Group-Policy"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress.name
}

#### Cloudwatch
resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization for Wordpress"
  alarm_actions       = [aws_autoscaling_policy.wordpress_autoscale.arn]
  alarm_name          = "wordpress"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "60"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress.name
  }
}