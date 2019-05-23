resource "aws_lb" "elb-spring" {
  name               = "ELB-SPRING"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.elb-sg.id}"]
  
  subnet_mapping {
    subnet_id = "${aws_subnet.spring-subnet.id}"
  }

  subnet_mapping {
    subnet_id = "${aws_subnet.spring-subnet2.id}"
  }
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "elb-listener" {
  load_balancer_arn = "${aws_lb.elb-spring.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.elb-target-group.arn}"
  }
}
resource "aws_lb_target_group_attachment" "elb-target-group-att" {
  target_group_arn = "${aws_lb_target_group.elb-target-group.arn}"
  target_id        = "${aws_instance.spring-instance.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "elb-target-group-att2" {
  target_group_arn = "${aws_lb_target_group.elb-target-group.arn}"
  target_id        = "${aws_instance.spring-instance2.id}"
  port             = 80
}
resource "aws_lb_target_group" "elb-target-group" {
  name     = "elb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = "10"
    port                = "80"
    path                = "/message"
    protocol            = "HTTP"
    interval            = 30
    matcher             = "200"
  }
}

