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

## Obter a AMI Amazon Linux mais recente
data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

## Criar a Instância Example
resource "aws_instance" "example" {
  ami             = data.aws_ami.amzn-linux-2023-ami.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.example.key_name
  subnet_id       = data.aws_subnets.default.ids[0]
  security_groups = [aws_security_group.acesso-out-internet.id, aws_security_group.acesso-in-ssh.id, aws_security_group.acesso-in-web.id]

  tags = {
    Name = "HelloWorld"
  }
}

## Mostrar o IP Publico para acesso
output "public_ip" {
  value = aws_instance.example.public_ip
}

