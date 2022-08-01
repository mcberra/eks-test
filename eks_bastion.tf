resource "aws_instance" "eks_bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.eks-public-subnet-id-1
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [module.vpc.eks-sg-id]
  iam_instance_profile        = aws_iam_instance_profile.eks-bastion-profile.name
  key_name                    = aws_key_pair.generated.key_name
  user_data                   = file("provisioner.tpl")

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

resource "aws_ssm_parameter" "ak-eks-bastion" {
  name        = "ak-eks-bastion"
  description = "Access key which the eks-bastion utilize to access the eks"
  type        = "SecureString"
  value       = var.access_key
}

resource "aws_ssm_parameter" "sk-eks-bastion" {
  name        = "sk-eks-bastion"
  description = "Secret key which the eks-bastion utilize to access the eks"
  type        = "SecureString"
  value       = var.secret_key
}

resource "aws_ssm_parameter" "default-region-eks-bastion" {
  name        = "default-region-eks-bastion"
  description = "Region in which the eks cluster is deployed"
  type        = "String"
  value       = var.region
}

resource "aws_iam_policy" "eks-bastion-policy" {
  name        = "eks-bastion-policy"
  path        = "/"
  description = "My eks-bastion-policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParameter*"
        ],
        "Resource" : [
          "arn:aws:ssm:eu-west-1:282611888029:parameter/${aws_ssm_parameter.ak-eks-bastion.name}",
          "arn:aws:ssm:eu-west-1:282611888029:parameter/${aws_ssm_parameter.sk-eks-bastion.name}",
          "arn:aws:ssm:eu-west-1:282611888029:parameter/${aws_ssm_parameter.default-region-eks-bastion.name}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt"
        ],
        "Resource" : "arn:aws:kms:eu-west-1:282611888029:key/${aws_kms_key.eks-bastion-key.key_id}"
      }
    ]
  })

  depends_on = [
    aws_kms_key.eks-bastion-key
  ]
}

resource "aws_iam_role" "eks-bastion-role" {
  name = "eks-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-bastion-role-policy_attachment" {
  role       = aws_iam_role.eks-bastion-role.name
  policy_arn = aws_iam_policy.eks-bastion-policy.arn
}

resource "aws_iam_instance_profile" "eks-bastion-profile" {
  name = "eks-bastion-profile"
  role = aws_iam_role.eks-bastion-role.name
}

resource "aws_kms_key" "eks-bastion-key" {
  description = "Key used to encrypt and decrypt ssm parameters"
  policy      = <<EOT
{
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::282611888029:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::282611888029:user/mcipriab"
            },
            "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::282611888029:user/mcipriab"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::282611888029:user/mcipriab"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
EOT
}

