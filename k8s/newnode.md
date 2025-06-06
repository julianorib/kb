# New Node (worker)

Tenha instalado os componentes do Kubernetes (mesma versão) e Containerd, mais suas configurações.

Verificar se existe um token.
```
kubeadm token list
```
Se existir, remova-o.
```
kubeadm token delete <xyz>
```

Crie um novo Token:
```
kubeadm token create --print-join-command
```

Copie a linha de join e execute no novo Node.
```
kubeadm join kubernetes.dev.unicoob.local:6443 --token 2t33fb.n7quoe0hrfvq6v8o --discovery-token-ca-cert-hash sha256:9893deeee39e451c02181b5e62be381f381fbe0b27bf5e71f2476ee82f31eb9b
```

