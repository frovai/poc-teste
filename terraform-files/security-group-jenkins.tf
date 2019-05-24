
resource "aws_security_group" "jenkins-sg" {
    name = "JENKINS"
    description = "Allow incoming internet connections."

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["177.143.150.143/32"]
        description = "IP Empresa"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["10.23.0.0/16"]
        description = "IP Mundo"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["177.143.150.143/32"]
        description = "IP Mundo"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.vpc.id}"

    tags {
        Name = "JENKINS - PUBLIC SG"
    }
}
