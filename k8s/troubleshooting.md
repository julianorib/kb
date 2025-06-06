# Troubleshooting

Identificando erros comuns nos PODs.

```
CreateContainerConfigError
```
O kubernetes não consegiuu criar o container devido a um erro de configuração

```
InvalidImageName
```
O kubernetes não consegiu inspecionar a imagem para determinar se ela está configurada corretamente.

```
ErrImageNverPull
```
O kubernetes não conseguiu encontrar a Imagem especificada em um registro de containers e não tentará fazer download novamente.

```
ContainerCannotRun
```
O kubernetes não conseguiu executar o container por algum motivo.

```
CrashLoopBackOff
```
O container foi iniciado, mas parou de funcionar por algum motivo e o kubernetes está tentando reinicia-lo.

```
ImagePullBackOff
```
O kubernetes tentou fazer download da imagem especificada, mas falhou após várias tentativas.

```
OutOfMemory
```
O container ficou sem memória.


## Fluxo de análise POD

| Verificar | Get | Describe | Logs |
|-----------|-----|----------|------|
| Verificar status do POD     | kubectl get pods          | kubectl describe pod          | kubectl logs pod            |
| Verificar status do Deploy  | kubectl get deploy        | kubectl describe deploy       | kubectl logs deploy         |
| Verificar status do Service | kubectl get service       | kubectl describe service      | kubectl logs service        |
| Verificar Endpoints         | kubectl get endpoints     | kubectl describe endpoint     | kubectl logs endpoints      |
| Se tiver volumes            | kubectl get pv            | kubectl describe pv           | kubectl logs pv             |
| Se tiver volumes            | kubectl get pvc           | kubectl describe pvc          | kubectl logs pvc            |
| Ingress Controller          | kubectl get ingress       | kubectl describe ingress      | kubectl logs ingress        |
| Ingress Router              | kubectl get ingressroute  | kubectl describe ingressroute | kubectl logs ingressroute   |

Executando um container de testes:
```
kubectl run dodgyn --image=busybox --restart=Never --rm -it -- sh -c 'wget -qO- IP OU DNS:PORTA'
kubectl run dodgyn --image=busybox --restart=Never --rm -it -- nslookup <nomedoserviço>
```

Fazer um Port-Forward de testes:
```
kubectl port-forward pod-name 8080:<port-container>
```

## Fluxo de análise NODE

| Descrição | Verificar | Verificar |
|-----------|-----------|-----------|
| Componentes         | kubectl get componentstatuses     | kubectl get pods -n kube-system |
| Status Nodes        | kubectl get nodes                 | kubectl describe node           |
| Kubelet OK      ?   | systemctl status kubelet          |                                 |
| Kubelet com erro?   | journalctl -u kubelet -n 100      |                                 |


## Consultar recursos por Namespace
```
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get -n <NAMESPACE>
```

## Remover um namespace forçadamente
```
export NAMESPACE="monitoring"
```
```
kubectl get namespace $NAMESPACE -o json   | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/"   | kubectl replace --raw /api/v1/namespaces/$NAMESPACE/finalize -f -
```