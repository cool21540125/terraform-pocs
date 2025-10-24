resource "aws_vpc" "eks" {
  cidr_block = "10.66.0.0/16"

  tags = {
    Name = "eks"
  }
}
