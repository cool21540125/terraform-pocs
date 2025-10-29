# ====================================== EKS cluster role ======================================
resource "aws_iam_role" "eks_cluster_role" {
  name = "EKS_NonAutoModeClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}


# ====================================== EKS cluster ======================================
resource "aws_eks_cluster" "eks_devops" {
  name     = "devops"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.34"

  enabled_cluster_log_types = []
  # enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  access_config {
    bootstrap_cluster_creator_admin_permissions = false
    authentication_mode                         = "API"
  }

  vpc_config {
    subnet_ids = [
      aws_subnet.public_us_west_2a.id,
      aws_subnet.public_us_west_2b.id,
      aws_subnet.public_us_west_2c.id,
      aws_subnet.public_us_west_2d.id,
      aws_subnet.private_us_west_2a.id,
      aws_subnet.private_us_west_2b.id,
      aws_subnet.private_us_west_2c.id,
      aws_subnet.private_us_west_2d.id
    ]
  }

  upgrade_policy {
    support_type = "STANDARD"
  }

  bootstrap_self_managed_addons = true

  depends_on          = [aws_iam_role_policy_attachment.eks_cluster_policy]
  deletion_protection = false
}


# ====================================== EKS addons ======================================
resource "aws_eks_addon" "eks_addons_coredns" {
  cluster_name  = aws_eks_cluster.eks_devops.name
  addon_name    = "coredns"
  addon_version = "v1.12.4-eksbuild.1"
}
resource "aws_eks_addon" "eks_addons_kube_proxy" {
  cluster_name  = aws_eks_cluster.eks_devops.name
  addon_name    = "kube-proxy"
  addon_version = "v1.34.0-eksbuild.4"
}
# resource "aws_eks_addon" "eks_addons_node_monitoring_agent" {
#   cluster_name  = aws_eks_cluster.eks_devops.name
#   addon_name    = "node-monitoring-agent"
#   addon_version = "v1.4.1-eksbuild.1"
# }
resource "aws_eks_addon" "eks_addons_vpc_cni" {
  cluster_name  = aws_eks_cluster.eks_devops.name
  addon_name    = "vpc-cni"
  addon_version = "v1.20.4-eksbuild.1"
}
resource "aws_eks_addon" "eks_addons_csi_driver" {
  cluster_name  = aws_eks_cluster.eks_devops.name
  addon_name    = "aws-efs-csi-driver"
  addon_version = "v2.1.13-eksbuild.1"
}
resource "aws_eks_addon" "eks_addons_pod_identity_agent" {
  cluster_name  = aws_eks_cluster.eks_devops.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.9-eksbuild.3"
}
resource "aws_eks_addon" "eks_addons_metrics_server" {
  cluster_name  = aws_eks_cluster.eks_devops.name
  addon_name    = "metrics-server"
  addon_version = "v0.8.0-eksbuild.2"
}
