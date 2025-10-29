# 
# VPC / IGW / NAT / Subnets / RouteTable
# 
# 10.66.0.0/16
#

# ================================= VPC =================================
resource "aws_vpc" "eks" {
  cidr_block           = "10.66.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "eks"
  }
}

# ================================= IGW =================================
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name = "main"
  }
}

# ================================= Subnets =================================
# ------------------ public subnets ------------------
resource "aws_subnet" "public_us_west_2a" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = "10.66.0.0/21"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true


  tags = {
    "Name"                   = "public_eks_a_0"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_us_west_2b" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = "10.66.8.0/21"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "public_eks_b_8"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_us_west_2c" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = "10.66.16.0/21"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "public_eks_c_16"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_us_west_2d" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = "10.66.24.0/21"
  availability_zone       = "us-west-2d"
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "public_eks_d_24"
    "kubernetes.io/role/elb" = "1"
  }
}


# ------------------ private subnets ------------------
resource "aws_subnet" "private_us_west_2a" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.66.32.0/21"
  availability_zone = "us-west-2a"

  tags = {
    "Name"                            = "private_eks_a_32"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_us_west_2b" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.66.40.0/21"
  availability_zone = "us-west-2b"

  tags = {
    "Name"                            = "private_eks_b_40"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_us_west_2c" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.66.48.0/21"
  availability_zone = "us-west-2c"

  tags = {
    "Name"                            = "private_eks_c_48"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_us_west_2d" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.66.56.0/21"
  availability_zone = "us-west-2d"

  tags = {
    "Name"                            = "private_eks_d_56"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# ================================= NAT =================================
resource "aws_eip" "nat01" {
  domain = "vpc"

  tags = {
    Name = "nat_a"
  }
}

resource "aws_nat_gateway" "nat01" {
  allocation_id = aws_eip.nat01.id
  subnet_id     = aws_subnet.public_us_west_2a.id

  depends_on = [aws_internet_gateway.igw]
}

# ================================= RouteTable =================================
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat01.id
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# ================================= RouteTable-Subnets-Associations =================================
# ------------------ private subnets ------------------
resource "aws_route_table_association" "private_us_west_2a" {
  subnet_id      = aws_subnet.private_us_west_2a.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_us_west_2b" {
  subnet_id      = aws_subnet.private_us_west_2b.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_us_west_2c" {
  subnet_id      = aws_subnet.private_us_west_2c.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_us_west_2d" {
  subnet_id      = aws_subnet.private_us_west_2d.id
  route_table_id = aws_route_table.private_rt.id
}

# ------------------ Public Subnets ------------------
resource "aws_route_table_association" "public_us_west_2a" {
  subnet_id      = aws_subnet.public_us_west_2a.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_us_west_2b" {
  subnet_id      = aws_subnet.public_us_west_2b.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_us_west_2c" {
  subnet_id      = aws_subnet.public_us_west_2c.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_us_west_2d" {
  subnet_id      = aws_subnet.public_us_west_2d.id
  route_table_id = aws_route_table.public_rt.id
}
