variable "aws_region" {
type = string
}
variable "vpc_name" {
  type    = string
}
variable "vpc_cidr" {
  type    = string
}
variable "private_subnets" {
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
  }
}
variable "public_subnets" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
  }
}

variable "public_subnet_1" {
  type    = string
}
variable "public_subnet_2" {
  type    = string
}
variable "private_subnet_1" {
  type    = string
}
variable "private_subnet_2" {
  type    = string
}
variable "sg_id" {
  type    = string
}