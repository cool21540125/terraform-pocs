# ------------------ Node group role ------------------
resource "aws_iam_role" "eks-nodegrouprole" {
  name = "EKS-NodeGroupRole"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-nodegrouprole.name
}
resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-nodegrouprole.name
}
resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-nodegrouprole.name
}

# ------------------ Launch template ------------------
variable "ssh_key" {
  type    = string
  default = "weiby-poc-2025"
}
resource "aws_launch_template" "template" {
  name                   = "eks-worker-node-template"
  key_name               = var.ssh_key
  update_default_version = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

}


# ------------------ EKS node group - x86_64 ------------------
data "aws_ssm_parameter" "eks_ami_linux2023_amd64" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_devops.version}/amazon-linux-2023/x86_64/standard/recommended/release_version"
}

resource "aws_eks_node_group" "eks_amd64_nodegroup" {
  node_group_name = "x86_64"
  cluster_name    = aws_eks_cluster.eks_devops.name

  version         = aws_eks_cluster.eks_devops.version
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_linux2023_amd64.value)
  ami_type        = "AL2023_x86_64_STANDARD"

  node_role_arn  = aws_iam_role.eks-nodegrouprole.arn
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]
  subnet_ids = [
    aws_subnet.private-us-west-2a.id,
    aws_subnet.private-us-west-2b.id,
    aws_subnet.private-us-west-2c.id,
    aws_subnet.private-us-west-2d.id,
  ]

  launch_template {
    id      = aws_launch_template.template.id
    version = aws_launch_template.template.latest_version
  }

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 3
  }

  lifecycle {
    ignore_changes = [
      release_version,
    ]
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# ------------------ EKS node group - arm64 ------------------
data "aws_ssm_parameter" "eks_ami_linux2023_arm64" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_devops.version}/amazon-linux-2023/arm64/standard/recommended/release_version"
}

resource "aws_eks_node_group" "eks_arm64_nodegroup" {
  node_group_name = "arm64"
  cluster_name    = aws_eks_cluster.eks_devops.name

  version         = aws_eks_cluster.eks_devops.version
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_linux2023_arm64.value)
  ami_type        = "AL2023_ARM_64_STANDARD"

  node_role_arn  = aws_iam_role.eks-nodegrouprole.arn
  capacity_type  = "ON_DEMAND"
  instance_types = ["t4g.medium"]
  subnet_ids = [
    aws_subnet.private-us-west-2a.id,
    aws_subnet.private-us-west-2b.id,
    aws_subnet.private-us-west-2c.id,
    aws_subnet.private-us-west-2d.id,
  ]

  launch_template {
    id      = aws_launch_template.template.id
    version = aws_launch_template.template.latest_version
  }

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 5
  }

  lifecycle {
    ignore_changes = [
      release_version,
    ]
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
