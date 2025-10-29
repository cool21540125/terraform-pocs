# ====================================== Node group role ======================================

resource "aws_iam_role" "eks_nodegrouprole" {
  name = "EKS_NodegroupRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_eks_workernode_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodegrouprole.name
}
resource "aws_iam_role_policy_attachment" "node_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodegrouprole.name
}
resource "aws_iam_role_policy_attachment" "node_ecs_containerregistry_ro_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodegrouprole.name
}

# ------------------ Launch template ------------------

variable "ssh_key" {
  type    = string
  default = ""
}
resource "aws_launch_template" "template" {
  name                   = "eks-worker-node-templatee"
  key_name               = var.ssh_key
  update_default_version = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
}


# ------------------ EKS node group - x86_64 ------------------

resource "aws_eks_node_group" "eks_amd64_nodegroup" {
  cluster_name    = aws_eks_cluster.eks_devops.name
  node_group_name = "x86_64"
  node_role_arn   = aws_iam_role.eks_nodegrouprole.arn
  subnet_ids = [
    aws_subnet.private_us_west_2a.id,
    aws_subnet.private_us_west_2b.id,
    aws_subnet.private_us_west_2c.id,
    aws_subnet.private_us_west_2d.id,
  ]

  version         = aws_eks_cluster.eks_devops.version
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_linux2023_amd64.value)
  ami_type        = "AL2023_x86_64_STANDARD"

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]

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
      scaling_config[0].desired_size,
    ]
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    "k8s.io/cluster-autoscaler/enabled"                            = "true"
    "k8s.io/cluster-autoscaler/${aws_eks_cluster.eks_devops.name}" = "owned"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_eks_workernode_policy,
    aws_iam_role_policy_attachment.node_eks_cni_policy,
    aws_iam_role_policy_attachment.node_ecs_containerregistry_ro_policy,
  ]
}

# ------------------ EKS node group - arm64 ------------------

resource "aws_eks_node_group" "eks_arm64_nodegroup" {
  cluster_name    = aws_eks_cluster.eks_devops.name
  node_group_name = "arm64"
  node_role_arn   = aws_iam_role.eks_nodegrouprole.arn
  subnet_ids = [
    aws_subnet.private_us_west_2a.id,
    aws_subnet.private_us_west_2b.id,
    aws_subnet.private_us_west_2c.id,
    aws_subnet.private_us_west_2d.id,
  ]

  version         = aws_eks_cluster.eks_devops.version
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_linux2023_arm64.value)
  ami_type        = "AL2023_ARM_64_STANDARD"

  capacity_type  = "ON_DEMAND"
  instance_types = ["t4g.medium"]

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
      scaling_config[0].desired_size,
    ]
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    "k8s.io/cluster-autoscaler/enabled"                            = "true"
    "k8s.io/cluster-autoscaler/${aws_eks_cluster.eks_devops.name}" = "owned"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_eks_workernode_policy,
    aws_iam_role_policy_attachment.node_eks_cni_policy,
    aws_iam_role_policy_attachment.node_ecs_containerregistry_ro_policy,
  ]
}
