#### Create a new load balancer
resource "aws_lb" "wordpress" {
  name               = "wordpress"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = ["${aws_security_group.sg_alb.id}"]
  subnets = [
    aws_subnet.public_subnets_wordpress_A.id,
    aws_subnet.public_subnets_wordpress_B.id
  ]

  enable_deletion_protection = false

  tags = {
    Environment = "prod"
  }
}

#### Create a new Listener
resource "aws_lb_listener" "wordpress_lb_listene" {
  load_balancer_arn = aws_lb.wordpress.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_alb_target_group.arn

  }
}

#### Create a new Target_group
resource "aws_lb_target_group" "wordpress_alb_target_group" {
  name        = "wordpressalb"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc_wordpress.id
  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
  }
  tags = {
    Environment = "prod"
  }
}


