# ============================================================
# VPC
# ============================================================

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.vpc_tags,
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}"
    }
  )
}


# ============================================================
# Internet Gateway
# ============================================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.igw_tags,
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-igw"
    }
  )
}


# ============================================================
# Public Subnets
# ============================================================

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.public_subnet_tags,
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-public-${var.az_names[count.index]}"
    }
  )
}


# ============================================================
# Private Subnets
# ============================================================

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.az_names[count.index]

  tags = merge(
    var.private_subnet_tags,
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-private-${var.az_names[count.index]}"
    }
  )
}


# ============================================================
# Database Subnets
# ============================================================

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidrs[count.index]
  availability_zone = var.az_names[count.index]

  tags = merge(
    var.database_subnet_tags,
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-database-${var.az_names[count.index]}"
    }
  )
}


# ============================================================
# Elastic IP for NAT Gateway
# ============================================================

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    var.eip_tags,
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-nat-eip"
    }
  )
}


# ============================================================
# NAT Gateway
# ============================================================

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.nat_gateway_tags,
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-nat"
    }
  )

  depends_on = [
    aws_internet_gateway.main
  ]
}


# ============================================================
# Public Route Table
# ============================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.public_route_table_tags,
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-public"
    }
  )
}


# ============================================================
# Private Route Table
# ============================================================

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.private_route_table_tags,
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-private"
    }
  )
}


# ============================================================
# Database Route Table
# ============================================================

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.database_route_table_tags,
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-database"
    }
  )
}


# ============================================================
# Public Route -> Internet Gateway
# ============================================================

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}


# ============================================================
# Private Route -> NAT Gateway
# ============================================================

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}


# ============================================================
# Database Route -> NAT Gateway
# ============================================================

resource "aws_route" "database_nat" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}


# ============================================================
# Public Route Table Association
# ============================================================

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


# ============================================================
# Private Route Table Association
# ============================================================

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


# ============================================================
# Database Route Table Association
# ============================================================

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

