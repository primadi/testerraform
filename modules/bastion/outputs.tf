output "bastion_id" {
  value = aws_instance.bastion.id
}

output "public_ip" {
  value = aws_eip.bastion.public_ip
}

output "bastion_ip" {
  value = aws_instance.bastion.private_ip
}
