#### Create SG - ELB
resource "aws_security_group" "sg_alb" {
  name        = "sg_elb"
  description = "sg_elb"
  vpc_id      = aws_vpc.vpc_wordpress.id

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Access Pert"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_alb"
  }
}

#### Create SG - Wordpress
resource "aws_security_group" "sg_wordpress" {
  name        = "sg_wordpress"
  description = "sg_wordpress"
  vpc_id      = aws_vpc.vpc_wordpress.id

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Access Pert"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_wordpress"
  }
}

#### Create SG - Mysql
resource "aws_security_group" "sg_mysql" {
  name        = "sg_mysql"
  description = "sg_mysql"
  vpc_id      = aws_vpc.vpc_wordpress.id

  ingress {
    description = "Allow Port 3306"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Access Pert"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_mysql"
  }
}

#### Create SG - EFS
resource "aws_security_group" "sg_efs" {
  name        = "sg_efs"
  description = "sg_efs"
  vpc_id      = aws_vpc.vpc_wordpress.id

  ingress {
    description = "Allow efs"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "sg_efs"
  }
}
