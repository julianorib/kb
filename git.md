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
| git push -u origin main | Subir commit no repositório | 


## Trabalhando com branchs 
```
git branch *listar*
git branch developer *criar*
git checkout developer *altera*
git checkout -b feature1 *cria uma nova e altera*
git branch -d feature1 *apaga*
```

## Criando uma feature a partir de developer
[developer] -> [feature1]
```
git checkout -b feature1
git add .
git commit -m "feature1"
git push -u origin feature1
```

## Juntando a feature na developer
[feature1] -> [developer]
```
git checkout developer
git merge feature1
git branch -d feature1
git push
``` 