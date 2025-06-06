# GitLab CI/CD

Começando:
<https://docs.gitlab.com/ee/ci/>

Para criar uma pipeline CI/CD no Gitlab, você precisa ter uma conta e um projeto. Em seguida, deve-se criar um arquivo no raiz do seu projeto, chamado:

```
.gitlab-ci.yml
```

Para execução da Pipeline, é utilizado os "Runners".\
Há Runners compartilhados, mas o melhor é criar/registrar um Runner.

https://docs.gitlab.com/runner/install/

Após instalar um Runner, é necessário registrar.
```
gitlab-runner register --url endereçoGitLab --token <token>
```

## Sintaxe 

<https://docs.gitlab.com/ee/ci/yaml/>

A estrutura de um pipeline no Gitlab é bem simples.

.gitlab-ci.yml
```
stages:
  - build
  - test

job_build:
  stage: build
  script:
    - echo "Building the project"

job_test:
  stage: test
  script:
    - echo "Running tests"
```


## Variáveis

Há algumas variáveis do próprio Gitlab que podem ser utilizadas no código.\
Para definir as suas variáveis, no menu esquerdo, Settings, CI/CD, Variáveis


