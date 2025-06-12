## Obter usuário que terá acesso ao Cluster
data "aws_iam_user" "user" {
  user_name = var.user
}

## Politicas de Acesso 
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

## Security Group para acesso a API
resource "aws_security_group" "eks_cluster_api" {
  name   = format("%s-sg-eks-cluster-api", var.project_name)
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  tags = merge({ Name = format("%s-sg-eks-cluster-api", var.project_name) }, local.common_tags)
}

## Security Group para EKS Cluster
resource "aws_security_group" "eks" {
  name   = format("%s-sg-eks", var.project_name)
  vpc_id = aws_vpc.vpc.id
  egress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = format("%s-sg-eks", var.project_name) }, local.common_tags)
}

## Regra ingress para Security Group
resource "aws_security_group_rule" "eks_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = aws_security_group.eks.id
}

## Cluster EKS
resource "aws_eks_cluster" "main" {
  name = format("%s-eks-cluster", var.project_name)
  access_config {
    authentication_mode = "API"
  }
  role_arn = aws_iam_role.cluster.arn
  version  = var.k8s_version
  bootstrap_self_managed_addons = true

  compute_config {
    enabled = false
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
    endpoint_public_access  = var.eks_public_access
    subnet_ids = [aws_subnet.private-1a.id, aws_subnet.private-1b.id, aws_subnet.private-1c.id]
    security_group_ids = [aws_security_group.eks.id, aws_security_group.eks_cluster_api.id]
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController,
    #aws_iam_role_policy_attachment.cluster_AmazonEKSComputePolicy,
    #aws_iam_role_policy_attachment.cluster_AmazonEKSBlockStoragePolicy,
    #aws_iam_role_policy_attachment.cluster_AmazonEKSLoadBalancingPolicy,
    #aws_iam_role_policy_attachment.cluster_AmazonEKSNetworkingPolicy,
  ]
  tags = merge({ Name = format("%s-eks-cluster", var.project_name) }, local.common_tags)
}

## EKS Node Group On_Demand
resource "aws_eks_node_group" "on_demand" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = format("%s-eks-cluster-nodes-on-demand", var.project_name)
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = [aws_subnet.private-1a.id, aws_subnet.private-1b.id, aws_subnet.private-1c.id]
  capacity_type   = "ON_DEMAND"
  instance_types  = var.eks_instance_types

  scaling_config {
    desired_size = var.eks_ondemand_desired
    max_size     = var.eks_ondemand_max
    min_size     = var.eks_ondemand_min
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryPullOnly,
  ]

  tags = merge({ Name = format("%s-eks-cluster-nodes-on-demand", var.project_name) }, local.common_tags)
}

## EKS Node Group Spot
resource "aws_eks_node_group" "spot" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = format("%s-eks-cluster-nodes-spot", var.project_name)
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = [aws_subnet.private-1a.id, aws_subnet.private-1b.id, aws_subnet.private-1c.id]
  capacity_type   = "SPOT"
  instance_types = var.eks_instance_types

  scaling_config {
    desired_size = var.eks_spot_desired
    max_size     = var.eks_spot_max
    min_size     = var.eks_spot_min
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryPullOnly,
  ]
  tags = merge({ Name = format("%s-eks-cluster-nodes-spot", var.project_name) }, local.common_tags)
}

## EKS Output
output "EKS_endpoint" {
  value = aws_eks_cluster.main.endpoint
}
output "EKS_kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}