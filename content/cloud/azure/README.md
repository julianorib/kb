# Azure Cloud Adoption Framework

<https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/>
<https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/>

## Landing Zone Architecture

![Architeture](alz-architecture-hub-spoke.svg)

![Application-Platform](alz-application-platform.svg)

## Pronto para aplicar

Utilize o modelo "Enterprise-Scale Landing Zone" em versão lite.

### Componentes mímimos

| Componente | Função |
|---|---|
| Subscription separada | Separar Dev/ Prod/ Identidade / Gerenciamento / Conectividade |
| Resource Groups organizados | Agrupar Recursos por função |
| VNET e Subnets | Subnets por Ambientes |
| Azure Bastion ou Jumpbox | Acesso seguro |
| NSG / Firewall | Controle de Tráfego |
| Monitoramento | Coleta de Métricas e Logs |
| Azure Policy + RBAC | Governança e controle de acesso |
| Cost Management + Budgets Alerts | Acompanhar e controlar os custos |