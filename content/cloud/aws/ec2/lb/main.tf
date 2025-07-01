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

## Obter a VPC Default 
data "aws_vpc" "default" {}

## Obter as Subnets Default
data "aws_subnets" "default" {}

## Criar um Security Group de acesso WEB
resource "aws_security_group" "acesso-in-80" {
  name        = "acesso-in-web"
  description = "permite acesso in 80"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Criar o Loadbalance Test
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.acesso-in-80.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

## Criar um Target Group 
resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

## Criar um Listener Fixed Response
# resource "aws_lb_listener" "test" {
#   load_balancer_arn = aws_lb.test.arn
#   port =  "80"

#   default_action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Hello World!"
#       status_code  = "200"
#     }
#   }
# }

## Criar um Listener Forward
resource "aws_lb_listener" "forward" {
  load_balancer_arn = aws_lb.test.arn
  port = "80"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
  
}

## Associar / Registrar uma Instância no Target Group
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = "i-07a8b06e4ababdd9b"
  port             = 80
}