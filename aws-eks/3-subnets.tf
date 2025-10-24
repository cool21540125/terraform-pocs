# ------------------ public subnets ------------------
resource "aws_subnet" "public-us-west-2a" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = "10.66.0.0/20"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "public_eks_a_0"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public-us-west-2b" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = "10.66.16.0/20"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "public_eks_b_16"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public-us-west-2c" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = "10.66.32.0/20"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "public_eks_c_32"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public-us-west-2d" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = "10.66.48.0/20"
  availability_zone       = "us-west-2d"
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "public_eks_d_48"
    "kubernetes.io/role/elb" = "1"
  }
}


# ------------------ private subnets ------------------
resource "aws_subnet" "private-us-west-2a" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.66.64.0/20"
  availability_zone = "us-west-2a"

  tags = {
    "Name"                            = "private_eks_a_64"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private-us-west-2b" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.66.80.0/20"
  availability_zone = "us-west-2b"

  tags = {
    "Name"                            = "private_eks_b_80"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private-us-west-2c" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.66.96.0/20"
  availability_zone = "us-west-2c"

  tags = {
    "Name"                            = "private_eks_c_96"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private-us-west-2d" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.66.112.0/20"
  availability_zone = "us-west-2d"

  tags = {
    "Name" = "private_eks_d_112"

    "kubernetes.io/role/internal-elb" = "1"
  }
}
