output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  description = "Database subnet IDs"
  value       = aws_subnet.database[*].id
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = aws_route_table.private.id
}

output "database_route_table_id" {
  description = "Database route table ID"
  value       = aws_route_table.database.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.main.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}


# ============================================================
# TRANSIT GATEWAY OUTPUT
# ============================================================

output "transit_gateway_id" {
  description = "Transit Gateway ID"

  value = var.is_transit_gateway_required ? aws_ec2_transit_gateway.main[0].id : null
}

output "transit_gateway_main_attachment_id" {
  description = "Main VPC Transit Gateway attachment ID"

  value = var.is_transit_gateway_required ? aws_ec2_transit_gateway_vpc_attachment.main[0].id : null
}

output "transit_gateway_default_attachment_id" {
  description = "Default VPC Transit Gateway attachment ID"

  value = var.is_transit_gateway_required ? aws_ec2_transit_gateway_vpc_attachment.default[0].id : null
}