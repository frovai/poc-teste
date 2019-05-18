
## Define NAT GATEWAY and associate NAT GATEWAY with all private subnets
resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = "${aws_eip.eip-nat-gateway.id}"
  subnet_id     = "${aws_subnet.tools-subnet.id}"

  tags {
    Name = "NAT GATEWAY"
  }
}

## Create ELASTIC IP to use with this NAT GATEWAY

resource "aws_eip" "eip-nat-gateway" { 
    vpc = true
    tags {
    Name = "EIP NAT GATEWAY"
  }
} 