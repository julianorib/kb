# Actions
Repositorio de Estudo Github Actions


Para criar uma pipeline é necessário utilizar uma estrutura de pastas:
```
projeto
projeto/.github
projeto/.github/workflows
projeto/.github/workflows/file.yaml
```

## Documentação

https://docs.github.com/pt/actions

https://docs.github.com/pt/actions/learn-github-actions/essential-features-of-github-actions

https://docs.github.com/pt/actions/using-workflows/about-workflows

https://docs.github.com/pt/actions/using-jobs/using-jobs-in-a-workflow

https://docs.github.com/pt/actions/learn-github-actions/expressions#functions

https://docs.github.com/pt/actions/using-jobs/using-conditions-to-control-job-execution


https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners/about-github-hosted-runners

https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs


https://github.com/marketplace?type=actions


https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#create-a-repository-dispatch-event


## Execução

on:

- workflow_dispatch
- push
- - branches
- - branches-ignore
- - tags
- - paths
- pull_request
- - branchs
- - types
- schedule


## Inputs
```
on:
  workflow-dispatch
    inputs:
      ambiente:
        type: string
        description: "Informe o ambiente"
        required: true
      numero:
        type: number
        default: 10
        description: "Informe o numero"
      deploy:
        type: boolean
        required: true
      xpto:
        type: choice
        required: true
        options:
          - valor1
          - valor2
```

Exibindo:
- ${{ inputs.ambiente}}
- ${{ inputs.mumero}}

## Outputs

- ${{ steps.nomedostep.outputs.variavel }}

## Artifact

Uma forma de armazenar arquivos gerados no action:
```
  artefato_job:
    name: Gerando arquivo
    runs-on: ubuntu-latest
    steps: 
      - name: job-artefatos
        run: |
          mkdir artefatos
          echo "teste" > ./artefatos/arquivo1.txt
  
      - name: Subindo arquivo para o artifacts
        uses: actions/upload-artifact@v4
        with:
          name: meu-artefato
          path: ./artefatos
```

Os arquivos ficam disponíveis por 90 dias na versão gratuita.

## Expressões

- ${{ variavel == "xpto" }}
- ${{ variavel > 20 }}
- ${{ !variavel }}


## Concorrência

Em determinadas situações, não é para ser executado o workflow ou o job mais de 1 vez ao mesmo tempo. Isso pode acontecer se houver 2 commits por exemplo, no intervalo de 1 execução.

Para resolver, deve-se utilizar o concurrency:\
Aceita qualquer valor, considerando que seja o mesmo, o job ou o workflow não será executado ao mesmo tempo. 
```
concurrency: umporvez 
```
Ou por branch + workflow:
```
concurrency:
  group: ${{ github.ref }}-${{ github.workflow }}
  cancel-in-progress: false
```

## Actions Marketplace

Pode-se dizer que uma Action é um Módulo extra.\
Ele é referenciado pelo:
```
- uses: action
  with:
    parametro1:
    parametro2:
```

A documentação de cada action é bem completa, e cheia de exemplos.

## Secrets

Há muitos casos que será necessário cadastrar logins, senhas e tokens para autenticação. \
Deve-se utilizar a opção de configuração de secrets and variables e em seguida, actions.

Para referenciar a secret no Workflow (pipeline):
```
${{ secrets.NOMEDACHAVE}}
```

## Workflow_call

Criar uma action para ser reutilizada em vários projetos.

Crie um novo arquivo yaml na pasta de workflows e escreva a action normalmente.\
Na opção de on:, informe workflow_call.

Para referenciar em outro projeto, é o mesmo processo das actions de marketplace.


## Repository_dispatch

É possível chamar o workflow por uma chamada HTTP, curl, etc.

```
name: Nome do Workflow
on:
  repository_dispatch:
    types:
      - deploy-remoto

...
  echo "ambiente: ${{ github.event.client_payload.ambiente }}
...
```

Criar um Token para chamar o workflow.

Settings, Developer Settings, Personal access tokens, Fine-grained tokens.

Definir o repositório que o token terá acesso e o tipo de acesso: Contents.

Exemplo de chamada curl:
```
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer <YOUR-TOKEN>" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/dispatches \
  -d '{"event_type":"on-demand-test","client_payload":{"unit":false,"integration":true}}'
```

## Ambientes

Repository, Settings, Environments.

Com os ambientes, é possível criar variáveis e secrets por Ambiente.

Ele é declarado no job logo após runs-on:
```
environment: teste
```

