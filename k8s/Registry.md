# Registry Privado

Se houver um registry privado, que não tem conexão HTTPS, será necessário fazer uma configuração em todos os nodes (workers) do Kubernetes. Esta configuração é feita no Containerd.

Acesse cada Node (host) e edite o arquivo:
```
/etc/containerd/config.toml
```

Procurar a seção: 
```
[plugins."io.containerd.grpc.v1.cri".registry]
```
Modificar a registry.configs e registry.mirrors para que fique da seguinte forma:
```
      [plugins."io.containerd.grpc.v1.cri".registry.configs]
          [plugins."io.containerd.grpc.v1.cri".registry.configs."registry.v2.unicoob.local.tls"]
            insecure_skip_verify = true

      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."registry.v2.unicoob.local"]
          endpoint = ["http://registry.v2.unicoob.local"]
```

Por fim, Criar uma secret com usuário e senha no Kubernetes
```
kubectl create secret docker-registry CONTA-SECRET --docker-server=SERVIDOR --docker-username=USERNAME --docker-password=PASSWORD
```