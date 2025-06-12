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


resource "aws_security_group" "teste2" {
  name   = format("%s-sg-test", var.project_name)
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "test"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  tags = merge({ Name = format("%s-sg-test", var.project_name) }, local.common_tags)
}


resource "aws_security_group" "teste" {
  name   = format("%s-sg", var.project_name)
  vpc_id = aws_vpc.vpc.id

  egress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = format("%s-sg", var.project_name) }, local.common_tags)
}

resource "aws_security_group_rule" "example" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.teste.id
  source_security_group_id = aws_security_group.teste.id
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
    endpoint_public_access  = false

    subnet_ids = [aws_subnet.private-1a.id, aws_subnet.private-1b.id]

    security_group_ids = [aws_security_group.teste.id, aws_security_group.teste2.id]
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

resource "aws_eks_node_group" "on_demand" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = format("%s-eks-cluster-nodes-on-demand", var.project_name)
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = [aws_subnet.private-1a.id, aws_subnet.private-1b.id, aws_subnet.private-1c.id]
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t3.micro"]

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

  tags = merge({ Name = format("%s-eks-cluster-nodes-on-demand", var.project_name) }, local.common_tags)
}

resource "aws_eks_node_group" "spot" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = format("%s-eks-cluster-nodes-spot", var.project_name)
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = [aws_subnet.private-1a.id, aws_subnet.private-1b.id, aws_subnet.private-1c.id]
  capacity_type   = "SPOT"

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

  tags = merge({ Name = format("%s-eks-cluster-nodes-spot", var.project_name) }, local.common_tags)
}