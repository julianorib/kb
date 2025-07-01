# Amazon S3

## Ref:
<https://aws.amazon.com/pt/s3/>\
<https://docs.aws.amazon.com/pt_br/AmazonS3/latest/userguide/creating-buckets-s3.html>
<https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/create-bucket.html>
<https://docs.aws.amazon.com/pt_br/AmazonS3/latest/userguide/object-lifecycle-mgmt.html>

O Amazon Simple Storage Service (Amazon S3) é um serviço de armazenamento de objetos que oferece escalabilidade, disponibilidade de dados, segurança e performance líderes do setor. Clientes de todos os portes e setores podem armazenar e proteger qualquer quantidade de dados de praticamente qualquer caso de uso, como data lakes, aplicações nativas da nuvem e aplicações móveis. Com classes de armazenamento econômicas e recursos de gerenciamento fáceis de usar, você pode otimizar custos, organizar dados e configurar controles de acesso ajustados para atender a requisitos específicos de negócios, organizacionais e de conformidade.

## Custo
<https://aws.amazon.com/pt/s3/pricing/>

Você paga pelo armazenamento de objetos em buckets do S3. A taxa cobrada depende do tamanho do objeto, do tempo de armazenamento dos objetos durante o mês e da classe de armazenamento.

## Classes de Armazenamento:
<https://aws.amazon.com/pt/s3/storage-classes/>

| Classe | Uso |
|--------|-----|
| S3 Standard | Armazenamento de uso geral para dados acessados com frequência |
| S3 Intelligent-Tiering | Economia automática de custos para dados com padrões de acesso desconhecidos ou variáveis |
| S3 Express One Zone | Armazenamento de alta performance para seus dados acessados com mais frequência |
| S3 Standard-IA | Dados acessados com pouca frequência que precisam de acesso em milissegundos |
| S3 One Zone-IA* | Dados recriáveis acessados com pouca frequência |


### Amazon S3 Glacier
<https://aws.amazon.com/pt/s3/storage-classes/glacier/>

As classes de armazenamento do Amazon S3 Glacier são desenvolvidas especificamente para arquivamento de dados com a finalidade de oferecer a você a mais alta performance, a maior flexibilidade de recuperação e o armazenamento de arquivos de menor custo na nuvem. Todas as classes de armazenamento S3 Glacier fornecem escalabilidade virtualmente ilimitada e são projetadas para 99,999999999% (11 noves) de durabilidade de dados. As classes de armazenamento S3 Glacier oferecem opções para o acesso mais rápido aos seus dados de arquivo e o armazenamento de arquivo de menor custo na nuvem.

| Classe | Uso |
|--------|-----|
| S3 Glacier Instant Retrieval | Dados de longa duração que são acessados algumas vezes por ano com recuperações instantâneas |
| S3 Glacier Flexible Retrieval | Backup e arquivamento de dados que raramente são acessados e baixo custo |
| S3 Glacier Deep Archive | Arquivamento de dados que são raramente acessados e custo muito baixo |


## Visão geral

Quando você deseja utilizar o S3, você precisa criar um Bucket.\
Um Bucket é um container para objetos armazenados no Amazon S3.

O Amazon S3 oferece suporte a buckets globais, o que significa que cada nome de bucket deve ser exclusivo em todas as Contas da AWS de todas as Regiões da AWS dentro de uma partição. Uma partição é um agrupamento de regiões. Atualmente, a AWS tem três partições: aws (regiões padrão), aws-cn (regiões da China) e aws-us-gov (AWS GovCloud (US)).

Um Bucket pode ser Público ou Privado, mas tome cuidado em caso de um Bucket Público.

Para acessar um objeto em um Bucket público, se o objeto chamado photos/puppy.jpg estiver armazenado no bucket amzn-s3-demo-bucket da região Oeste dos EUA (Oregon), ele poderá ser endereçado usando o URL:

https://amzn-s3-demo-bucket.s3.us-west-2.amazonaws.com/photos/puppy.jpg.

Não há tamanho máximo para o bucket ou limite para o número de objetos que você pode armazenar em um bucket. Você pode armazenar todos os objetos em um único bucket, ou pode organizá-los em vários buckets. No entanto, você não pode criar um bucket de dentro de outro bucket.

Você pode versionar arquivos em um Bucket.

Por padrão, todos os Buckets são criados com:
- Classe de armazenamento "S3 Standard".
- Bloqueio de acesso público
- ACL desativadas
- Versionamento desativado


### Ciclo de vida 

O Ciclo de Vida do S3 ajuda você a armazenar objetos de forma econômica durante todo o respectivo ciclo de vida deles ao fazer a transição para classes de armazenamento de menor custo ou excluir objetos expirados em seu nome. Para gerenciar o ciclo de vida dos objetos, crie uma configuração do Ciclo de Vida do S3 para o bucket. Uma configuração do Amazon S3 Lifecycle é um conjunto de regras que define as ações aplicadas pelo Amazon S3 a um grupo de objetos.

## Buckets via AWS CLI

Primeiramente faça o login na sua conta com a Chave e Token de acesso.

```
export AWS_ACCESS_KEY=suachave
export AWS_SECRET_KEY=suasenha
```

### Listar Buckets

```
aws s3 ls
aws s3 ls nomedobucket
aws s3 ls nomedobucket/pasta/
```

### Criar um Bucket

```
aws s3 mb s3://bucket-example-xpto
```

### Enviar um arquivo para um Bucket

```
aws s3 cp camimnho/arquivo s3://bucket-example-xpto/
```

### Conceder acesso Publico-Leitura a um objeto
```
aws s3api put-object-acl --bucket bucket-example-xpto --key arquivo.txt --acl public-read
```
*Para conseguir executar essa opção, é necessário que o Bucket esteja com a opção "Bloquear todo o acesso público" desativada e as ACLs Habilitadas.*

### Concecer acesso Público temporariamente
```
aws s3 presign s3://bucket-example-xpto/arquivo.txt --expires-in 3600
```
*Será exibido um link para o arquivo. O Bucket não precisa ser público. O tempo é em segundos*

### Excluir um arquivo em um Bucket
```
aws s3 rm s3://bucket-example-xpto/arquivo.txt
```

### Excluir um Bucket
```
aws s3 rb s3://bucket-example-xpto/
aws s3 rb s3://bucket-example-xpto/ --force
```

## Terraform

Criação de um Bucket S3 em Terraform [main.tf](main.tf)


### Resource: aws_s3_bucket
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket>

### Resource: aws_s3_bucket_lifecycle_configuration
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration>

### Resource: aws_s3_bucket_ownership_controls
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls>

### Resource: aws_s3_bucket_public_access_block
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block>

### Resource: aws_s3_object
<https://registry.terraform.io/providers/-/aws/latest/docs/resources/s3_object>