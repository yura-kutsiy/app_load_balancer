provider "aws" {
  region = var.region
}

data "aws_region" "current" {}
data "aws_availability_zones" "availability_zone" {}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "ubuntu_1" {
  ami             = data.aws_ami.latest_ubuntu.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.sg_1.id]
  user_data       = file("server.sh")
  subnet_id       = aws_subnet.subnet_a.id
  key_name        = var.key_pair
  depends_on      = [aws_internet_gateway.gw]

  tags = merge(var.common_tag, { Name = "${var.common_tag["Environment"]}ubuntu_1 server" })
}

resource "aws_instance" "ubuntu_2" {
  ami             = "ami-05f7491af5eef733a"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.sg_1.id]
  user_data       = file("server.sh")
  subnet_id       = aws_subnet.subnet_b.id
  key_name        = var.key_pair
  depends_on      = [aws_internet_gateway.gw]

  tags = merge(var.common_tag, { Name = "${var.common_tag["Environment"]}ubuntu_2 server" })
}

resource "aws_security_group" "sg_1" {
  description = "allow http, ssh"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      description = "dev-ports"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
