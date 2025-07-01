## Imagens

<https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/AMIs.html>

Uma Imagem de máquina da Amazon (AMI) é uma imagem que fornece o software necessário para configurar e inicializar uma instância do Amazon EC2. Cada AMI também contém um mapeamento de dispositivos de blocos que especifica os dispositivos de blocos a serem anexados às instâncias que você executa. Especifique uma AMI ao iniciar uma instância. Essa AMI deve ser compatível com o tipo de instância que você escolhe para a sua instância. Você pode usar uma AMI fornecida pela AWS, uma AMI pública, uma AMI que alguém compartilhou com você ou uma AMI que você comprou no AWS Marketplace.

Uma AMI é específica para o seguinte:

- Região
- Sistema operacional
- Arquitetura do processador
- Tipo de dispositivo raiz
- Tipo de virtualização

É possível iniciar várias instâncias em uma única AMI quando precisar de várias instâncias com a mesma configuração. Você pode usar AMIs diferentes para executar instâncias quando precisar de instâncias com configurações diferentes

### Encontrar uma AMI:
<https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/finding-an-ami.html>

```
aws ec2 describe-images --owners amazon
```
```
--filters "Name=platform,Values=windows"
```

### Criar uma AMI

<https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/ami-lifecycle.html>

Comece com uma AMI existente, inicie uma instância, personalize-a, crie uma nova AMI a partir dela e, por fim, inicie uma instância de sua nova AMI.

## Terraform