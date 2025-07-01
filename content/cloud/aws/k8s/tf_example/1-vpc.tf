## Obter as AZ disponiveis
data "aws_availability_zones" "available" {}

## Cria uma VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge({ Name = format("%s-vpc", var.project_name) }, local.common_tags)
}

## Cria uma Subnet Privada na AZ 1
resource "aws_subnet" "private-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags              = merge({ Name = format("%s-subnet-private-1a", var.project_name) }, local.common_tags)
}

## Cria uma Subnet Privada na AZ 2
resource "aws_subnet" "private-1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags              = merge({ Name = format("%s-subnet-private-1b", var.project_name) }, local.common_tags)

}

## Cria uma Subnet Privada na AZ 3
resource "aws_subnet" "private-1c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]
  tags              = merge({ Name = format("%s-subnet-private-1c", var.project_name) }, local.common_tags)

}

## Cria uma Subnet Publica na AZ 1
resource "aws_subnet" "public-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags              = merge({ Name = format("%s-subnet-public-1a", var.project_name) }, local.common_tags)
}

## Cria uma Subnet Publica na AZ 2
resource "aws_subnet" "public-1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags              = merge({ Name = format("%s-subnet-public-1b", var.project_name) }, local.common_tags)
}

## Cria uma Subnet Publica na AZ 3
resource "aws_subnet" "public-1c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.103.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]
  tags              = merge({ Name = format("%s-subnet-public-1c", var.project_name) }, local.common_tags)
}


## Cria um Elastic IP na AZ 1
resource "aws_eip" "vpc_eip_1a" {
  domain = "vpc"
  tags   = merge({ Name = format("%s-eip-1a", var.project_name) }, local.common_tags)
}

## Cria um Elastic IP na AZ 2
resource "aws_eip" "vpc_eip_1b" {
  domain = "vpc"
  tags   = merge({ Name = format("%s-eip-1b", var.project_name) }, local.common_tags)
}

## Cria um Elastic IP na AZ 3
resource "aws_eip" "vpc_eip_1c" {
  domain = "vpc"
  tags   = merge({ Name = format("%s-eip-1c", var.project_name) }, local.common_tags)
}


## Cria um NAT Gateway na AZ 1
resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.vpc_eip_1a.id
  subnet_id     = aws_subnet.public-1a.id
  tags          = merge({ Name = format("%s-nat-gw-1a", var.project_name) }, local.common_tags)
}

## Cria um NAT Gateway na AZ 2
resource "aws_nat_gateway" "nat_1b" {
  allocation_id = aws_eip.vpc_eip_1b.id
  subnet_id     = aws_subnet.public-1b.id
  tags          = merge({ Name = format("%s-nat-gw-1b", var.project_name) }, local.common_tags)
}

## Cria um NAT Gateway na AZ 3
resource "aws_nat_gateway" "nat_1c" {
  allocation_id = aws_eip.vpc_eip_1c.id
  subnet_id     = aws_subnet.public-1c.id
  tags          = merge({ Name = format("%s-nat-gw-1c", var.project_name) }, local.common_tags)
}


## Cria um Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = format("%s-igw", var.project_name) }, local.common_tags)
}


## Cria uma Tabela de Rotas para Subnet Privada 1
resource "aws_route_table" "private_access_1a" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = format("%s-rtb-priv-1a", var.project_name) }, local.common_tags)
}

## Cria uma Tabela de Rotas para Subnet Privada 2
resource "aws_route_table" "private_access_1b" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = format("%s-rtb-priv-1b", var.project_name) }, local.common_tags)
}

## Cria uma Tabela de Rotas para Subnet Privada 3
resource "aws_route_table" "private_access_1c" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = format("%s-rtb-priv-1c", var.project_name) }, local.common_tags)
}

## Cria uma Rota na Tabela de Rotas para Subnet Privada 1 e aponta como destino o NAT Gateway 1
resource "aws_route" "private_access_1a" {
  route_table_id         = aws_route_table.private_access_1a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_1a.id
}

## Cria uma Rota na Tabela de Rotas para Subnet Privada 2 e aponta como destino o NAT Gateway 2
resource "aws_route" "private_access_1b" {
  route_table_id         = aws_route_table.private_access_1b.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_1b.id
}

## Cria uma Rota na Tabela de Rotas para Subnet Privada 3 e aponta como destino o NAT Gateway 3
resource "aws_route" "private_access_1c" {
  route_table_id         = aws_route_table.private_access_1c.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_1c.id
}

## Associa a Tabela de Rotas 1 para Subnet Privada 1 
resource "aws_route_table_association" "route_private_1a" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.private_access_1a.id
}

## Associa a Tabela de Rotas 1 para Subnet Privada 2
resource "aws_route_table_association" "route_private_1b" {
  subnet_id      = aws_subnet.private-1b.id
  route_table_id = aws_route_table.private_access_1b.id
}

## Associa a Tabela de Rotas 1 para Subnet Privada 3
resource "aws_route_table_association" "route_private_1c" {
  subnet_id      = aws_subnet.private-1c.id
  route_table_id = aws_route_table.private_access_1c.id
}

## Cria uma Tabela de Rotas para Subnets Publicas
resource "aws_route_table" "public_access" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = format("%s-rtb-pub", var.project_name) }, local.common_tags)
}

## Cria uma Rota na Tabela de Rotas para Subnets Publicas e aponta como destino o Internet Gateway
resource "aws_route" "public_access" {
  route_table_id         = aws_route_table.public_access.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

## Associa a Tabela de Rotas 1 para Subnet Publica 1
resource "aws_route_table_association" "route_public_1a" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.public_access.id
}

## Associa a Tabela de Rotas 1 para Subnet Publica 2
resource "aws_route_table_association" "route_public_1b" {
  subnet_id      = aws_subnet.public-1b.id
  route_table_id = aws_route_table.public_access.id
}

## Associa a Tabela de Rotas 1 para Subnet Publica 3
resource "aws_route_table_association" "route_public_1c" {
  subnet_id      = aws_subnet.public-1c.id
  route_table_id = aws_route_table.public_access.id
}
