# Amazon RDS

O Amazon Relational Database Service (Amazon RDS) é um serviço de banco de dados relacional de fácil gerenciamento e otimizado para o custo total de propriedade. É simples de configurar, operar e escalar de acordo com a demanda. O Amazon RDS automatiza as tarefas genéricas de gerenciamento de banco de dados, como provisionamento, configuração, backups e aplicação de patches. O Amazon RDS permite que os clientes criem bancos de dados em minutos e oferece flexibilidade para personalizá-los a fim de atender às suas necessidades em oito mecanismos e duas opções de implantação. Os clientes podem otimizar o desempenho com recursos, como multi-AZ com duas esperas legíveis, gravações e leituras otimizadas e instâncias baseadas no AWS Graviton3, e escolher entre várias opções de preços para gerenciar custos de forma eficaz.

## Ref:

<https://aws.amazon.com/pt/rds/>\
<https://aws.amazon.com/pt/rds/aurora/>\
<https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html>\
<https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraOverview.html>


O AWS RDS oferece várias opções de bancos de dados relacionais, incluindo:

1. **Amazon Aurora**: Banco de dados altamente disponível e escalável, compatível com MySQL e PostgreSQL.
2. **MySQL**: Banco de dados open-source amplamente utilizado, fácil de configurar e gerenciar.
3. **PostgreSQL**: Banco de dados open-source avançado, com recursos robustos de conformidade e desempenho.
4. **MariaDB**: Fork do MySQL, com melhorias de performance e novas funcionalidades.
5. **Oracle**: Banco de dados comercial com recursos empresariais avançados, incluindo suporte a licenciamento.
6. **SQL Server**: Banco de dados relacional da Microsoft, adequado para aplicações corporativas.

Cada opção oferece características de escalabilidade, segurança e backups automáticos.


### Aurora

O **Amazon Aurora** é um banco de dados relacional gerenciado da AWS, projetado para ser compatível com MySQL e PostgreSQL, mas oferecendo desempenho até 5 vezes superior ao MySQL e 2 vezes superior ao PostgreSQL. Ele combina a performance e a disponibilidade de bancos de dados comerciais com a simplicidade e custo reduzido dos bancos de dados open-source.

Aurora é altamente escalável, com replicação automática, backups contínuos e recuperação rápida. Ele também é projetado para ser altamente disponível, com armazenamento distribuído em várias zonas de disponibilidade (AZs) e suporta failover automático.

## Custo

<https://aws.amazon.com/pt/rds/pricing/>\
<https://aws.amazon.com/pt/rds/pricing/#Pricing_by_Amazon_RDS_engines>

## Engine

<https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html>

## Classes

- Serverless
- Memory-optimized
- Burstable-performance
- Optimized Reads

<https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.Types.html>\
<https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.Types.html>


## Engine x DB Instance Classes
<https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.SupportAurora.html>\
<https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.Support.html>


## Aurora Engine Version

<https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.VersionPolicy.html>

## Terraform

Criação de uma instância DB em Terraform [main.tf](main.tf)

#### Resource: aws_db_instance

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance>

### Aurora
#### Resource: aws_rds_cluster

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster>

#### Resource: aws_rds_cluster_instance

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance>
