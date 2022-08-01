resource "aws_instance" "eks_bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.eks-public-subnet-id-1
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [module.vpc.eks-sg-id]
  #iam_instance_profile        = aws_iam_instance_profile.eks-bastion-profile.name
  key_name  = aws_key_pair.generated.key_name
  user_data = file("./scripts/userdata.sh")

  tags = {
    "Name" = "eks_bastion"
  }

  provisioner "file" {
    source      = "test.tfvars"
    destination = "/home/ec2-user/test.tfvars"

    connection {
      user        = "ec2-user"
      private_key = tls_private_key.generated.private_key_pem
      host        = self.public_ip
    }
  }
  provisioner "file" {
    source      = "backend_config.tfvars"
    destination = "/home/ec2-user/backend_config.tfvars"

    connection {
      user        = "ec2-user"
      private_key = tls_private_key.generated.private_key_pem
      host        = self.public_ip
    }
  }
}
resource "tls_private_key" "generated" {
  algorithm = "RSA"
}
resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "eks-bastion.pem"
}
resource "aws_key_pair" "generated" {
  key_name   = "eks-bastion"
  public_key = tls_private_key.generated.public_key_openssh
  lifecycle {
    ignore_changes = [key_name]
  }
}
