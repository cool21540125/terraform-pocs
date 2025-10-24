resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name = "main"
  }
}
