#!/bin/bash

#Upgrade AWS CLI
pip3 install --upgrade --user awscli
export PATH=$HOME/.local/bin:$PATH
echo 'export PATH=$HOME/.local/bin:$PATH' >> /home/ec2-user/.bash_profile

#Install istioctl
sudo curl -sL https://istio.io/downloadIstioctl | sh -
echo 'export PATH=$HOME/.istioctl/bin:$PATH' >> /home/ec2-user/.bash_profile


