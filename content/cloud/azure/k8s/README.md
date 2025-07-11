# Azure Kubernetes Services (AKS)

## Ref:

<https://azure.microsoft.com/pt-br/products/kubernetes-service>\
<https://learn.microsoft.com/pt-br/azure/aks/what-is-aks>\
<https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks/baseline-aks>


## Network Topology

![Network-Topology](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks/images/aks-baseline-architecture.svg)

## Pricing

<https://azure.microsoft.com/pt-br/pricing/details/kubernetes-service/>

## azcli

### Criar um Cluster Kubernetes simples via azcli:

<https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli>


```
az group create --name rg --location eastus
```

```
az aks create --resource-group rg --name meucluster --node-count 2 --generate-ssh-keys
```

```
az aks get-credentials --resource-group rg --name meucluster
```

```
kubectl get nodes
```

### Criar um Cluster Kubernetes avançado via azcli:

```
az group create --name rg --location eastus
```
```
az aks create \
  --resource-group rg \
  --name meu-cluster \
  --kubernetes-version 1.29.2 \
  --node-vm-size Standard_DS2_v2 \
  --node-count 2 \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 3 \
  --enable-addons monitoring \
  --enable-managed-identity \
  --generate-ssh-keys \
  --network-plugin azure
```
```
az aks get-credentials --resource-group rg --name meucluster
```

```
kubectl get nodes
```

### Apagar o cluster

```
az aks delete --name my-cluster --resource-group rg
```

## Terraform

<https://developer.hashicorp.com/terraform/tutorials/kubernetes/aks>

#### Componentes:
- ResourceGroup
- VNET
- Subnet
- VMSS DS2_v2
- NSG
- Identity
- Public IP
- Load balancer
