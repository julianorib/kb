# AWS Identity and Access Management (IAM)

## Ref:
<https://aws.amazon.com/pt/iam/>\
<https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/introduction.html>
<https://www.youtube.com/watch?v=spUlvo0HNFQ>\
<https://www.youtube.com/watch?v=RY6CFCOZekM&pp=ygUHYXdzIGlhbQ%3D%3D>


Com o AWS Identity and Access Management (IAM), é possível especificar quem pode acessar quais serviços e recursos da AWS e em que condições. O IAM é um recurso de sua conta da AWS disponibilizado gratuitamente. Para começar a usar o IAM, ou caso você já esteja registrado na AWS.

## Custo

O AWS Identity and Access Management (IAM), o AWS IAM Identity Center e o AWS Security Token Service (AWS STS) são recursos da conta da AWS oferecidos sem custo adicional. 

## Componentes

- Usuários
- Grupos
- Funções (Roles)
- Politicas (Policy)

### Usuários

São indivíduos ou aplicativos que precisam de acesso aos seus recursos do AWS. Cada usuário recebe credenciais exclusivas, como senhas e chaves de acesso.

#### Access Token

Use chaves de acesso para fazer chamadas programáticas para a AWS da AWS CLI, do AWS Tools for PowerShell, de SDKs da AWS ou de chamadas de API diretas da AWS. Você pode ter no máximo duas chaves de acesso (ativas ou inativas) por vez.

Estas chaves são criadas no usuário na sessão **Credenciais de segurança** ou **Access Token**.

Para utiliza-lás depois, basta exportar como variável de ambiente:

```
export AWS_ACCESS_KEY suachave
export AWS_SECRET_KEY suasenha
```

### Grupos

São coleções de usuários. Em vez de atribuir permissões a cada usuário individualmente, você pode colocar os usuários em grupos e atribuir permissões ao grupo. Isso facilita o gerenciamento de permissões para vários usuários ao mesmo tempo.

### Funções (Roles)

As funções do IAM ajudam você a gerenciar as permissões dos seus serviços e aplicativos. 

Ao contrário dos usuários de IAM, que são associados a uma pessoa específica, as funções são projetadas para serem assumidas por qualquer pessoa que precise delas, o que as torna incrivelmente flexíveis.

Considere uma função como um conjunto de permissões que podem ser atribuídas temporariamente a entidades como serviços do AWS (por exemplo, EC2, Lambda) ou até mesmo a usuários de outra conta do AWS. Isso é ótimo para a segurança porque as funções usam credenciais temporárias que expiram automaticamente.

#### Entidade Confiável

Define quem pode assumir a função. Por exemplo, você pode criar uma política de confiança que permita que uma instância instância do EC2 ou um AWS Lambda assuma a função. Essa política especifica as entidades confiáveis (como serviços ou usuários) que podem usar a função.

Uma entidade deve assumir uma função para usá-la. Quando uma instância do EC2 ou função Lambda assume uma função, ela obtém credenciais de segurança temporárias que podem ser usadas para fazer solicitações aos serviços do AWS.


#### Politica de Permissões

Definem quais ações são permitidas ou negadas quando a função é assumida. Elas funcionam exatamente como as políticas que você anexa aos usuários do IAM, especificando quais recursos a função pode acessar e quais ações pode executar.

Algumas Entidades requerem uma Politica, enquanto outras não.

##### Aqui está um exemplo simples: 
Suponha que você tenha um aplicativo em execução em uma instância do EC2 que precisa ler de um bucket do S3. Em vez de armazenar chaves de acesso na instância, você pode criar uma função IAM e Adicionar uma política que permita a leitura do S3. Em seguida, você anexa essa função à sua instância do EC2. Quando a instância é executada, ela assume a função e obtém credenciais temporárias para acessar o bucket S3.

As credenciais temporárias são fornecidas à instância por meio do Serviço de token de segurança da AWS (STS) DA AWS. Essas credenciais incluem um ID de chave de acesso, uma chave de acesso secreta e um token de sessão, e são válidas por um curto período, normalmente algumas horas.

O uso de funções também facilita o gerenciamento de permissões, pois você pode atualizar as políticas da função em um único local, o que se aplica automaticamente a todas as entidades que assumem a função.


### Politicas

<https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/access_policies.html>

São documentos JSON que definem permissões. Eles especificam quais ações são permitidas ou negadas em quais recursos. As políticas podem ser anexadas a usuários, grupos ou funções.

```
​​{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
```

- Version: especifica a versão do idioma da política.
- Statement: é onde está a "carne" da apólice. Uma única apólice pode ter várias declarações. Cada declaração inclui alguns campos essenciais:
- - Effect: Esse campo especifica se a declaração permite ou nega o acesso. Você pode escolher entre "Permitir" ou "Negar".
- - Action: Isso define quais ações são permitidas ou negadas. As ações geralmente são as operações que você pode executar em um recurso. O AWS tem ações específicas para cada serviço, portanto, você deve especificá-las corretamente.
- - Resource: Isso especifica os recursos do AWS aos quais as ações se aplicam. Os recursos são identificados usando Nomes de recursos da Amazon (ARNs), que identificam um recurso de forma exclusiva.
 

#### Tipos de Politica

As **políticas gerenciadas** pela AWS são criadas e mantidas pela AWS, o que as torna um excelente ponto de partida para os conjuntos de permissões comumente usados. As políticas gerenciadas pelo cliente são aquelas que você mesmo cria e gerencia, o que lhe dá mais flexibilidade para escrever documentos JSON personalizados.

<https://docs.aws.amazon.com/pt_br/aws-managed-policy/latest/reference/policy-list.html>

As **políticas inline**, por outro lado, são diretamente associadas a um único usuário, grupo ou função. Elas são úteis para permissões específicas e rigidamente controladas que não devem ser reutilizadas. No entanto, o gerenciamento de políticas em linha pode se tornar complicado à medida que elas aumentam em número, por isso elas são geralmente menos preferidas do que as políticas gerenciadas.


#### Gerador de Politica

<https://awspolicygen.s3.amazonaws.com/policygen.html>



## Terraform

Criação de uma Role, Associação de uma Politica e Criação de Uma Politica Inline em Terraform [main.tf](main.tf)


#### Resource: aws_iam_role
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role>

Cria uma Role e associa uma entidade confiável.

#### Resource: aws_iam_role_policy_attachment
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment>

Associa uma ou mais Politicas Gerenciada a uma Role.

#### Resource: aws_iam_role_policy
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy>

Cria uma ou mais Politica Inline especificas e associa a uma Role.

