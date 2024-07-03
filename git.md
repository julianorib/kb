# Git Cheat Sheet

## Iniciar um projeto |

| Comando      |  Descrição |
|--------------|------------|
| git clone xpto | Baixar um projeto remoto |
| git init | Iniciar um projeto local |
| git config --local user.email "seuemail@dominio.com" | Configurar um User E-mail no projeto | 
| git config --local user.name "seu nome" | Configurar um User Name no projeto |
| git branch -M main | Alterar a branch do projeto para Main |
| git remote add origin | Adicionar o repositorio remoto ao projeto local |

## Comitar atualizações no projeto e Subir para o Repositório

| Comando      |  Descrição |
|--------------|------------|
| git add . | Adicionar todos arquivos no commit |
| git add file.xpto | Adicionar um arquivo no commit | 
| git commit -m "init" | Comitar alterações |
| git push | Subir commit no repositório | 
| git push -u origin main | Subir commit no repositório | 


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