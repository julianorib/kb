## Week 1 - Introdução ao Git e GitHub

- Git: Sistema de controle de versão distribuído que rastreia mudanças no código.
- GitHub Entities: Componentes como repositórios, branches, commits e PRs.
- GitHub Markdown: Linguagem de marcação usada para formatar texto em GitHub (README, Issues).
- GitHub Desktop/Mobile: Aplicativos para gerenciar repositórios localmente ou em dispositivos móveis.
- Diferença entre Git e GitHub: Git é a ferramenta de versionamento; GitHub é a plataforma de hospedagem e colaboração.
- Repositório GitHub: Local onde o código e o histórico de versões são armazenados.
- Commit: Salva mudanças no código, criando um ponto no histórico de versões.
- Branching: Criar uma linha de desenvolvimento independente de código.

## Week 2 - Trabalhando com Repositórios GitHub

- Gerenciamento de repositório: Configurar e gerenciar repositórios (permissões, colaboradores).
- Criar um novo repositório: Iniciar um novo projeto no GitHub.
- Templates de repositório: Modelos predefinidos para criar repositórios com configuração inicial.
- Clonar um repositório: Baixar uma cópia local de um repositório remoto.
- Criar um novo branch: Iniciar uma nova linha de desenvolvimento paralela.
- Adicionar arquivos ao repositório: Subir novos arquivos ou modificar existentes.
- Ver insights do repositório: Estatísticas sobre contribuições e atividades (Graphs: current e historical)
- Feature previews: Recursos em fase de teste no GitHub.

## Week 3 - Recursos de Colaboração
- Issues: Ferramenta de acompanhamento de bugs, tarefas e discussões.
- Pull Requests (PRs): Solicitações para fundir alterações de código.\
keywords to link: fix, close, resolve.
- Discussões: Espaço para conversas públicas sobre o projeto.
- Notificações: Alertas sobre atividades relevantes no repositório.
- Gists: Permite compartilhar pequenos trechos de código ou arquivos. Útil para armazenar ou compartilhar scripts, notas ou exemplos de código.
- Pages: Serviço de hospedagem de sites estáticos diretamente de repositórios do GitHub. Ideal para portfólios, blogs ou documentações
- Wikis: Documentação
- Markdown Features: Usar Markdown para formatar conteúdo.
- Linkar PR a um Issue: Conectar PR a um Issue para rastreamento de progresso.
- Atribuir Issues: Designar responsáveis por tarefas ou bugs.
- Milestones:  Usados para agrupar issues e pull requests em etapas maiores de desenvolvimento, ajudando a acompanhar o progresso de um projeto ao longo do tempo.
- Draft PR: PRs ainda em fase de revisão inicial.
- Pulse: inclui uma lista de solicitações pull abertas e mescladas, problemas abertos e fechados e um gráfico mostrando a atividade de confirmação para os 15 principais usuários que se comprometeram com a ramificação padrão do projeto no período de tempo selecionado.

## Week 4 - Desenvolvimento Moderno
- GitHub Actions: Automação de fluxos de trabalho (CI/CD).
- GitHub Copilot: Assistente de codificação que sugere linhas de código.
- GitHub Codespaces: Um ambiente de desenvolvimento na nuvem que permite programar diretamente no navegador ou em um editor compatível, como VSCode.
- GitHub.dev: Um ambiente de edição de código online que pode ser acessado diretamente no navegador, útil para edições rápidas em repositórios.
- Github Flow: é um fluxo de trabalho leve e simples para gerenciar projetos. Se baseia em 6 etapas: (Criar uma branch, Fazer Commits, Abrir um pull request, Revisão e Feedback, Fazer Merge, Deploy).

## Week 5 - Gerenciamento de Projetos
- GitHub Projects: Ferramenta de gerenciamento de projetos dentro do GitHub, integrando repositórios e issues com quadros kanban e outras funcionalidades de organização.
- Builtin Workflows: Auto-archive items, Code changes requested, Item reopened, Pull request merget

