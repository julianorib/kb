terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_iam_role" "test_role" {
  name = "test_role"
  assume_role_policy = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}    
    )
}
## Associa a uma Função, Politicas Existentes:

resource "aws_iam_role_policy_attachment" "policy_1" {
  role       = aws_iam_role.test_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
resource "aws_iam_role_policy_attachment" "policy_2" {
  role       = aws_iam_role.test_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}


## Cria e Associa a uma Função, uma Politica Inline Especifica:

resource "aws_iam_role_policy" "policy" {
  name = "Policy"
  role = aws_iam_role.test_role.id
 policy = jsonencode({
        "Version" : "2012-10-17",
      "Statement" : [
        {
          "Resource" : "*",
          "Effect" : "Allow",
          "Action" : [
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:Describe",
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
            "elasticloadbalancing:RegisterTargets",
            "ec2:Describe",
            "ec2:AuthorizedSecurityGroupIngress"
          ]
        }
      ]
 }) 
}