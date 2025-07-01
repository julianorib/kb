terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

## Obter as AZ disponiveis
data "aws_availability_zones" "available" {}

## Obter a VPC Default 
data "aws_vpc" "default" {}

## Obter as Subnets Default
data "aws_subnets" "default" {}

## Obter a AMI Amazon Linux mais recente
data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

## Criar um Security Group de acesso Internet
resource "aws_security_group" "acesso-out-internet" {
  name        = "acesso-out-internet"
  description = "permite acesso out internet"
  vpc_id      = data.aws_vpc.default.id

  egress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Criar um Security Group de acesso SSH
resource "aws_security_group" "acesso-in-ssh" {
  name        = "acesso-in-ssh"
  description = "permite acesso in ssh"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Criar um Security Group de acesso WEB
resource "aws_security_group" "acesso-in-web" {
  name        = "acesso-in-http"
  description = "permite acesso in web"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Criar uma Key Pair
resource "aws_key_pair" "example" {
  key_name   = "example"
  public_key = file("/home/julianorib/.ssh/id_rsa.pub")
}

## Criar um Modelo de Execução para as VMS
resource "aws_launch_template" "example" {
  name_prefix            = "example"
  image_id               = data.aws_ami.amzn-linux-2023-ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.acesso-out-internet.id, aws_security_group.acesso-in-ssh.id, aws_security_group.acesso-in-web.id]
  key_name               = aws_key_pair.example.key_name
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "example"
    }
  }
  user_data = filebase64("${path.module}/example.sh")
}

## Criar um Grupo de Auto Scaling
resource "aws_autoscaling_group" "example" {
  name_prefix         = "example"
  vpc_zone_identifier = data.aws_subnets.default.ids


  desired_capacity = 2
  max_size         = 5
  min_size         = 1

  launch_template {
    id      = aws_launch_template.example.id
    version = aws_launch_template.example.latest_version
  }
  tag {
    key                 = "Name"
    value               = "example"
    propagate_at_launch = true
  }
}

## Criar uma Politica de Auto Scaling
resource "aws_autoscaling_policy" "avg_cpu_scaling" {
  name                   = "avg_cpu_scaling"
  autoscaling_group_name = aws_autoscaling_group.example.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 20.0
  }
  estimated_instance_warmup = 180
}


## Criar um Security Group para o LoadBalancer
resource "aws_security_group" "asglb" {
  name        = "ASGLB"
  description = "Permitir acesso Web"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Criar o Loadbalancer para o ASG
resource "aws_lb" "asglb" {
  name               = "ASGLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.asglb.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

## Criar um Target Group para o LoadBalancer
resource "aws_lb_target_group" "asglb" {
  name     = "ASGLB"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

## Criar um Listener Forward
resource "aws_lb_listener" "forward" {
  load_balancer_arn = aws_lb.asglb.arn
  port              = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asglb.arn
  }

}

## Associar / Registrar o ASG ao Loadbalance
resource "aws_autoscaling_attachment" "asglb" {
  autoscaling_group_name = aws_autoscaling_group.example.id
  lb_target_group_arn    = aws_lb_target_group.asglb.arn
}