## Week 6 - Privacidade, Segurança e Administração
- CodeQL: Linguagem e cadeia de ferramentas para análise de código e verificações de segurança.
- 2FA (Autenticação de Dois Fatores): Proteção extra para contas GitHub.
- EMUs (Enterprise Managed Users): Contas gerenciadas centralmente por empresas.
- Personal Access Token: Para acesso em API e HTTPS sem utilizar usuário e senha. Também pode ser usado com Git CLI.
- Alertas Dependabot: Informam que o código depende de um pacote que não é seguro. Muitas vezes, o software é desenvolvido usando pacotes de código aberto de uma grande variedade de origens. As relações complexas entre essas dependências e a facilidade com que agentes mal-intencionados podem inserir malware no código upstream significam que você pode, inadvertidamente, estar usando dependências que têm falhas de segurança, também conhecidas como vulnerabilidades.

## Week 7 - Benefícios da Comunidade GitHub
- Open Source: Software com código-fonte aberto e colaborativo.
- InnerSource: Aplicação de práticas open source dentro de empresas.
- GitHub Sponsors: Recurso para apoiar financeiramente desenvolvedores open source.

## Notificações:
Notificações no Github Mobile:
- Comentários sobre problemas e solicitações de pull
- Revisões de pull request
- Pushes da solicitação de pull.
- Suas próprias atualizações, por exemplo quando você abre, comenta ou resolve um problema ou uma solicitação de pull.

## Templates / Folders 

| **Template**                           | **Descrição**                                                                 | **Pasta Sugerida**           |
|----------------------------------------|-------------------------------------------------------------------------------|------------------------------|
| `README.md`                            | Documento principal que descreve o projeto, instruções de uso e instalação.   | Raiz do repositório (`/`)     |
| `CONTRIBUTING.md`                      | Guia de contribuição para o projeto (como abrir issues, pull requests, etc.). | Raiz do repositório (`/`)     |
| `CODE_OF_CONDUCT.md`                   | Regras de conduta para colaboradores do projeto.                              | Raiz do repositório (`/`)     |
| `LICENSE`                              | Arquivo de licença do projeto (MIT, GPL, etc.).                               | Raiz do repositório (`/`)     |
| `.gitignore`                           | Lista de arquivos e diretórios que o Git deve ignorar no controle de versão.  | Raiz do repositório (`/`)     |
| `SECURITY.md`                          | Instruções de como reportar problemas de segurança.                           | Raiz do repositório (`/`)     |
| `ISSUE_TEMPLATE.md`                    | Template para criação de issues (problemas) no repositório.                   | `.github/ISSUE_TEMPLATE/`     |
| `PULL_REQUEST_TEMPLATE.md`             | Template para criação de pull requests.                                       | `.github/PULL_REQUEST_TEMPLATE/` |
| `dependabot.yml`                       | Arquivo de configuração para dependabot (atualizações automáticas de dependências). | `.github/`                |
| `FUNDING.yml`                          | Configuração para exibir opções de financiamento no GitHub Sponsors.          | `.github/`                    |
| `workflow.yml` (GitHub Actions)        | Arquivos de configuração para pipelines de CI/CD com GitHub Actions.          | `.github/workflows/`          |
| `CODEOWNERS`                           | Define proprietários de código para revisão de pull requests.                 | `.github/`                    |


## Tabela Comparativo Contas

