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



