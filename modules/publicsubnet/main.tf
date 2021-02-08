resource "aws_subnet" "publicsubnet" {
  vpc_id                  = var.vpc_id
  availability_zone       = var.availability_zone
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "publicsubnet" {
  vpc_id = var.vpc_id
  route = [{
    cidr_block                = "0.0.0.0/0"
    gateway_id                = var.igw_id
    egress_only_gateway_id    = ""
    ipv6_cidr_block           = ""
    local_gateway_id          = ""
    instance_id               = ""
    nat_gateway_id            = ""
    network_interface_id      = ""
    transit_gateway_id        = ""
    vpc_endpoint_id           = ""
    vpc_peering_connection_id = ""
  }]
  tags = {
    Name = var.name
  }
}

resource "aws_route_table_association" "publicsubnet" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.publicsubnet.id
}
