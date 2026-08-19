# ============================================================
# EXISTING DEFAULT VPC
# ============================================================

data "aws_vpc" "default" {  
  default = true  
}


# ============================================================
# DEFAULT VPC SUBNETS
# ============================================================

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


# ============================================================
# DEFAULT VPC MAIN ROUTE TABLE
# ============================================================

data "aws_route_table" "default_main" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}







