# Kubernetes Cheat Sheet

Quick Referente:\
<https://kubernetes.io/docs/reference/kubectl/quick-reference/>\
<https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-strong-getting-started-strong->


### Importar Config com Variável de Sistema:
```
$ENV:KUBECONFIG=("C:\Users\yourUser\.kube\config-other") 
export KUBECONFIG="${KUBECONFIG}:./config"
```

### Setar um Namespace padrão para um Contexto:
```
kubectl config set-context --current --namespace=xpto
```

### Ver logs de um POD
```
kubectl logs -f my-pod -n namesXpto
```

### Interagir com um POD
```
kubectl exec my-pod -- sh
kubectl exec my-pod -- ls /
kubectl exec pod/my-pod -n namesXpto -- sh
```

### Fazer um Port-Forward de testes:
```
kubectl port-forward pod-name 8080:<port-container>
```

### Fluxo de análise POD
| Descrição | get | describe | logs |
|-----------|-----|----------|------|
| Verificar status do POD     | kubectl get pods          | kubectl describe pod          | kubectl logs pod            |
| Verificar status do Deploy  | kubectl get deploy        | kubectl describe deploy       | kubectl logs deploy         |
| Verificar status do Service | kubectl get service       | kubectl describe service      | kubectl logs service        |
| Verificar Endpoints         | kubectl get endpoints     | kubectl describe endpoint     | kubectl logs endpoints      |
| Se tiver volumes            | kubectl get pv            | kubectl describe pv           | kubectl logs pv             |
| Se tiver volumes            | kubectl get pvc           | kubectl describe pvc          | kubectl logs pvc            |
| Ingress Controller          | kubectl get ingress       | kubectl describe ingress      | kubectl logs ingress        |
| Ingress Router              | kubectl get ingressroute  | kubectl describe ingressroute | kubectl logs ingressroute   |