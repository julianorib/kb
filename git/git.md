# Git Cheat Sheet

### Quick Referente:
<https://git-scm.com/docs>\
<https://ndpsoftware.com/git-cheatsheet.html#google_vignette>


## Iniciar um projeto 

| Comando      |  Descrição |
|--------------|------------|
| git clone xpto | Baixar um projeto remoto |
| git init | Iniciar um projeto local |
| git config --local user.email "seuemail@dominio.com" | Configurar um User E-mail no projeto | 
| git config --local user.name "seu nome" | Configurar um User Name no projeto |
| git branch -M main | Alterar a branch do projeto para Main |
| git remote add origin https://xpto... | Adicionar o repositorio remoto ao projeto local |

## Commit - Push - Pull 

| Comando      |  Descrição |
|--------------|------------|
| git add . | Adicionar todos arquivos no commit |
| git add file.xpto | Adicionar um arquivo no commit | 
| git commit -m "init" | Comitar alterações |
| git push | Subir commit no repositório | 
| git push -u origin main | Subir commit no repositório | 
| git pull | Atualizar local com remoto |

## Tags
| Comando      |  Descrição |
|--------------|------------|
| git tag | Listar Tags criadas |
| git tag v0.1 | Adicionar uma Tag |
| git tag -d v0.1 | Remover uma Tag |
| git push --tags | Subir tag no repostitório remoto |


## Trabalhando com branchs 
| Comando      |  Descrição |
|--------------|------------|
| git branch  | Listar branchs |
| git branch developer | Criar uma nova Branch "developer" |
| git checkout developer | Trocar para a Branch "developer" |
| git checkout -b feature1 | Criar uma nova Branch e Trocar |
| git branch -d feature1 | Apagar uma Branch "feature1" |


## Criando uma feature a partir de developer
```
git checkout developer 
git checkout -b feature1
```
*Fazer modificações no projeto*
```
git add .
git commit -m "feature1 xpto"
git push -u origin feature1
```

## Juntando a feature na developer
```
git checkout developer
git merge feature1
git branch -d feature1
git push
``` 

## Rastreabilidade

| Comando      |  Descrição |
|--------------|------------|
| git status | Ver status do projeto |
| git log | Ver logs de commits |
| git log file.txt | Ver logs de um arquivo |
| git log --oneline | Ver logs resumido |
| git log -n 2 | Ver logs dos ultimos 2 commits |
| git log --graph --oneline | ver linha do tempo dos commits e branchs |


## Corrigindo problemas

| Comando      |  Descrição |
|--------------|------------|
| git restore file.xpt | Restaurar um arquivo remoto sobre o atual |
| git log | Ver os Commits e Hashs |
| git reset --hard hash | Restaurar o projeto para um commit especifico da linha do tempo |
| git push --force | Forçar o push substituindo os outros commits | 
