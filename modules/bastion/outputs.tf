output "bastion_id" {
  value = aws_instance.bastion.id
}

output "public_ip" {
  value = var.public_ip == "" ? aws_eip.bastion[0].public_ip : aws_eip_association.bastion[0].public_ip
}

output "bastion_ip" {
  value = aws_instance.bastion.private_ip
}
