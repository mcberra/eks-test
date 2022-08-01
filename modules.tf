module "vpc" {
  source           = "./modules/vpc_project"
  public_subnet_1  = module.vpc.eks-public-subnet-id-1
  public_subnet_2  = module.vpc.eks-public-subnet-id-2
  private_subnet_1 = module.vpc.eks-private-subnet-id-1
  private_subnet_2 = module.vpc.eks-private-subnet-id-2
  sg_id            = module.vpc.eks-sg-id
  aws_region       = var.aws_region
  vpc_name         = var.vpc_name
  vpc_cidr         = var.vpc_cidr
}