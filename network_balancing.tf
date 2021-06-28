resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tag, { Name = "${var.common_tag["Environment"]}internet_gw vpc" })
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(var.common_tag, { Name = "${var.common_tag["Environment"]}app load balancer vpc" })
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.availability_zone.names[0]
  map_public_ip_on_launch = true

  tags = merge(var.common_tag, { Name = "${var.common_tag["Environment"]}subnet_a" })
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.availability_zone.names[1]
  map_public_ip_on_launch = true

  tags = merge(var.common_tag, { Name = "${var.common_tag["Environment"]}subnet_b" })
}

resource "aws_lb" "app" {
  name                             = "app-lb"
  internal                         = false
  load_balancer_type               = "application"
  enable_cross_zone_load_balancing = true
  security_groups                  = [aws_security_group.sg_1.id]
  subnets                          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  enable_deletion_protection = false

  tags = merge(var.common_tag, { Name = "${var.common_tag["Environment"]}app load balancer" })
}

resource "aws_lb_target_group" "target_group" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.ubuntu_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instance_2" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.ubuntu_2.id
  port             = 80
}

resource "aws_route_table_association" "route_subnet_1" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_subnet_2" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.route_table.id
}
