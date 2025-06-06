
## EBS - Elastic Block Store

<https://docs.aws.amazon.com/pt_br/ebs/latest/userguide/what-is-ebs.html>\
<https://docs.aws.amazon.com/pt_br/ebs/latest/userguide/ebs-volume-types.html>

O Amazon Elastic Block Store (Amazon EBS) fornece recursos de armazenamento em blocos escaláveis e de alto desempenho que podem ser usados com instâncias do Amazon EC2. 

Um volume do Amazon EBS é um dispositivo de armazenamento em blocos durável que é possível anexar às suas instâncias. Depois de anexar um volume a uma instância, será possível usá-lo como você usaria um disco rígido físico. Os volumes do EBS são flexíveis. Para volumes de geração atual anexados a tipos de instância de geração atual, é possível aumentar o tamanho dinamicamente, modificar a capacidade de IOPS provisionadas e alterar o tipo de volume em volumes de produção em tempo real.

É possível usar os volumes do EBS como armazenamento principal de dados que exigem atualizações frequentes, como o drive do sistema para uma instância ou armazenamento de uma aplicação de banco de dados. Também é possível usá-los para aplicações com muita throughput que executam verificações de disco contínuas. Os volumes do EBS persistem independentemente da vida útil de uma EC2 instância.

É possível anexar vários volumes do EBS a uma única instância. O volume e a instância devem estar na mesma zona de disponibilidade. Dependendo do volume e dos tipos de instância, você pode usar a opção Anexar várias para montar um volume em várias instâncias ao mesmo tempo.

O Amazon EBS fornece os seguintes tipos de volumes: SSD de uso geral (gp2 e gp3), SSD de IOPS provisionadas (io1 e io2), HDD otimizado para throughput (st1), HDD a frio (sc1) e Magnético (standard). Eles diferem em características de performance e preço, permitindo que você adapte a performance e custo de armazenamento às necessidades das aplicações.

### Preços

<https://aws.amazon.com/pt/ebs/pricing/>

### Criar um Volume

<https://docs.aws.amazon.com/pt_br/ebs/latest/userguide/ebs-volume-lifecycle.html>

Você pode criar um volume vazio ou criar um volume a partir de um snapshot do Amazon EBS. Se você criar um volume a partir de um snapshot, o volume começará como uma réplica exata do volume que foi usado para criar o snapshot.

<https://docs.aws.amazon.com/pt_br/ebs/latest/userguide/ebs-attaching-volume.html>\
<https://docs.aws.amazon.com/pt_br/ebs/latest/userguide/ebs-volumes-multi.html>


## Terraform
