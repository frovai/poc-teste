# Define the public subnet where the TOOLS is working
resource "aws_subnet" "tools-subnet" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.tools_subnet_cidr}"
  availability_zone = "${var.aws_availability_zone}"

  tags {
    Name = "TOOLS SUBNET"
  }
}

# Define the route table TOOLS
resource "aws_route_table" "tools-rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet-gateway.id}"
  }

  tags {
    Name = "TOOLS SUBNET RT"
  }
}

# Assign the route table to the TOOLS Subnet
resource "aws_route_table_association" "tools-rt" {
  subnet_id      = "${aws_subnet.tools-subnet.id}"
  route_table_id = "${aws_route_table.tools-rt.id}"
}