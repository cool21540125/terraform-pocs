data "aws_region" "ds_region" {}
data "aws_caller_identity" "current" {}


# ====================================== Launch Template - EC2 spec ======================================

data "aws_ssm_parameter" "eks_ami_linux2023_amd64" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_devops.version}/amazon-linux-2023/x86_64/standard/recommended/release_version"
}

data "aws_ssm_parameter" "eks_ami_linux2023_arm64" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_devops.version}/amazon-linux-2023/arm64/standard/recommended/release_version"
}


# ====================================== EKS - Permission & Policy ======================================



# ====================================== oooo ======================================
