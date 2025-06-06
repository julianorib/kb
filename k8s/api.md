# Kubernetes API 

## Reference:
<https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/>

<https://www.youtube.com/watch?v=_65Md2qar14>

## Versão do Kubernetes
```
curl https://localhost:6443/version -k
```

## Visualizando a API:
As APIs disponíveis poderão ser visualizadas com o comando abaixo, porém necessita de autenticação.
```
curl https://localhost:6443/ -k
curl https://localhost:6443/ -k --key admin.key --cert admin.crt --cacert ca.crt
```

## Core Group x Named Groups

### Core Group

Nodes, Namespace, Pods, Services, 

https://localhost:6443/api/v1/
https://localhost:6443/api/v1/namespaces/
https://localhost:6443/api/v1/namespaces/default/pods

### Named Groups

Replicaset, Deployments, Statefullset, Daemonsets

https://localhost:6443/apis/apps/v1/
https://localhost:6443/apis/apps/v1/deployments


## Visualizando a API com TOKEN dentro de um POD:
```
kubectl create serviceaccount xpto -n temp
kubectl create role xpto --resource pod --verb list -n temp
kubectl create rolebinding xpto --role xpto --serviceaccount temp:xpto -n xpto
kubectl create token xpto -n temp
```
```
TOKEN="<token-gerado>"
curl https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}/api/ -k -H "Authorization: Bearer $TOKEN"
```

:OU:

Caminho do Token: /var/run/secrets/kubernetes.io/serviceaccount/token
```
TOKEN=$(cat token)

curl https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}/api/ -k -H "Authorization: Bearer $TOKEN"
```
*Este usuário não terá permissões adicionais no cluster.*

## Acessando a API através de um proxy do kubeconfig
```
kubectl proxy
```
```
curl http://localhost:8001
```
## Visualizar a versão Preferida de uma API:
```
curl https://localhost:6443/apis/authorization.k8s.io -k
```
## Habilitar uma versão alpha de uma API:

Editar o arquivo de manifesto do kube-apiserver.yaml.

Incluir a flag: --runtime-config
```
- --runtime-config=rbac.authorization.k8s.io/v1alpha1
```
