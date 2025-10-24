resource "aws_eip" "nat01" {
  domain = "vpc"

  tags = {
    Name = "nat_a"
  }
}

resource "aws_nat_gateway" "nat01" {
  allocation_id = aws_eip.nat01.id
  subnet_id     = aws_subnet.public-us-west-2a.id

  depends_on = [aws_internet_gateway.igw]
}
