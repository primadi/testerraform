output "ec2_id" {
  value = aws_instance.ec2.id
}

output "public_ip" {
  value = var.public_ip_name == "" ? aws_eip.ec2[0].public_ip : aws_eip_association.ec2[0].public_ip
}

output "security_group_id" {
  value = aws_security_group.ec2.id
}
