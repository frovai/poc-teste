resource "aws_subnet" "spring-subnet2" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.spring_subnet_cidr2}"
  availability_zone = "${var.aws_availability_zone2}"

  tags {
    Name = "SPRING SUBNET2"
  }
}

# Define the route table SPRING
resource "aws_route_table" "spring-rt2" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gateway.id}"
  }

  tags {
    Name = "SPRING SUBNET RT2"
  }
}

# Assign the route table to the SPRING Subnet
resource "aws_route_table_association" "spring-rt2" {
  subnet_id      = "${aws_subnet.spring-subnet.id}"
  route_table_id = "${aws_route_table.spring-rt.id}"
}
