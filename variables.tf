
#eks-bastion variables
variable "ami_id" {
  type    = string
  default = "ami-0d71ea30463e0ff8d"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
variable "region" {
  type = string
}

#VPC module variables
variable "aws_region" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
