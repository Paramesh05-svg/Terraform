resource "aws_launch_configuration" "web" {
  name          = "web_config"
  image_id      = "ami-0614680123427b75e " 
  instance_type = "t2.micro"
  security_groups = [aws_security_group.elb.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 80 &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  launch_configuration = aws_launch_configuration.web.id
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  health_check_type    = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "web-asg"
    propagate_at_launch = true
  }
}
