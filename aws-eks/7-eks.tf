# ------------------ EKS cluster role ------------------
resource "aws_iam_role" "eks-cluster-role" {
  name        = "EKS-NonAutoMode-ClusterRole"
  description = "Allows the cluster Kubernetes control plane to manage AWS resources on your behalf."

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

# ------------------ EKS addons ------------------
variable "addons" {
  type = list(object({
    name = string
  }))
}
resource "aws_eks_addon" "eks_addons" {
  for_each     = { for addon in var.addons : addon.name => addon }
  cluster_name = aws_eks_cluster.eks_devops.name
  addon_name   = each.value.name
}


# ------------------ EKS cluster ------------------
resource "aws_eks_cluster" "eks_devops" {
  name     = "devops"
  role_arn = aws_iam_role.eks-cluster-role.arn
  version  = "1.34"

  enabled_cluster_log_types = []

  vpc_config {
    subnet_ids = [
      aws_subnet.public-us-west-2a.id,
      aws_subnet.public-us-west-2b.id,
      aws_subnet.public-us-west-2c.id,
      aws_subnet.public-us-west-2d.id,
      aws_subnet.private-us-west-2a.id,
      aws_subnet.private-us-west-2b.id,
      aws_subnet.private-us-west-2c.id,
      aws_subnet.private-us-west-2d.id
    ]
  }

  bootstrap_self_managed_addons = true

  depends_on          = [aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy]
  deletion_protection = false
}
