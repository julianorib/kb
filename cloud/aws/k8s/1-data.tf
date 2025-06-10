## Obter as AZ disponiveis
data "aws_availability_zones" "available" {}

data "aws_iam_user" "user" {
  user_name = var.user
}