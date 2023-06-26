
#### Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

#### Define the VPC
resource "aws_vpc" "vpc_wordpress" {
  cidr_block = var.vpc_cidr

  tags = {
    name                 = var.vpc_name
    enable_dns_support   = true
    enable_dns_hostnames = true
  }
}

#### Deploy the public subnets
resource "aws_subnet" "public_subnets_wordpress_A" {
  vpc_id                  = aws_vpc.vpc_wordpress.id
  cidr_block              = var.public_subnets_wordpress_A
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnets_wordpress_A"

  }
}

resource "aws_subnet" "public_subnets_wordpress_B" {
  vpc_id                  = aws_vpc.vpc_wordpress.id
  cidr_block              = var.public_subnets_wordpress_B
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnets_wordpress_B"

  }
}

#### Deploy the private subnets
resource "aws_subnet" "private_subnets_wordpress_A" {
  vpc_id                  = aws_vpc.vpc_wordpress.id
  cidr_block              = var.private_subnets_wordpress_A
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "private_subnets_wordpress_A"

  }
}

resource "aws_subnet" "private_subnets_wordpress_B" {
  vpc_id                  = aws_vpc.vpc_wordpress.id
  cidr_block              = var.private_subnets_wordpress_B
  availability_zone       = "us-east-1d"
  map_public_ip_on_launch = true

  tags = {
    Name = "private_subnets_wordpress_B"

  }
}

#### Deploy the DB
resource "aws_subnet" "database_subnets_A" {
  vpc_id                  = aws_vpc.vpc_wordpress.id
  cidr_block              = var.database_subnets_wordpress_A
  availability_zone       = "us-east-1e"
  map_public_ip_on_launch = true

  tags = {
    Name = "database_subnets_wordpress_A"

  }
}

resource "aws_subnet" "database_subnets_B" {
  vpc_id                  = aws_vpc.vpc_wordpress.id
  cidr_block              = var.database_subnets_wordpress_B
  availability_zone       = "us-east-1f"
  map_public_ip_on_launch = true

  tags = {
    Name = "database_subnets_wordpress_B"

  }
}

resource "aws_db_subnet_group" "aws_db_subnet_group_for_database" {
  name       = "subnet_database"
  subnet_ids = [aws_subnet.database_subnets_A.id, aws_subnet.database_subnets_B.id]

  tags = {
    Name = "DB subnet group"
  }
}

#### Create route tables for public and private subnets
resource "aws_route_table" "public_route_table_wordpress" {
  vpc_id = aws_vpc.vpc_wordpress.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_wordpress.id
  }

  tags = {
    Name      = "public_rtb_wordpress"
    Terraform = "true"
  }
}

resource "aws_route_table" "private_route_table_wordpress" {
  vpc_id = aws_vpc.vpc_wordpress.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_wordpress.id
  }

  tags = {
    Name      = "private_rtb_wordpress"
    Terraform = "true"
  }
}

#### Create route table associations
resource "aws_route_table_association" "public_wordpress" {
  route_table_id = aws_route_table.public_route_table_wordpress.id
  subnet_id      = aws_subnet.public_subnets_wordpress_A.id
}

resource "aws_route_table_association" "private_wordpress" {
  route_table_id = aws_route_table.private_route_table_wordpress.id
  subnet_id      = aws_subnet.private_subnets_wordpress_A.id
}

#### Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway_wordpress" {
  vpc_id = aws_vpc.vpc_wordpress.id

  tags = {
    Name = "igw_wordpress"
  }
}