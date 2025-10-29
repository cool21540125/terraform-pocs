# ====================================== EKS - IAM access entries ======================================

data "aws_iam_user" "iam_tony" {
  user_name = "tony"
}
resource "aws_eks_access_entry" "access_entry_tony" {
  cluster_name      = aws_eks_cluster.eks_devops.name
  principal_arn     = data.aws_iam_user.iam_tony.arn
  kubernetes_groups = []
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "access_entry_association_tony" {
  cluster_name  = aws_eks_cluster.eks_devops.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.aws_iam_user.iam_tony.arn

  access_scope {
    type       = "cluster"
    namespaces = []
  }
}
