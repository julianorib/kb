## Pares de Chave

<https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/ec2-key-pairs.html>

Um par de chaves, que consiste em uma chave pública e uma chave privada, trata-se de um conjunto de credenciais de segurança usadas para provar sua identidade ao se conectar a uma instância do Amazon EC2. Para instâncias do Linux, a chave privada permite usar o SSH com segurança en sua instância. Para instâncias do Windows, a chave privada é necessária para descriptografar a senha de administrador, que poderá então ser usada para se conectar à instância.


Para instâncias do Linux, quando a instância é inicializada pela primeira vez, a chave pública que você especificou na inicialização é colocada na instância do Linux em uma entrada dentro de ~/.ssh/authorized_keys. Ao conectar-se à instância do Linux usando SSH, especifique a chave privada que corresponde à chave pública para fazer login.


### Como criar uma Chave

<https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/create-key-pairs.html>


### Terraform

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair>