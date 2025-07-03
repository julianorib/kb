# Terraform Resumido

## Links
Site official: https://www.terraform.io/
<br>
Providers: https://registry.terraform.io/browse/providers
<br>
Documentação: https://developer.hashicorp.com/terraform?product_intent=terraform
<br>
Registry: https://registry.terraform.io/?product_intent=terraform
<br>
Variáveis: https://developer.hashicorp.com/terraform/language/values/variables
<br>
Modules: https://registry.terraform.io/browse/modules
<br>
Funções: https://developer.hashicorp.com/terraform/language/functions
<br>
Provisioners: https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax
<br>
Backends: https://developer.hashicorp.com/terraform/language/settings/backends/configuration


## Básico do básico
Todo projeto necessita de ao menos 1 provider. Seja local, seja Cloud, etc. 
e todo projeto inicia com main.tf.

Sempre inicie pesquisando a documentação do provider.
Na página de documentação de cada provider, do lado esquerdo tem "Use provider".
Copie o código e cole no main.tf.

```
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "local" {
  # Configuration options
}
```

Recomenda-se que não utilize autenticação diretamente nos arquivos do Terraform.
Utilize variávies de ambiente (EXPORT) Linux ou (SET) Windows.

Iniciando um projeto:
```
terraform init
```

Validando código do projeto:
```
terraform validate
```

Planejando e Criando um projeto:
```
terraform plan
terraform apply 
terraform apply -auto-aprrove
```

Formatando o código de um projeto:
```
terraform fmt
```

Destruindo um projeto:
```
terraform destroy
```

## Estrutura
Um projeto bem estruturado, contém os seguintes arquivos:
```
README.md
main.tf
variables.tf
terraform.tfvars (nao deve publicar)
locals.tf
outputs.tf
modules/
```

## Recursos
Os recursos são criados de acordo com cada provider.
Sempre pesquise na documentação do provider.

```
resource "provider_nomerecurso" "example" {
  name = 
  description =
  option1 =
  option 2 =
}
```

## Interpolation (interpolação)

```
${...}
```
Com a interpolação é possível manipular valores de variáveis, strings, funções, etc.
```
"Hello, ${var.name}!"
```

Neste exemplo, o resultado pode ser:
"Olá, Juan!".

## Format

project_name = "xpto"
```
format("%s-EC2", var.project_name)
```

Resultado:
```
xpto-EC2
```

## Locals

Variáveis locais.
Normalmente utilizado com Tags, ou informações que se repetem em muitos lugares.
Pode-se utilizar funções dentro do Locals.
Devem ser criados dentro do locals.tf.
```
locals { 
  name = "example"
  owner = "juliano"
}
```
```
locals {
  common_tags = {
    service = local.name
    owner = local.owner
  }
}
```
```
locals {
  instancias = concat(aws_instance.blue.*.id, aws_instance.green.*.id)
}
```

Para utilizar no recurso um local:
```
tags = local.common_tags
```

```
other = locals.instancias
```

## Variáveis

As variávies devem ser criadas no arquivo variables.tf.
É bom declarar o tipo e default. Mas o valor pode ser alterado no arquivo terraform.tfvars.
```
variable "example" {
  type = string
  description = "descrição da variável"
  default = "valor"
}
```
Há diversos tipos de variáveis, sendo possível criar praticamente de qualquer forma.
```
variable "subnet" {
default = [
  { regiao = "a", subnet = "1" }
  { regiao = "b", subnet = "2" }
]
}
```

Para utilizar no recurso uma variável, depende do tipo, mas segue alguns exemplos:
```
region = var.regiao
```
```
name = "${var.name}-recurso"
```
```
availability_zone = "${var.subnet[0].regiao}"
availability_zone = "${var.subnet[count.index].regiao}"
```

## Random_pet

