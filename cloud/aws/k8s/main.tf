terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "5.93.0"
      }
    }
  }
  
provider "aws" {
    region = var.region
}
  
variable "project_name" {}
variable "region" {}
variable "user" {}  

## Obter as AZ disponiveis
data "aws_availability_zones" "available" {}

## Obter a VPC Default 
data "aws_vpc" "default" {}

## Obter as Subnets Default
data "aws_subnets" "default" {}

data "aws_iam_user" "user" {
  user_name = var.user
}

resource "aws_iam_role" "cluster" {
  name = format("%s-eks-auto-cluster", var.project_name)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSComputePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSBlockStoragePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSLoadBalancingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSNetworkingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  role       = aws_iam_role.cluster.name
}


resource "aws_iam_role" "node" {
  name = format("%s-eks-auto-node", var.project_name)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodeMinimalPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryPullOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}


resource "aws_eks_access_entry" "user" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = data.aws_iam_user.user.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "user_AmazonEKSAdminPolicy" {
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = aws_eks_access_entry.user.principal_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "user_AmazonEKSClusterAdminPolicy" {
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_eks_access_entry.user.principal_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_cluster" "main" {
    name = format("%s-eks-cluster", var.project_name)
  
    access_config {
      authentication_mode = "API"
    }
  
    role_arn = aws_iam_role.cluster.arn
    version  = "1.31"
  
    bootstrap_self_managed_addons = false
  
    compute_config {
      enabled       = true
      node_pools    = ["general-purpose"]
      node_role_arn = aws_iam_role.node.arn
    }
  
    kubernetes_network_config {
      elastic_load_balancing {
        enabled = true
      }
    }
  
    storage_config {
      block_storage {
        enabled = true
      }
    }
  
    vpc_config {
      endpoint_private_access = true
      endpoint_public_access  = true
  
      subnet_ids = data.aws_subnets.default.ids
    }
  
    depends_on = [
      aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
      aws_iam_role_policy_attachment.cluster_AmazonEKSComputePolicy,
      aws_iam_role_policy_attachment.cluster_AmazonEKSBlockStoragePolicy,
      aws_iam_role_policy_attachment.cluster_AmazonEKSLoadBalancingPolicy,
      aws_iam_role_policy_attachment.cluster_AmazonEKSNetworkingPolicy,
    ]
}
  