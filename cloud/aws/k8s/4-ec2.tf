## Buscar AMI mais recente do Amazon Linux
data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}
resource "aws_key_pair" "main" {
  key_name   = var.user
  public_key = file("id_rsa.pub")
}

## Security Group para acesso SSH
resource "aws_security_group" "linux" {
  name   = format("%s-sg-linux", var.project_name)
  vpc_id = aws_vpc.vpc.id
  ingress {
    description = "ICMP"
    from_port   = 8
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = format("%s-sg-linux", var.project_name) }, local.common_tags)
}

## Instância Linux
resource "aws_instance" "linux" {
  ami                         = data.aws_ami.amzn-linux-2023-ami.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main.key_name
  subnet_id                   = aws_subnet.public-1a.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.linux.id]
  tags                        = merge({ Name = format("%s-linux", var.project_name) }, local.common_tags)
  user_data                   = filebase64("${path.module}/kubectl.sh")
  lifecycle {
    ignore_changes = all
  }
}

## Exibir IP Publivo Linux
output "ec2_linux" {
  value = aws_instance.linux.public_ip
}