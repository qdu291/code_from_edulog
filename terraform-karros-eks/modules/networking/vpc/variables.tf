variable "azs" {
  type = list(string)
}

variable "vpc_name" {
  type        = string
  description = "Name of VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR range"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = " VPC Private Subnet CIDR range"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = " VPC Public Subnet CIDR range"
}

variable "private_subnet_tags" {
  type = map(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}