output "nat_routetable_id" {
  value = length(aws_route_table.nat_gw) > 0 ? aws_route_table.nat_gw[0].id : ""
}
