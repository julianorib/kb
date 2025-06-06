# Docker Swarm

Para um Cluster Swarm estar funcionando, precisa de 51% dos Manager funcionaando.
O ideal é ter um número Impar de Manager, ou seja: 3, 5, 7.

- Manager
- Worker

## Iniciar um Cluster:
```
docker swarm init
```

Será exibido instrucoes para entrar com outro Manager ou entrar com os Workers.
Ou digitar:
```
docker swarm join-token worker
docker swarm join-token manager
```
```
docker swarm join-token  --rotate worker
docker swarm join-token  --rotate manager
```

*Observação: Se tiver utilizando AWS ou Azure tem que liberar Portas. 2377 é um exemplo.*

```
docker node ls
```

Para promover a Manager:
```
docker node promote hostname
```

Despromover Manager e virar Worker:
```
docker node demote hostname
```

Atualizar um NODE para não receber mais Containers ou para entrar em Manutenção.
```
docker node update --availability pause hostname
docker node update --availability active hostname
docker node update --availability drain hostname
```

## Services

O Services é uma maneira de ter ESCALABILIDADE e RESILIÊNCIA dos Containers.
Ele mantem quantidades X de conteiners do mesmo APP ou "SERVIÇO".
Ele distribui os containers nos NODES (workers) do Cluster.
Faz tambem um Balanceamento de Carga.  Responde por qualquer IP/Porta do Cluster.
Todos os NODES conhecem todos os serviços, mesmo que não esteja hospedando o serviço/container.

Type Replica;
Replica - (repplicate) sobe quantos você setar  expalhados nos Hosts.
Global (global) sobe 1 em cada Host.

Ajuda:
```
docker service --help
```

Ver serviços:
```
docker service ls
```

Criar e Escalar serviço:
```
docker service create --name webserver --replicas 3 -p 8080:80 nginx
docker service ps webserver
docker service scale webserver=10
```

Ver informações detalhadas do serviço.
```
docker service inspect webserver --pretty
```

Ver logs de todo o serviço:
```
docker service logs -f webserver
```

Update Service:
```
docker service update --network-add  
docker service update --publish-add (porta)
```
Parametros:
--limit-memory
--limit-cpu
entre outros


### Volumes:

Listar os Volumes:
```
docker volume ls
```

Criar um Volume:
```
docker volume create webserver
	/var/lib/docker/volumes/webserver/_data/
```

Criar um Serviço com um Volume:
```
docker service create --name webserver --replicas 3 -p 8080:80 --mount type=volume,src=webserver,dst=/usr/share/nginx/html nginx
```
*Observação: Não compartilha o volume entre os NODES.*
<br>
*Teria que ser feito via compartilhamento ou ter algum Plugin.*


### Network
Para um Serviço comunicar com Outro.
Não precisa usar IP, somente o Nome do Serviço.

```
docker network ls
docker network create -d overlay webserver
```
```
docker service create --name webserver -p 8080:80 --network webserver nginx
```
```
docker network inspect --pretty
```

### Docker Stack
Basicamente é para juntar tudo. Fazer Deploy em cima de um Compose File.
O conteudo do compose será os Serviços que serão criados e suas configurações.

```
docker stack deploy --compose-file docker-compose.yml  nomeSTACK
docker stack ps nomeSTACK
docker stack ls
```
