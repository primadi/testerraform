output "nat_routetable_id" {
  value = length(aws_route_table.nat_i) > 0 ? aws_route_table.nat_i[0].id : ""
}

output "nat_instance_securitygroup_id" {
  value = length(aws_security_group.nat_i) > 0 ? aws_security_group.nat_i[0].id : ""
}

output "public_ip" {
  value = length(aws_eip.nat_i) > 0 ? aws_eip.nat_i[0].public_ip : ""
}