| **Recurso**                     | **GitHub Free**                     | **GitHub Pro**                      | **GitHub Team**                   | **GitHub Enterprise**            |
|----------------------------------|-------------------------------------|-------------------------------------|-----------------------------------|----------------------------------|
| **Repositórios privados**        | Ilimitados (colaboradores limitados) | Ilimitados                          | Ilimitados                        | Ilimitados                       |
| **Repositórios públicos**        | Ilimitados                          | Ilimitados                          | Ilimitados                        | Ilimitados                       |
| **Colaboradores**                | Limitado a 3 por repositório privado | Ilimitados                          | Ilimitados                        | Ilimitados                       |
| **Actions (CI/CD)**              | 2,000 min/mês                       | 3,000 min/mês                       | 3,000 min/mês                     | 50,000 min/mês + auto-hospedagem |
| **Packages**                     | 500 MB de armazenamento             | 2 GB de armazenamento               | 2 GB de armazenamento             | 50 GB de armazenamento           |
| **Suporte**                      | Comunidade                          | Suporte via e-mail                  | Suporte via e-mail                | Suporte 24/7 (e-mail, telefone)  |
| **Segurança (Dependabot, etc.)** | Básico                              | Completo                            | Completo                          | Completo                         |
| **Insights & Analytics**         | Limitado                            | Completo                            | Completo                          | Completo                         |
| **Gerenciamento de equipes**     | Não incluso                         | Não incluso                         | Gerenciamento básico              | Gerenciamento avançado           |
| **GitHub Pages**                 | Incluído                            | Incluído                            | Incluído                          | Incluído                         |
| **GitHub Projects**              | Incluído                            | Incluído                            | Incluído                          | Incluído                         |
| **GitHub Copilot**               | Não incluso                         | Assinatura separada                 | Assinatura separada               | Assinatura separada              |
| **SAML SSO (Single Sign-On)**    | Não incluso                         | Não incluso                         | Não incluso                       | Incluído                         |
| **Enterprise Managed Users (EMUs)** | Não disponível                     | Não disponível                      | Não disponível                    | Disponível                       |
| **Políticas de segurança personalizadas** | Não disponível                  | Não disponível                      | Não disponível                 | Disponível                       |



## Github Actions Syntax

A sintaxe de workflows no GitHub Actions é baseada em arquivos YAML. Aqui está uma visão geral dos principais elementos:

name: (Opcional) Nome do workflow.

```
name: CI Workflow
```
on: Define os eventos que acionam o workflow (push, pull_request, release, workflow_dispatch,
deployment, deployment_status, issues, issue_comment, page_build, pull_request_review, registry_package, schedule, and workflow_call).

```
on: 
  push:
    branches:
      - main
  pull_request:
```
jobs: Conjunto de tarefas (jobs) que serão executadas.
```
jobs:
  build:
    runs-on: ubuntu-latest
```
runs-on: Especifica o ambiente onde o job será executado (ex: ubuntu-latest, windows-latest, macos-latest).
```
runs-on: ubuntu-latest
```
steps: Lista de etapas a serem executadas dentro de um job. Cada etapa pode executar comandos ou ações.
```
steps:
  - name: Checkout code
    uses: actions/checkout@v2
  - name: Run tests
    run: npm test
```
uses: Refere-se a uma ação pré-existente do GitHub Marketplace ou de um repositório público.
```
uses: actions/setup-node@v2
```
run: Executa um comando de shell.
```
run: echo "Hello, World!"
```
env: Define variáveis de ambiente para o job ou para uma etapa específica.
```
env:
  NODE_ENV: production
```
strategy: (Opcional) Permite criar uma matriz de builds para executar jobs com diferentes combinações.
```
strategy:
  matrix:
    node-version: [10, 12, 14]
```
Essa estrutura modular permite definir workflows de forma clara e flexível, facilitando a automação de diversas tarefas no ciclo de desenvolvimento.

### Documentação Github Actions

<https://docs.github.com/pt/actions>

<https://docs.github.com/pt/actions/learn-github-actions/essential-features-of-github-actions>

<https://docs.github.com/pt/actions/using-workflows/about-workflows>

<https://docs.github.com/pt/actions/using-jobs/using-jobs-in-a-workflow>

<https://docs.github.com/pt/actions/learn-github-actions/expressions#functions>

<https://docs.github.com/pt/actions/using-jobs/using-conditions-to-control-job-execution>

<https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners/about-github-hosted-runners>

<https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs>

<https://github.com/marketplace?type=actions>

<https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#create-a-repository-dispatch-event>