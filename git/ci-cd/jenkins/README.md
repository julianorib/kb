# Jenkins - CI CD

https://www.jenkins.io/

Jenkins é um sistema de servidor de automação de código aberto, com integração e entrega contínuas, que permite a criar, testar e implementar softwares, tornando, assim, o processo de desenvolvimento mais ágil e eficiente.


## Requisitos

- Instalar o Docker 


## Instalação Jenkins

https://www.jenkins.io/doc/book/installing/linux/

Neste cenário, será instalado um Servidor Virtual com Linux e o Jenkins (Não Containerizado).
Dessa forma, ele fica independente de Docker ou Kubernetes e pode implantar CI/CD em diversos ambientes.


sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo yum install java-17-openjdk
sudo yum install jenkins
sudo systemctl daemon-reload

usermod -aG docker jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins



Browse to http://localhost:8080 



## Instalação Plugins

Procure pelos seguintes Plugins

- Docker
- Docker pipeline
- Kubernetes
- Kubernetes cli


## Credênciais

- Docker Hub

Para fazer o Build de imagens.

Gerenciar Jenkins, Manage Credentials
Type, Username with password.

- Kubernetes

Para fazer o Deploy de containers.

Gerenciar Jenkins, Manage Credentials
Type, Secret File.
Escolher o arquivo config do Kubernetes


## Conectando ao Cluster Kubernetes

*verificar, pois parece obsoleto isto.*\
*criei a pipeline sem usar nada.*

Gerenciar Jenkins, Configurar Segurança Global
Agents, Porta Randomica

Gerenciar Jenkins, Configurações Globais
```
Cloud.
    Definir o nome (PROD, HOMOL, etc).
    Tipo, Kubernetes.
    Expandir o Kubernetes Cloud Tetails.
        Escolher a Credencial. Testar.
        URL Jenkins, informar a URL.
        POD Labels, Add 
        POD Labels  -> key=jenkins value=slave
        POD Retention -> On Failure
        POD Template, Add
        POD Template, Name=pod-template
        POD Template -> Containers, Add.
        POD Template -> Containers - Name=jnlp Image=jenkins/jnlp-slave:latest
        POD Template -> Containers -> Retention=On Failure
```