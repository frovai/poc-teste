resource "aws_elb" "elb-spring" {
  name               = "elb-spring"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/message"
    interval            = 30
  }

  instances                   = ["${aws_instance.spring-instance.id} , ${aws_instance.spring-instance2.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "elb-spring"
  }
}

resource "aws_elb_attachment" "elb-att" {
  depends_on = "${aws_elb.elb-spring}"
  elb      = "${aws_elb.elb-spring.id}"
  instance = ["${aws_instance.spring-instance.id} , ${aws_instance.spring-instance2.id}"]
}