Este recurso permite criar nomes aleatórios para Recursos ou Variáveis, etc.
Como utilizar:
```
resource "random_pet" "example" {
  length = 5
}
```
```
...
name = "${random_pet.example.id}-teste"
...
```

### Os tipos de variáveis

- String
- Number
- Boolean
- List
- Map
- Set
- Object
- Tuple

### 3 formas para preencher as variáveis

- Preenchendo o arquivo variables.tfvars:

```
variavel = valor
```
- Criando variáveis de ambiente:

```
export TF_VAR_variavel=valor
```

- Na hora de aplicar o Projeto:

```
terraform apply -var="nomevariavel='valorvariavel'"
```

### Validação de variáveis

É possivel criar condições para que não seja informado um valor incorreto em variáveis.
```
variable teste {
  default = "texto"
  validation {
    condition = contains(var.teste, "texto")
    error_message = "Digite a palavra texto"
  }
}
```

## Outputs

Os outputs são para mostrar informações ao final da execução do projeto.
Normalmente um IP, uma Tag, algum valor que seja necessário capturar.
Deve-se consultar a documentação e verificar no Recurso daquele provider qual Output está disponível.
A declaração do mesmo é da seguinte forma:

```
output "example" {
  value = provider_recurso.public_ip
}
```

## Meta Arguments

Formas de repetir a criação de recursos de formas que economizam código.

- depends_on
Força a criação de um Recurso antes que outro.

- count
Uma forma de criar diversos recursos iguais.
Formas de utilizar:

```
resource "aws_instance" "virtual_machine" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.ssh_key.key_name
  subnet_id       = aws_subnet.subnet_public[count.index].id
  security_groups = [aws_security_group.acesso-out-internet.id, aws_security_group.acesso-in-ssh.id]
  count           = 3

  tags = {
    Name = "Virtual Machine ${count.index}
  }
}
```

Também é possível contar uma quantidade de itens dentro de uma variável:
```
  count = length(var.subnet)
```
- for each

Parecido com o Count, porém busca através de uma Lista, Objeto, Set, Map.

- dynamic
Uma outra forma de criar diversos recursos semelhantes.
Formas de utilizar:

```
variable "ingress" {
  default = [
    22 = { description = "inbound ssh", cidr_blocks = [ "0.0.0.0/0" ] }
    80 = { description = "inbound http", cidr_blocks = [ "0.0.0.0/0" ] }
    443 = { description = "inbound https", cidr_blocks = [ "0.0.0.0/0" ] }
  ]
}
```
```
...
dynamic ingress {
  for_each = var.ingress
  content {
    description = ingress.value["description"]
    from_port = ingress.key
    to_port = ingress.key
    protocol = "tcp"
    cidr_blocks = ingress.value["cidr_blocks"]
  }
}
...
```
## Provisioners

São formas de executar alguma coisa após a criação do Recurso, seja local, ou seja remoto.
Também tem uma opção de carregar um arquivo.

- file
- local-exec
- remote-exec

Exceto o file, os demais não são muito recomendados utilizarem.
É recomendado utilizar o user_data dos recursos (vm).


## Funções

Existe diversas funções no terraform, como calculos, letras tudo maiusculo, letras tudo minusculo, remover espaços, contagem, etc.
Melhor verificar a documentação caso haja necessidade.

## Console

Com o console é possivel testar as funções antes de aplicar um projeto por completo.
```
terraform console
```
Dentro, basta digitar o nome de uma variável ou a execução diretamente de uma função e será lhe exibido o resultado.

## Modulos

O modulo é uma forma de reaproveitar recursos, sem precisar ficar criando novos códigos.
Determinados recursos que são repetidamente utilizados, podem ser utilizados como módulos.

## Declarando um Modulo

Estrutura de pastas:
```
modules
modules/vpc-example
modules/vpc-example/main.tf
modules/vpc-example/outputs.tf
modules/vpc-example/variables.tf
```
Utilizando o modulo.
No main.tf principal.
```
module "vpc-example" {
  source = "./modules/vpc-example"
}
```
```
output "saida1" {
  value = module.vpc-example.ipv4
}
```

