#!/bin/bash

#Upgrade AWS CLI
pip3 install --upgrade --user awscli
export PATH=$HOME/.local/bin:$PATH
source ~/.bash_profile

#Install istioctl
sudo curl -sL https://istio.io/downloadIstioctl | sh -
export PATH=$HOME/.istioctl/bin:$PATH

# move files to repository
sudo mv /home/ec2-user/test.tfvars /home/ec2-user/eks-test/
sudo mv /home/ec2-user/backend_config.tfvars /home/ec2-user/eks-test/


