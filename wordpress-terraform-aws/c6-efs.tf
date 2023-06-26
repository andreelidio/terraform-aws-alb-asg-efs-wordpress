#### Create a new load balancer
resource "aws_efs_file_system" "workpress_efs" {
  creation_token   = "workpress-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "Workpress-MyEFS"

  }
}
resource "aws_efs_mount_target" "efs-wordpress-A" {
  file_system_id  = aws_efs_file_system.workpress_efs.id
  subnet_id       = aws_subnet.public_subnets_wordpress_A.id
  security_groups = ["${aws_security_group.sg_efs.id}"]
}

resource "aws_efs_mount_target" "efs-wordpress-B" {
  file_system_id  = aws_efs_file_system.workpress_efs.id
  subnet_id       = aws_subnet.private_subnets_wordpress_A.id
  security_groups = ["${aws_security_group.sg_efs.id}"]
}