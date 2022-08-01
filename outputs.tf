#EC2 instance outputs
output "ec2-id" {
  value = aws_instance.eks_bastion.id
}
output "ec2-public_ip" {
  value = aws_instance.eks_bastion.public_ip
}
output "ec2-private_ip" {
  value = aws_instance.eks_bastion.private_ip
}


#EKS outputs
output "macb-eks_version" {
  value = aws_eks_cluster.macb-eks.version
}
output "macb-eks_endpoint" {
  value = aws_eks_cluster.macb-eks.endpoint
}
output "macb-eks_role_arn" {
  value = aws_eks_cluster.macb-eks.role_arn
}
output "macb-eks_id" {
  value = aws_eks_cluster.macb-eks.id
}

#Nodegroup outputs
output "aws_eks_node_group_version" {
  value = aws_eks_node_group.worker-node-group.version
}
output "aws_eks_node_group_node_role_arn" {
  value = aws_eks_node_group.worker-node-group.node_role_arn
}

#VPC module
output "vpc_cidr" {
  value = var.vpc_cidr
}
output "vpc_id" {
  value = module.vpc.eks-vpc-id
}
