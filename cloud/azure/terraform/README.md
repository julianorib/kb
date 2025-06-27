# Projeto simples Azure + Terraform

Este projeto cria uma infraestrutura no Azure contendo:
- VNET
- Subnets
- NAT Gateway
- IP público
- VMSS (Virtual Machine Scale Set) Linux com Nginx
- VM Linux
- Load Balancer
- Storage Account com Share
- Banco de dados MySQL


## Começar

```
az login
```

```
export ARM_SUBSCRIPTION_ID=suaSubscription
```

```
tofu init
tofu validate
tofu apply
```