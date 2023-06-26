#### AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}

#### AWS EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

#### AWS VPC
variable "vpc_name" {
  type    = string
  default = "vpc_wordpress"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets_wordpress_A" {
  type    = string
  default = "10.0.33.0/24"
}

variable "public_subnets_wordpress_B" {
  type    = string
  default = "10.0.35.0/24"
}

variable "private_subnets_wordpress_A" {
  type    = string
  default = "10.0.133.0/24"
}

variable "private_subnets_wordpress_B" {
  type    = string
  default = "10.0.135.0/24"
}

variable "database_subnets_wordpress_A" {
  type    = string
  default = "10.0.233.0/24"
}

variable "database_subnets_wordpress_B" {
  type    = string
  default = "10.0.235.0/24"
}



