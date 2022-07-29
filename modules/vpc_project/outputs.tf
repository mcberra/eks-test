#VPC outputs
output "eks-vpc-id" {
  value = aws_vpc.vpc.id
}
output "eks-vpc-cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

#Public subnets outputs
output "eks-public-subnet-id-1" {
  value = values(aws_subnet.public_subnets)[0].id
}
output "eks-public-subnet-id-2" {
  value = values(aws_subnet.public_subnets)[1].id
}
output "eks-public-subnet-cidr_block" {
  value = [
    for cidr in aws_subnet.public_subnets : cidr.cidr_block
  ]
}

#Private subnets outputs
output "eks-private-subnet-id-1" {
  value = values(aws_subnet.private_subnets)[0].id
}
output "eks-private-subnet-id-2" {
  value = values(aws_subnet.private_subnets)[1].id
}
output "eks-private-subnet-cidr_block" {
  value = [
    for cidr in aws_subnet.private_subnets : cidr.cidr_block
  ]
}

#Internet Gateway outputs
output "eks-igw-id" {
  value = aws_internet_gateway.internet_gateway.id
}

#EIP for NAT Gateway outputs
output "eks-eip-id" {
  value = aws_eip.nat_gateway_eip.id
}
output "eks-eip-public-ip" {
  value = aws_eip.nat_gateway_eip.public_ip
}

#NAT Gateway outputs
output "eks-ngw" {
  value = aws_nat_gateway.nat_gateway.id
}

#Security Group outputs
output "eks-sg-id" {
  value = aws_security_group.security_group_macb_ssh.id
}

