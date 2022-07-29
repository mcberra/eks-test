#!/bin/bash

####################
###  VARIABLES   ###
####################

AK=$(aws ssm get-parameter --name "ak-eks-bastion" --with-decryption --region eu-west-1 | jq -r .Parameter.Value)
SK=$(aws ssm get-parameter --name "sk-eks-bastion" --with-decryption --region eu-west-1 | jq -r .Parameter.Value)
REGION=$(aws ssm get-parameter --name "default-region-eks-bastion" --region eu-west-1 | jq -r .Parameter.Value)

#Set environment variables for credentials

mkdir /home/ec2-user/.aws
touch /home/ec2-user/.aws/credentials
touch /home/ec2-user/.aws/config
echo [mcipriab] >> /home/ec2-user/.aws/credentials
echo "aws_access_key_id = $AK" >> /home/ec2-user/.aws/credentials
echo "aws_secret_access_key = $SK" >> /home/ec2-user/.aws/credentials
echo "[profile mcipriab]" >> /home/ec2-user/.aws/config
echo "region = $REGION" >> /home/ec2-user/.aws/config

#Update kubeconfig

aws eks update-kubeconfig --region $REGION --name macb-cluster --profile mcipriab

#Delete profile after 1 hour

sleep 3600 && rm -rf /home/ec2-user/.aws
