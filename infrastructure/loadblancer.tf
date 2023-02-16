resource "aws_lb" "public-lb" {
  name               = "pub-lb"
  internal           = false
  ip_address_type = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ansible.id]
  subnets            = [aws_subnet.osos-pub.id, aws_subnet.osos-pub2.id ]
  tags = {
    Name = "public-lb"
  }
}
resource "aws_lb_target_group" "pv-targetGroup" {
  name     = "pv-targetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.osos-vpc.id
  tags = {
    Name = "private-targetgroup"
  }
}
# resource "aws_lb_target_group" "pv-targetGroup2" {
#   name     = "pv-targetGroup2"
#   port     = 9000
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.osos-vpc.id
#   tags = {
#     Name = "private-targetgroup2"
#   }
# }
resource "aws_lb_target_group_attachment" "attach-Nexus" {
  target_group_arn = aws_lb_target_group.pv-targetGroup.arn
  target_id        = aws_instance.Nexus.id
  port             = 8081
}
resource "aws_lb_target_group_attachment" "attach-Sonarqube" {
  target_group_arn = aws_lb_target_group.pv-targetGroup.arn
  target_id        = aws_instance.Sonarqube.id
  port             = 9000
}
resource "aws_lb_listener" "pub-listener" {
  load_balancer_arn = aws_lb.public-lb.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pv-targetGroup.arn
  }
}
# resource "aws_lb_listener" "pub-listener2" {
#   load_balancer_arn = aws_lb.public-lb.arn
#   protocol          = "HTTP"
#   port              = 9000
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.pv-targetGroup2.arn
#   }
# }