## Seu Modulo no Registry ou Github

Cadastro no Terraform Registry com Github
O repositório é apontado para o Github.
Deve ter uma nomenclatura de nomes: 
**terraform-<PROVIDER>-name**
**terraform-aws-vpcexample**

Precisa ter uma Release tag:
**v1.0.0**
**git tag v1.0.0**
**git push --tags**

Para utilizar no Projeto, a declaração fica assim:
```
module "vpc-example" {
  source = "nomedasuaconta/vpc/aws"
  version = "~>1.0.0"
}
```
É uma boa prática, incluir um README.md.

## Terraform state

```
Backend
```

O state é o "estado" do projeto. Quando é criado um projeto, o terraform cria um arquivo "terraform.tfstate", e este é utilizado para manipulação do projeto todo, como recriar, apagar, etc. É de extrema importância mante-lo.

A boa prática, recomenda que o "state" fique armazenado em outro local e não localmente. 
Formas alternativas de armazenar o state:

- S3 Amazon
- Blob Azure
- Local (compartilhado na rede)
- Postgresql
- Kubernetes

```
terraform {
  backend "local"
    path = "/nfs/xyz/projeto.tfstate"
}
```
```
terraform init -migrate-state
```
```
terraform {
  backend "local"
}
```
```
terraform init -migrate-state -backend-config="path=/nfs/xyz/projeto.tfstate"
```


### Comandos para visualização e manipulação do State

Mostrar todos os recursos criados no projeto.
```
terraform state list
terraform state lisst recurso.nome
terraform state list aws_subnet.subnet_public
```
Mostrar as propriedades de um recurso em especifico
```
terraform state show aws_subnet.subnet_public[0]
```
Mostrar todos os recursos e todas as suas propriedades
```
terraform show
terraform show --json
```

Forçar a recriação de um Recurso existente
```
terraform apply --replace="recurso.nome"
terraform apply --replace="aws_instance.virtual_machine[0]"
```
Renomear/Mover recursos.
Isto não altera o estado de um recurso, caso você esteja alterando o projeto.
```
terraform state mv "recurso.nome" "recurso.nome[0]"
terraform state mv "aws_instance.virtual_machine" "aws_instance.virtual_machine[0]"
```
Outro exemplo é se transformar os recursos em um Módulo.

Remover um recurso gerenciado pelo Terraform.
Ele permanecerá no Provider.
```
terraform state rm "recurso.nome"
terraform state rm "aws_instance.virtual_machine"
```

### Importar um recurso para que seja gerenciado pelo Terraform.

Para isto, é necessário executar alguns passos antes.
- Criar um datasource no projeto
```
data provider_recurso example {
  name = "nomeExatodoRecurso"
}
```
Em seguida aplicar.

- Verificar o estado do projeto para pegar informações do Recurso.
```
terraform state list
terraform state show "data.provider_recurso.example"
```
- Com as informações em mãos, será necessário remover o datasource e criar um recurso com os dados.\
Ter informações basicas do recurso em mãos. Ver pela documentação quais são obrigatórios.\
Anotar o ID exibido no state show.
```
resource provider_recurso example {
  name  = nomeExatodoRecurso
  image = xyz
  size  = klm
  infos adicionais
  ...
}
```
- Importar realmente o Resource
```
terraform import provider_recurso.example ID
```

## Lifecycle

Aplicado no Recurso. 
```
lifecycle {
  parametro = false/true
}
```

- Create before destroy

- Prevent Destroy

- Ignore Changes


## Workspace

Uma forma de reaproveitar projetos e códigos em diferentes ambientes (Dev, Homol, Produção, etc).

```
terraform workspace new homologacao
terraform workspace list
terraform workspace select producao
terraform workspace delete homologacao
```