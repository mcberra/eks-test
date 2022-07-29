
data "aws_eks_cluster" "macb-eks" {
  name = "macb-eks"

  depends_on = [
    aws_eks_cluster.macb-eks
  ]
}
data "aws_eks_cluster_auth" "macb-eks" {
  name = "macb-eks"

  depends_on = [
    aws_eks_cluster.macb-eks
  ]
}

#Create cluster role
resource "aws_iam_role" "macb-eks-iam-role" {
  name               = "macb-eks-iam-role"
  path               = "/"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF
}

#Attach a policy to the cluster role
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.macb-eks-iam-role.name
}

#Attach a policy to the cluster role
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.macb-eks-iam-role.name
}

#Create eks cluster
resource "aws_eks_cluster" "macb-eks" {
  name     = "macb-eks"
  role_arn = aws_iam_role.macb-eks-iam-role.arn

  vpc_config {
    subnet_ids = [
      module.vpc.eks-public-subnet-id-1,
      module.vpc.eks-public-subnet-id-2,
      module.vpc.eks-private-subnet-id-1,
      module.vpc.eks-private-subnet-id-2
    ]
  }

  depends_on = [
    aws_iam_role.macb-eks-iam-role
  ]
}

resource "aws_iam_role" "workernodes" {
  name = "macb-eks-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workernodes.name
}

resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role       = aws_iam_role.workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workernodes.name
}

resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.macb-eks.name
  node_group_name = "macb-workernodes"
  node_role_arn   = aws_iam_role.workernodes.arn
  subnet_ids      = [module.vpc.eks-private-subnet-id-1, module.vpc.eks-private-subnet-id-2]
  instance_types  = ["t3.xlarge"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
    #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}


