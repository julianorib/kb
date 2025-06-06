# Assinando suas imagens Docker

A assinatura de imagens de container consiste em adicionar uma assinatura digital a uma imagem de container, usando uma chave privada, para garantir a autenticidade, a integridade e a proveniência da imagem.

A verificação de imagens de container consiste em validar a assinatura digital de uma imagem de container, usando uma chave pública, para confirmar que a imagem não foi alterada ou comprometida por um ataque de cadeia de suprimentos, que é uma tentativa de inserir código malicioso em um software durante o seu processo de desenvolvimento ou distribuição.

Para isso será utilizado o Cosign.

https://github.com/sigstore/cosign


## Instalar o Cosgin

```
curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"
sudo mv cosign-linux-amd64 /usr/local/bin/cosign
sudo chmod +x /usr/local/bin/cosign
```

## Criar par de chaves
```
cosign generate-key-pair
```
```
cosign.key
cosign.pub
```
## Fazer o build e Push de uma Imagem
```
docker build -t julianorib/imagemteste:v1.0 .
docker push julianorib/imagemteste:v1.0
```
## Assinar
```
cosign sign -key cosign.key julianorib/imagemteste:v1.0
```
## Validar assinatura
```
cosign verify --key cosign.pub julianorib/imagemteste:v1.0
```

## Kubernetes 

No kubernetes pode-se aceitar somente imagens assinadas.\
Ver como fazer.