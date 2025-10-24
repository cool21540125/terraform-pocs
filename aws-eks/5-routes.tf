resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat01.id
  }

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

# ------------------ private subnets ------------------
resource "aws_route_table_association" "private-us-west-2a" {
  subnet_id      = aws_subnet.private-us-west-2a.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private-us-west-2b" {
  subnet_id      = aws_subnet.private-us-west-2b.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private-us-west-2c" {
  subnet_id      = aws_subnet.private-us-west-2c.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private-us-west-2d" {
  subnet_id      = aws_subnet.private-us-west-2d.id
  route_table_id = aws_route_table.private.id
}

# ------------------ Public Subnets ------------------
resource "aws_route_table_association" "public-us-west-2a" {
  subnet_id      = aws_subnet.public-us-west-2a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public-us-west-2b" {
  subnet_id      = aws_subnet.public-us-west-2b.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public-us-west-2c" {
  subnet_id      = aws_subnet.public-us-west-2c.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public-us-west-2d" {
  subnet_id      = aws_subnet.public-us-west-2d.id
  route_table_id = aws_route_table.public.id
}
