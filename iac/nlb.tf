resource "aws_lb" "ingress" {

  name = var.nlb_name

  internal           = false
  load_balancer_type = "network"

  subnets = data.aws_ssm_parameter.public_subnets[*].value

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false

  tags = {
    Name = "${var.nlb_name}"
  }

}

resource "aws_lb_target_group" "main" {
  name     = format("%s-https", aws_lb.ingress.name)
  port     = 31257
  protocol = "TCP"
  vpc_id   = data.aws_ssm_parameter.vpc.value
}

resource "aws_lb_listener" "main_public" {
  count             = var.certificate_arn != "" ? 1 : 0
  load_balancer_arn = aws_lb.ingress.arn
  port              = 443
  protocol          = "TLS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}