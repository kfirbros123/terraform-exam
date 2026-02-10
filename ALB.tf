resource "aws_lb" "alb" {
  name               = "exam-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.aws_infra.sg_id]          # use existing SG
  subnets            = module.aws_infra.public_subnet_id # your public subnet
}


resource "aws_lb_target_group" "tg" {
  name     = "exam-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.aws_infra.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}


resource "aws_launch_template" "app" {
  name_prefix   = "kfir-exam-lt-"
  image_id      = var.APP_IMAGE
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    module.aws_infra.sg_id
  ]
  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e

    apt-get update -y
    apt-get install -y nginx

    systemctl start nginx
    systemctl enable nginx
  EOF
  )
}


resource "aws_autoscaling_group" "asg" {
  name                = "exam-asg"
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [module.aws_infra.public_subnet_id[0]]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]

  tag {
    key                 = "Name"
    value               = "exam-asg"
    propagate_at_launch = true
  }
  # depends_on = [module.aws_infra]
}


output "Loadblanacer_URL" {
  value      = aws_lb.alb.dns_name
  depends_on = [aws_lb.alb]
}
output "INFO" {
  value      = "also installed nginx to make sure the loadbalancer works"
  depends_on = [aws_lb.alb]
}