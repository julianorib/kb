# Kubernetes Cheat Sheet

### Quick Referente:
<https://kubernetes.io/docs/reference/kubectl/quick-reference/>\
<https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-strong-getting-started-strong->

### Completion
powershell
```
kubectl completion powershell | Out-String | Invoke-Expression
kubectl completion powershell  >> $PROFILE
```
bash:
```
kubectl completion bash > /etc/bash_completion.d/kubectl
```
zsh
```
kubectl completion zsh > "${fpath[1]}/_kubectl"
```


### Importar Config com Variável de Sistema:
```
$ENV:KUBECONFIG=("C:\Users\yourUser\.kube\config-other") 
export KUBECONFIG="${KUBECONFIG}:./config"
```

### Setar um Namespace padrão para um Contexto:
```
kubectl config set-context --current --namespace=xpto
```

### Verificar recursos gerais de um namespace
```
kubectl get all -n namespace
```

### Verificar recursos gerais de todos namespaces
```
kubectl get all -A
```

### Principais Recursos
| Descrição | get | describe | logs |
|-----------|-----|----------|------|
| Verificar Namespaces        | kubectl get namespace     | kubectl describe namespace    |             |
| Verificar status dos Nodes  | kubectl get nodes         | kubectl describe nodes        |             |
| Verificar status do POD     | kubectl get pods          | kubectl describe pod          | kubectl logs pod            |
| Verificar status do Replicaset  | kubectl get replicaset        | kubectl describe replicaset       | kubectl logs replicaset         |
| Verificar status do Deploy  | kubectl get deploy        | kubectl describe deploy       | kubectl logs deploy         |
| Verificar status do Service | kubectl get service       | kubectl describe service      | kubectl logs service        |
| Verificar Endpoints         | kubectl get endpoints     | kubectl describe endpoint     | kubectl logs endpoints      |
| Verificar volumes            | kubectl get pv            | kubectl describe pv           | kubectl logs pv             |
| Verificar volumes            | kubectl get pvc           | kubectl describe pvc          | kubectl logs pvc            |
| Ingress Controller          | kubectl get ingress       | kubectl describe ingress      | kubectl logs ingress        |
| Ingress Router              | kubectl get ingressroute  | kubectl describe ingressroute | kubectl logs ingressroute   |
| Config Maps (variáveis)     | kubectl get configmap     | kubectl describe configmap    |             |
| Secrets (variáveis sensiveis)| kubectl get secrets      | kubectl describe secrets      |             |

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

### Escalar um POD manualmente
```
kubectl scale --replicas=3 deployment/EXAMPLE
```

### Fazer um Port-Forward de testes:
```
kubectl port-forward pod-name 8080:<port-container>
```

### Executar um Pod com Shell interativo e depois remove-lo.
```
kubectl run --image=busybox --restart=Never --rm -it -- sh
```

### Erros mais comuns

| Erro | Descrição |
|------|-----------|
| CreateContainerConfigError | O kubernetes não consegiuu criar o container devido a um erro de configuração |
| InvalidImageName | O kubernetes não consegiu inspecionar a imagem para determinar se ela está configurada corretamente.
| ErrImageNverPull | O kubernetes não conseguiu encontrar a Imagem especificada em um registro de containers e não tentará fazer download novamente. |
| ContainerCannotRun | O kubernetes não conseguiu executar o container por algum motivo. |
| CrashLoopBackOff | O container foi iniciado, mas parou de funcionar por algum motivo e o kubernetes está tentando reinicia-lo. |
| ImagePullBackOff | O kubernetes tentou fazer download da imagem especificada, mas falhou após várias tentativas. |
| OutOfMemory | O container ficou sem memória. |

### Fluxo de análise NODE

| Item | Verificação | Verificação |
|------|-------------|-------------|
| Componentes         | kubectl get componentstatuses     | kubectl get pods -n kube-system |
| Status Nodes        | kubectl get nodes                 | kubectl describe node           |
| Kubelet OK      ?   | systemctl status kubelet          |                                 |
| Kubelet com erro?   | journalctl -u kubelet -n 100      |                                 |