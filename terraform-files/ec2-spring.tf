resource "aws_instance" "spring-instance" {
  ami               = "${var.ami_spring}"
  instance_type     = "${var.instance_type_spring}"
  availability_zone = "${var.aws_availability_zone}"
  subnet_id         = "${aws_subnet.spring-subnet.id}"
  private_ip        = "${var.spring_instance_ip}"
  key_name          = "${var.aws_key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.spring-sg.id}"] 
  root_block_device {
        volume_size = 20
      }
  tags {
    Name = "SPRING"
  }
}

resource "aws_volume_attachment" "spring-ebs-att" {
  depends_on = ["aws_ebs_volume.spring-ebs"]
  device_name = "/dev/xvdf"
  volume_id   = "${aws_ebs_volume.spring-ebs.id}"
  instance_id = "${aws_instance.spring-instance.id}"
}

resource "aws_ebs_volume" "spring-ebs" {
  depends_on = ["aws_instance.spring-instance"]
  availability_zone = "${var.aws_availability_zone}"
  size              = 20
  type = "gp2"

  tags {
    Name = "SPRING EBS"
  }
}

