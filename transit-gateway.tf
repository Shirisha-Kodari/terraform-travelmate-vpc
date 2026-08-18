


# ============================================================
# TRANSIT GATEWAY
# ============================================================

resource "aws_ec2_transit_gateway" "main" {
  count = var.is_transit_gateway_required ? 1 : 0

  description = "${var.project}-${var.environment}-tgw"

  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = merge(
    var.transit_gateway_tags,
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-tgw"
    }
  )
}


# ============================================================
# MAIN VPC -> TRANSIT GATEWAY
# ============================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  count = var.is_transit_gateway_required ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.main[0].id

  vpc_id = aws_vpc.main.id

  subnet_ids = aws_subnet.private[*].id

  dns_support = "enable"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-tgw-attachment"
    }
  )
}


# ============================================================
# DEFAULT VPC -> TRANSIT GATEWAY
# ============================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "default" {
  count = var.is_transit_gateway_required ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.main[0].id

  vpc_id = data.aws_vpc.default.id

  subnet_ids = data.aws_subnets.default.ids

  dns_support = "enable"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-default-tgw-attachment"
    }
  )
}


# ============================================================
# PRIVATE ROUTE -> DEFAULT VPC THROUGH TGW
# ============================================================

resource "aws_route" "private_tgw" {
  count = var.is_transit_gateway_required ? 1 : 0

  route_table_id = aws_route_table.private.id

  destination_cidr_block = data.aws_vpc.default.cidr_block

  transit_gateway_id = aws_ec2_transit_gateway.main[0].id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.main,
    aws_ec2_transit_gateway_vpc_attachment.default
  ]
}


# ============================================================
# DATABASE ROUTE -> DEFAULT VPC THROUGH TGW
# ============================================================

resource "aws_route" "database_tgw" {
  count = var.is_transit_gateway_required ? 1 : 0

  route_table_id = aws_route_table.database.id

  destination_cidr_block = data.aws_vpc.default.cidr_block

  transit_gateway_id = aws_ec2_transit_gateway.main[0].id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.main,
    aws_ec2_transit_gateway_vpc_attachment.default
  ]
}


# ============================================================
# DEFAULT VPC -> MAIN VPC THROUGH TGW
# ============================================================

resource "aws_route" "default_tgw" {
  count = var.is_transit_gateway_required ? 1 : 0

  route_table_id = data.aws_route_table.default_main.id

  destination_cidr_block = aws_vpc.main.cidr_block

  transit_gateway_id = aws_ec2_transit_gateway.main[0].id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.main,
    aws_ec2_transit_gateway_vpc_attachment.default
  ]
}