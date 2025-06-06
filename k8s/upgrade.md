<https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/>

- Atualize um nó do ControlPlane.
- Atualize nós adicionais do ControlPlane
- Atualize os nós de Trabalho (workers)

*Observações:*\
**Os certificados de serviços (APISERVER, ETC, CONTROLLER-MANAGER, KUBELET, ETC) são renovados automaticamente no Upgrade de versão.**

**Não há tempo de inatividade dos Workloads.**

## Upgrade Nodes (ControlPlane)
Acesse via SSH um dos Nós Control Plane.
### Upgrade kubeadm

#### Ajustar os repositórios

Verificar qual repositório está habilitado.\
Há repositórios por versão (1.28, 1.29, 1.30, 1.31, etc).
```
/etc/yum.repos.d/kubernetes.repo
```
```
yum list --showduplicates kubeadm --disableexcludes=kubernetes
```
**replace x in 1.28.x-* with the latest patch version**
```
yum install -y kubeadm-'1.28.x-*' --disableexcludes=kubernetes
```

#### Plan the upgrade
```
kubeadm upgrade plan
```

#### Upgrade the node
*replace x with the patch version you picked for this upgrade*
```
kubeadm upgrade apply v1.28.x
```

Aguardar a mensagem:
```
[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.28.x". Enjoy!
[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.
```

#### Upgrade demais nodes Control Plane
Acessar outros Nós Control Planes via ssh.
```
kubeadm upgrade node
```

### Upgrade kubelet & kubectl

#### Drain the node 
Prepare o nó para manutenção, marcando-o como não programável e removendo as cargas de trabalho:

*replace <node-to-drain> with the name of your node you are draining*
```
kubectl drain <node-to-drain> --ignore-daemonsets
```

#### Ajustar os repositórios

Acesse um a um os demais Control Plane.

Verificar qual repositório está habilitado.\
Há repositórios por versão (1.28, 1.29, 1.30, 1.31, etc).
```
/etc/yum.repos.d/kubernetes.repo
```


```
yum list --showduplicates kubeadm --disableexcludes=kubernetes
```

*replace x in 1.28.x-* with the latest patch version*
```
yum install -y kubelet-'1.28.x-*' kubectl-'1.28.x-*' --disableexcludes=kubernetes
```

#### Restart the kubelet 
```
systemctl daemon-reload
systemctl restart kubelet
```

#### Undrain the node 

*replace <node-to-uncordon> with the name of your node*
```
kubectl uncordon <node-to-uncordon>
```

## Upgrade Nodes (Worker)

O procedimento de atualização em nós de trabalho deve ser executado um nó de cada vez ou alguns nós de cada vez, sem comprometer a capacidade mínima necessária para executar suas cargas de trabalho.

### Upgrade kubeadm

Acesse um Worker de cada vez via SSH

```
kubeadm upgrade node
```

### Upgrade kubelet & kubectl

#### Drain the node 
Prepare o nó para manutenção, marcando-o como não programável e removendo as cargas de trabalho:

*replace <node-to-drain> with the name of your node you are draining*
```
kubectl drain <node-to-drain> --ignore-daemonsets
```
#### Ajustar os repositórios

Verificar qual repositório está habilitado.\
Há repositórios por versão (1.28, 1.29, 1.30, 1.31, etc).

```
yum list --showduplicates kubelet --disableexcludes=kubernetes
```
*replace x in 1.28.x-* with the latest patch version*
```
yum install -y kubelet-'1.28.x-*' kubectl-'1.28.x-*' --disableexcludes=kubernetes
```

#### Restart the kubelet 
```
systemctl daemon-reload
systemctl restart kubelet
```

#### Undrain the node 

*replace <node-to-uncordon> with the name of your node*
```
kubectl uncordon <node-to-uncordon>
```

### Validando
```
kubectl get nodes
```

```
kubectl get pods -o wide
```