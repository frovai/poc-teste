
resource "aws_security_group" "elb-sg" {
    name = "ELB"
    description = "Allow incoming internet connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "IP Jenkins"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.vpc.id}"

    tags {
        Name = "ELB - PRIVATE SG"
    }
}