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
output "kms_key_id_output" {
  value = aws_kms_key.eks-bastion-key.key_id
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
output "macb-eks_platform_version" {
  value = aws_eks_cluster.macb-eks.platform_version
}

#Nodegroup outputs
output "aws_eks_node_group_version" {
  value = aws_eks_node_group.worker-node-group.version
}
output "aws_eks_node_group_id" {
  value = aws_eks_node_group.worker-node-group.id
}
output "aws_eks_node_group_node_role_arn" {
  value = aws_eks_node_group.worker-node-group.node_role_arn
}
output "aws_eks_node_group_capacity_type" {
  value = aws_eks_node_group.worker-node-group.capacity_type
}

