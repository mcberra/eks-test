#!/bin/bash

#Upgrade AWS CLI
pip3 install --upgrade --user awscli
export PATH=$HOME/.local/bin:$PATH
echo 'export PATH=$HOME/.local/bin:$PATH' >> /home/ec2-user/.bash_profile

#Install istioctl
sudo curl -sL https://istio.io/downloadIstioctl | sh -
echo 'export PATH=$HOME/.istioctl/bin:$PATH' >> /home/ec2-user/.bash_profile
source /home/ec2-user/.bash_profile

# move files to repository
sudo mv /home/ec2-user/test.tfvars /home/ec2-user/eks-test/
sudo mv /home/ec2-user/backend_config.tfvars /home/ec2-user/eks-test/


