resource "aws_elb" "web" {
  name               = "my-load-balancer"
  availability_zones = ["ap-south-1a", "ap-south-1b"]
  security_groups    = [aws_security_group.elb.id]
  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }
  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "web_elb"
  }
}
