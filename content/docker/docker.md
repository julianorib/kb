# Docker Cheat Sheet

### Quick Referente:

<https://docs.docker.com/get-started/docker_cheatsheet.pdf>

### Completion
bash:
```
docker completion bash > /etc/bash_completion.d/docker
```
zsh
```
docker completion zsh > "${fpath[1]}/_docker"
```

### Containers

| Comando      |  Descrição |
|--------------|------------|
| docker ps    |   ver containers ativos |
| docker ps -a |   ver todos containers |
| docker run -d -p port:port imagem | executar um container |
| docker exec -it containerId (sh bash ash) | acessar um container |
| docker logs -f containerId | ver os logs de um container |
| docker inspect containerId | ver detalhess de um container |
| docker stats | ver recursos em uso dos containers | 
| docker stop containerId | parar um container |
| docker start containerId | iniciar um container |
| docker rm containerId | apagar um container | 
| docker rm -f containerId | apagar um container forçadamente |
| docker container prune | limpar containers inativos |

### Imagens

| Comando      |  Descrição |
|--------------|------------|
| docker build -t user/imagem:v1.0 . | criar uma imagem |
| docker build -t user/imagem:v1.0 . -f DockerfileExample | criar uma imagem com um Dockerfile diferente | 
| docker image ls | ver as imagens baixadas | 
| docker image rm imagem | apagar uma imagem | 
| docker image rm -f imagem | apagar uma imagem forçadamente |
| docker image prune | limpar imagens inativas | 

### Repositório

| Comando      |  Descrição |
|--------------|------------|
| docker login | fazer login no Registry Docker Hub | 
| docker login registry.xpto.com | fazer login no Registry Especifico | 
| docker push user/imagem:v1.0 | Subir uma imagem para o Registry |
| docker tag user/imagem:v1.0 user/imagem:latest | Tagear uma imagem como latest |
| docker push user/imagem:latest | Subir a imagem latest para o Registry |


### Manutenção

| Comando      |  Descrição |
|--------------|------------|
| docker system df | Visualizar espaços utilizados |
| docker system df -v | Visualizar espaços utilizados |
| docker container prune | Limpeza de containers não utilizados |
| docker image prune | Limpeza de imagens não utilizadas |
| docker volume prune | Limpeza de volumes não utilizados | 
| docker system prune -a | Limpeza de objetos não utilizados |
| docker system prune -a --volumes -f | Limpeza completa forçada |