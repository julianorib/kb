# Resolução de Problemas


## Swarm - Node unhealth

Quando um Node não funciona mais no Cluster.\
As vezes acontece após atualização do Docker.

- Acessar Manager.Ver nodes:
```
docker node ls
```

- Gerar um novo Token para inserir Node:
```
docker swarm join-token worker
```

Será exibido algo como: \
`docker swarm join --token <tokentokentokentokentokentoken> 192.168.5.5:2377`\
Copiar  este texto.

- Acessar o Node:
- Remover o Node do Cluster:
```
docker swarm leave
```
- Adicionar novamente:
```
docker swarm join --token <tokentokentokentokentokentoken> 192.168.5.5:2377
```