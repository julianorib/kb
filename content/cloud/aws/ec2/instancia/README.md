## Instâncias

<https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/concepts.html>

O Amazon Elastic Compute Cloud (Amazon EC2) oferece uma capacidade de computação escalável sob demanda na Nuvem Amazon Web Services (AWS). O uso do Amazon EC2 reduz os custos de hardware para que você possa desenvolver e implantar aplicações com mais rapidez. É possível usar o Amazon EC2 para executar quantos servidores virtuais forem necessários, configurar a segurança e as redes e gerenciar o armazenamento. É possível adicionar capacidade (aumentar a escala verticalmente) para lidar com tarefas de computação pesada, como processos mensais ou anuais ou picos no tráfego do site. Quando o uso diminui, você pode reduzir a capacidade (reduzir a escala verticalmente) de novo.

Uma instância do EC2 é um servidor virtual na Nuvem AWS. Quando executa uma instância do EC2, o tipo de instância que você especifica determina o hardware disponível para sua instância. Cada tipo de instância oferece um equilíbrio diferente entre recursos de computação, memória, armazenamento e rede. 

![instance](instance-types.png)

### Userdata

<https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/user-data.html>

Execute comandos (scripts) na primeira inicialização do Servidor.

```
#!/bin/bash
yum install -y nginx
systemctl enable nginx
systemctl start nginx
echo Hello World! > /usr/share/nginx/html/index.html
echo $(hostname -s) >> /usr/share/nginx/html/index.html
```

### Preços

<https://aws.amazon.com/pt/ec2/pricing/on-demand/>


### Criar uma instância

<https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/EC2_GetStarted.html>


## Terraform

Criação de uma instância em Terraform [main.tf](main.tf)


### Data Source: aws_availability_zones

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones>

### Data Source: aws_vpc

<https://registry.terraform.io/providers/hashicorp/aws/3.5.0/docs/data-sources/vpc>

### Data Source: aws_subnet

<https://registry.terraform.io/providers/hashicorp/aws/4.2.0/docs/data-sources/subnet>

### Resource: aws_security_group

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group>

### Resource: aws_key_pair

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair>

### Resource: aws_instance
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance>