
## Balanceamento de Carga

<https://docs.aws.amazon.com/pt_br/elasticloadbalancing/latest/userguide/what-is-load-balancing.html>

O Elastic Load Balancing distribui automaticamente seu tráfego de entrada em vários destinos, como EC2 instâncias, contêineres e endereços IP, em uma ou mais zonas de disponibilidade. Ele monitora a integridade dos destinos registrados e roteia o tráfego apenas para os destinos íntegros. O Elastic Load Balancing escalona automaticamente sua capacidade de balanceador de carga em resposta a mudanças ao tráfego de entrada.

O Elastic Load Balancing é compatível com os seguintes tipos de balanceadores de carga:

- Application Load Balancers
- Network Load Balancers
- Balanceadores de carga de gateway
- Classic Load Balancers

<https://docs.aws.amazon.com/pt_br/elasticloadbalancing/latest/userguide/how-elastic-load-balancing-works.html>


### Preços

<https://aws.amazon.com/pt/elasticloadbalancing/pricing/>

### Criar um Balanceador de Carga

<https://docs.aws.amazon.com/pt_br/elasticloadbalancing/latest/userguide/load-balancer-getting-started.html>\
<https://docs.aws.amazon.com/pt_br/elasticloadbalancing/latest/application/application-load-balancer-getting-started.html>

#### Grupo de Destino

Crie um grupo de destino, que é usado no roteamento da solicitação. A regra padrão para o seu listener roteia solicitações para os destinos registrados neste grupo de destino. O load balancer verifica a integridade dos destinos desse grupo de destino usando as configurações de verificação de integridade definidas para o grupo de destino.\
Para que um grupo de destino seja atualizado com Destinos registrados automaticamente, ele deve ser associado a um Auto Scaling Group.

#### Defina o tipo de balanceador de carga

O Elastic Load Balancing oferece suporte para diferentes tipos de balanceadores de carga, exemplo: Application Load balancer.

#### Defina as Zonas e Subnets e Security Groups

#### Defina as regras de Listener e Associe o Grupo de Destino

## Terraform

Criação de um LoadBalancer em Terraform [main.tf](main.tf)

### Resource: aws_lb

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb>

### Resource: aws_lb_listener

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener>

### Resource: aws_lb_target_group

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group>

### Resource: aws_lb_target_group_attachment

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment>