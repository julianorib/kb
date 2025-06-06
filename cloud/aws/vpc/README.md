# VPC

## Ref:
<https://aws.amazon.com/pt/vpc/>\
<https://docs.aws.amazon.com/pt_br/vpc/?icmpid=docs_homepage_featuredsvcs>\
<https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/how-it-works.html>\
<https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/default-vpc-components.html>

O Amazon Virtual Private Cloud (Amazon VPC) oferece controle total sobre seu ambiente de redes virtual, incluindo posicionamento de recursos, conectividade e segurança. Comece a usar configurando sua VPC no console de serviço AWS. Em seguida, adicione recursos a ela, como instâncias do Amazon Elastic Compute Cloud (EC2) e Amazon Relational Database Service (RDS). Por fim, defina como suas VPCs se comunicam entre si, entre contas, zonas de disponibilidade (AZs) ou Regiões da AWS. 

![VPC](vpc-resource-map-update.png)

## Custo

<https://aws.amazon.com/pt/vpc/pricing/>

Não há custo adicional por usar a VPC. Porém, alguns componentes da VPC são cobrados, como os gateways NAT, o Gerenciador de Endereços IP, o espelhamento de tráfego, o Analisador de Acessibilidade e o Analisador de Acesso à Rede.

## Componentes Principais

- VPC
- Sub-redes
- Tabela de Rotas
- Internet Gateway
- NAT Gateway
- Elastic IP 
- Security Groups
- Vários outros

## VPC

A VPC é uma rede virtual muito semelhante a uma rede tradicional que você pode operar no seu próprio data center. Após criar uma VPC, você pode adicionar sub-redes.

## Endereçamento

<https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/vpc-cidr-blocks.html>


## Sub-rede

<https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/configure-subnets.html#subnet-basics>

Uma sub-rede consiste em um intervalo de endereços IP na VPC. Cada sub-rede fica alocada em uma única zona de disponibilidade. Após adicionar as sub-redes, você pode implantar os recursos da AWS na VPC.

### Public

A sub-rede tem uma rota direta para um gateway da Internet. Os recursos podem acessar a Internet e serem acessados da Internet.

### Private

A sub-rede não tem uma rota direta para um gateway da Internet. Os recursos em uma sub-rede privada exigem um dispositivo NAT para acessar a Internet pública.

## Tabela de Rotas

<https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/VPC_Route_Tables.html>

Use tabela de rotas para direcionar o trafego da sub-rede ou do Gateway.

## Internet Gateway

<https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/VPC_Internet_Gateway.html>

Um gateway da Internet é um componente da VPC horizontalmente dimensionado, redundante e altamente disponível que permite a comunicação entre a VPC e a Internet. Ele oferece suporte para tráfego IPv4 e IPv6. Não causa riscos de disponibilidade ou restrições de largura de banda no tráfego de rede.

## NAT Gateway

<https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/vpc-nat-gateway.html>

Um gateway NAT é um serviço de Network Address Translation (NAT – Conversão de endereços de rede). Você pode usar um gateway NAT para que as instâncias em uma sub-rede privada possam se conectar a serviços fora da VPC, mas os serviços externos não podem iniciar uma conexão com essas instâncias.

Para um cenário de alta disponibilidade, o ideal é ter um NAT Gateway em cada Zona de disponibilidade, pois se uma AZ tenha falha, as outras ainda possam acessar a Internet.

Ao criar um gateway NAT, você deve especificar um dos seguintes tipos de conectividade:

### Public

(Padrão) instâncias em sub-redes privadas podem se conectar à Internet por meio de um gateway NAT público, mas não podem receber conexões de entrada não solicitadas da Internet. 

Você cria um gateway NAT público em uma sub-rede pública e deve associar um endereço IP elástico ao gateway NAT na criação. 

### Private

Instâncias em sub-redes privadas podem se conectar a outras VPCs ou à sua rede on-premises por meio de um gateway NAT privado. Você pode rotear o tráfego do gateway NAT por meio de um gateway de trânsito ou de um gateway privado virtual. Não é possível associar um endereço IP elástico a um gateway NAT privado. 


## Elastic IP

<https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html>

Um Endereço IP elástico é um endereço IPv4 estático projetado para computação em nuvem dinâmica. Um endereço IP elástico é alocado para a conta da AWS e será seu até que você o libere. Com um endereço IP elástico, é possível mascarar a falha de uma instância ou software remapeando rapidamente o endereço para outra instância na conta. Como alternativa, é possível especificar o endereço IP elástico em um registro DNS para o seu domínio, para que ele acione a sua instância. 

Você aloca um Elastic IP para sua conta e o associa à instância ou a uma interface de rede.

## Security Groups

<https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/ec2-security-groups.html>

Um grupo de segurança atua como firewall virtual para as instâncias do EC2 visando controlar o tráfego de entrada e de saída. As regras de entrada controlam o tráfego de entrada para a instância e as regras de saída controlam o tráfego de saída da instância. Ao executar sua instância, é possível especificar um ou mais grupos de segurança. Se você não especificar um grupo de segurança, o Amazon EC2 usará o grupo de segurança padrão para a VPC. 

## Terraform

VPC de exemplo com seus componentes em Terraform [main.tf](main.tf)

### Resource: aws_vpc
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc>

### Resource: aws_subnet
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet>

### Resource: aws_route_table
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table>

### Resource: aws_eip
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip>

### Resource: aws_nat_gateway
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway>

### Resource: aws_internet_gateway
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway>

### Resource: aws_security_group
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group.html>


