variable "project" {
  type = string
}
 
variable "environment" {     
  type = string   
}

variable "cidr_block" {
  type = string
}

variable "az_names" {
  type = list(string)
}


# ============================================================
# Subnet CIDRs
# ============================================================

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "database_subnet_cidrs" {
  type = list(string)
}


# ============================================================
# Common Tags
# ============================================================

variable "common_tags" {
  type    = map(string)
  default = {}
}


# ============================================================
# Resource Tags
# ============================================================

variable "vpc_tags" {
  type    = map(string)
  default = {}
}

variable "igw_tags" {
  type    = map(string)
  default = {}
}

variable "public_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "private_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "database_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "eip_tags" {
  type    = map(string)
  default = {}
}

variable "nat_gateway_tags" {
  type    = map(string)
  default = {}
}

variable "public_route_table_tags" {
  type    = map(string)
  default = {}
}

variable "private_route_table_tags" {
  type    = map(string)
  default = {}
}

variable "database_route_table_tags" {
  type    = map(string)
  default = {}
}

variable "is_transit_gateway_required" {
  type    = bool
  default = false
}

variable "transit_gateway_tags" {
  type    = map(string)
  default = {}
}
