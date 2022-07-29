
variable "ami_id" {
  type    = string
  default = "ami-0d71ea30463e0ff8d"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

#eks-bastion credentials
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
variable "region" {
  type = string
}