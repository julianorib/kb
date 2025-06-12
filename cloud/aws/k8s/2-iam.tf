## IAM Role para Cluster EKS
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
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}


# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSComputePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
#   role       = aws_iam_role.cluster.name
# }

# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSBlockStoragePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
#   role       = aws_iam_role.cluster.name
# }

# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSLoadBalancingPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
#   role       = aws_iam_role.cluster.name
# }

# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSNetworkingPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
#   role       = aws_iam_role.cluster.name
# }


## IAM Role para EKS Nodes
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

# resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodeMinimalPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
#   role       = aws_iam_role.node.name
# }

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryPullOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.node.name
}

# resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.node.name
# }

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}
