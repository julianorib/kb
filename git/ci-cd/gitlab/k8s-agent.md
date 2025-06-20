# Conectando um Cluster Kubernetes no GitLab

## Ref:
<https://docs.gitlab.com/18.0/user/clusters/agent/ci_cd_workflow/>

## Resumo

Uma forma de conectar o Gitlab a um ou vários cluster Kubernetes para fazer deploy de aplicações via CI/CD ou por GitOps.

Mais seguro do que criar uma SECRET com o Kubeconfig.

É possível utilizar um agente para todos os projetos ou para alguns projetos especificos.

## Instalar Agent

Para facilitar a organização, crie um novo projeto no GitLab com o nome `Agents`.\
Este projeto também pode ser utilizado para centralizar `Runners`.

- Acesse o menu do projeto `Operate` / `Kubernetes Clusters`.
- Clique em `Connect a cluster`.
- Opção 2: Create and register an agent with the UI.
- Defina um nome: Exemplo: `k8s-agent-homol`.
- Create and register.
- Será exibido algumas instruções do helm para aplicar no Cluster Kubernetes.

Exemplo:
```
helm repo add gitlab https://charts.gitlab.io
helm repo update
helm upgrade --install k8s-agent-homol gitlab/gitlab-agent \
    --namespace gitlab-agent-k8s-agent-homol \
    --create-namespace \
    --setokenxpto123 \
    --set config.token=tokenxpto123 \
    --set config.kasAddress=wss://gitlab.domain.com.br/-/kubernetes-agent/
```

## Configuração para usar Agent em todos os projetos

- Acesse a configuração de `Admin`, `Settings`, `General`.
- Procure por `GitLab Agent for Kubernetes`.
- Marque a opção `Enable instance level authorization` e salve.

- Crie um arquivo de configuração no projeto.
```
.gitlab/agents/k8s-agent-homol/config.yaml
```
Conteúdo:
```
ci_access:
  instance: {}
```

## Configuração para usar Agente em Projetos especificos

- Crie um arquivo de configuração no projeto.
```
.gitlab/agents/k8s-agent-homol/config.yaml
```
Conteúdo:
```
ci_access:
  projects:
    - id: path/to/project ## ex: grupo1/projeto1
    - id: path/to/project ## ex: grupo2/projeto2
```

## Validando

- Após realizar estas configurações, vá para outro projeto o qual compartilhou o agente.
- Acesse o menu do projeto `Operate` / `Kubernetes Clusters`. 

Deverá aparecer o `agente kubernetes` compartilhado.

## Como usar

- Em um projeto que tenha o acesso ao agente.
- Crie uma pipeline `.gitlab-ci.yml`.
Conteúdo para testar:
```
deploy:
  image:
    name: bitnami/kubectl:latest
    entrypoint: ['']
  script:
    - kubectl config get-contexts
    - kubectl config use-context grupo/projeto:k8s-agent-homol
    - kubectl get pods -n default
```

- Ao realizar o `commit`, será disparado a pipeline CI-CD.
- Acesse o menu do projeto `Build`, `Pipelines` e verifique se o `Job` ficou com status `Passed`.