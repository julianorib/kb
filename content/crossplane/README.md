# Crossplane

Crossplane é uma plataforma de controle declarativa que estende o Kubernetes para provisionar e gerenciar infraestrutura (AWS, Azure, GCP, etc.) usando YAML e CRDs, como se tudo fosse um recurso nativo do cluster.

## Ref:

<https://www.youtube.com/watch?v=Z9wXnpx9PHM>\
<https://docs.crossplane.io/latest/>
<https://docs.crossplane.io/latest/get-started/>

## Resumo

- Instalar o Crossplane via Helm no Cluster
- Criar o Provider + CRDs Recurso (azure, aws, gcp)
- Criar uma Secret para acesso ao Provider
- Criar um ProviderConfig relacionando a Secret
- Criar o recurso desejado na Cloud

