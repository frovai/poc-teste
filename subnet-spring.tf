# Define the public subnet where the SPRING is working
resource "aws_subnet" "spring-subnet" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.spring_subnet_cidr}"
  availability_zone = "${var.aws_availability_zone}"

  tags {
    Name = "SPRING SUBNET"
  }
}

# Define the route table SPRING
resource "aws_route_table" "spring-rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gateway.id}"
  }

  tags {
    Name = "SPRING SUBNET RT"
  }
}

# Assign the route table to the SPRING Subnet
resource "aws_route_table_association" "spring-rt" {
  subnet_id      = "${aws_subnet.spring-subnet.id}"
  route_table_id = "${aws_route_table.spring-rt.id}"
}

