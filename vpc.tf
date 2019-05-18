# Define the VPC
resource "aws_vpc" "vpc" {
  cidr_block       = "10.23.0.0/16"

  tags {
    Name = "VPC"
  }
}