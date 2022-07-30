#!/bin/bash

#Upgrade AWS CLI
pip3 install --upgrade --user awscli
echo export PATH=$HOME/.local/bin:$PATH
source ~/.bash_profile

#Install istioctl
sudo curl -sL https://istio.io/downloadIstioctl | sh -
echo export PATH=$HOME/.istioctl/bin:$PATH

# move files to repository
mv /home/ec2-user/test.tfvars /home/ec2-user/eks-test/
mv /home/ec2-user/backend_config.tfvars /home/ec2-user/eks-test/
mv /home/ec2-user/.gitignore /home/ec2-user/eks-test/

