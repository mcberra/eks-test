#!/bin/bash
sudo yum update -y

#Install kubectl
sudo curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
sudo echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

#Install jq
sudo yum install epel-release -y
sudo yum update -y
sudo yum install jq -y

#Install Git
sudo yum install git -y

#Install terraform
sudo yum update -y 
sudo yum install -y wget unzip
sudo wget https://releases.hashicorp.com/terraform/1.2.6/terraform_1.2.6_linux_amd64.zip
sudo unzip ./terraform_1.2.6_linux_amd64.zip -d /usr/local/bin

#Install helm
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh

#Set commands to install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

#Set profile aliases/variables
echo 'alias k=kubectl' >> /home/ec2-user/.bashrc
echo 'do="--dry-run=client -oyaml"' >> /home/ec2-user/.bashrc
echo 'now="--grace-period 0 --force"' >> /home/ec2-user/.bashrc
echo 'export AWS_ACCESS_KEY_ID=' >> /home/ec2-user/.bashrc
echo 'export AWS_SECRET_ACCESS_KEY=' >> /home/ec2-user/.bashrc
echo 'export AWS_DEFAULT_REGION=' >> /home/ec2-user/.bashrc
echo k8='"aws eks update-kubeconfig --region $AWS_DEFAULT_REGION --name "' >> /home/ec2-user/.bashrc

#terraform shortcuts
echo init='"terraform init -var-file=test.tfvars -backend-config=backend_config.tfvars"' >> /home/ec2-user/.bashrc
echo plan='"terraform plan -var-file=test.tfvars"' >> /home/ec2-user/.bashrc
echo apply='"terraform apply -var-file=test.tfvars -auto-approve"' >> /home/ec2-user/.bashrc

#Clone repository
git clone https://github.com/mcberra/eks-test.git /home/ec2-user/eks-test
sudo chown -R ec2-user: /home/ec2-user/eks-test
