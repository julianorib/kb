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
    version  = var.k8s_version
  
    bootstrap_self_managed_addons = true
  
    compute_config {
      enabled       = false
      # node_pools    = ["general-purpose"]
      # node_role_arn = aws_iam_role.node.arn
    }
  
    kubernetes_network_config {
      elastic_load_balancing {
        enabled = false
      }
    }
  
    storage_config {
      block_storage {
        enabled = false
      }
    }
  
    vpc_config {
      endpoint_private_access = true
      endpoint_public_access  = false
  
      subnet_ids = [aws_subnet.private-1a.id,aws_subnet.private-1b.id]
    }
  
    depends_on = [
      aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
      aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController,
     #aws_iam_role_policy_attachment.cluster_AmazonEKSComputePolicy,
     #aws_iam_role_policy_attachment.cluster_AmazonEKSBlockStoragePolicy,
     #aws_iam_role_policy_attachment.cluster_AmazonEKSLoadBalancingPolicy,
     #aws_iam_role_policy_attachment.cluster_AmazonEKSNetworkingPolicy,
    ]
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = format("%s-eks-cluster-nodes", var.project_name)
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = [aws_subnet.private-[*].id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryPullOnly,
  ]
}