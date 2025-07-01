# GIT

O Git é um sistema de controle de versão gratuito e de código aberto criado por Linus Torvalds in 2005

## Conceitos

"Working Dir" é o diretório do sistema de arquivos onde o código está armazenado e o local onde você está atualmente desenvolvendo um novo recurso ou corrigindo bugs.

**git init**

"Index" é a área de preparo, é o local onde você armazena todos os arquivos que precisam ser confirmados. Isso geralmente é feito executando o comando.

**git add**

"HEAD" é apenas um ponteiro para qualquer confirmação ou ramificação que você tenha executado no momento. Por padrão, se você fez check-out da ramificação, o HEAD apontará para a ramificação. 

**git checkout main**


- Master
Principal Linha do tempo de um código.

- Branch
Linhas do Tempo de um código

- Merge
Unir linhas do tempo de código.

- Commit
Aplicar alterações de um código.

- Remote
Link do repositório.
Faz a ligação do repositorio local com o remoto.

- push
Atualiza o repositorio remoto a partir do local.

- pull
Atualiza o repositorio local a partir do remoto.

*Observação:*
arquivo readme.md é um arquivo de instruções.
Ele fica na pagina inicial do projeto com as instruções.


## Explicando os comandos: 

### Iniciando um novo repositorio
```
git init
```

### Configurar o git
- Para todos os usuarios
```
git config --system user.emal "email@dominio.com"
git config --system user.name "seu nome"
```

- Para o usuário atual
```
git config --global user.email "seuemail@dominio.com"
git config --global user.name "seu nome"
git config --global http.sslVerify false
```

- Para um projeto especifico (só funciona apos o git init)
```
git config --local user.email "seuemail@dominio.com"
git config --local user.name "seu nome"
```

### Se der erro de SSL 
```
git config --global http.sslVerify false
```

### Gerando uma chave SSH para conectar com o Git
ssh-keygen -t rsa 

Defina um nome se quiser.
Copie o conteudo publico da chave (arquivo.pub) para a configuração do seu usuário no GITHub, GITLab, etc.


### Definir uma chave SSH com nome alternativo para o repositorio
Colocar a linha abaixo no arquivo .git/config do projeto.
```
[core]
 sshCommand = "ssh -i ~/.ssh/suachave"
```

### Ignorando arquivos
Crie um arquivo .gitignore dentro do projeto.
Dentro do arquivo especifique um arquivo ou alguma extensão de arquivo.


### Subir o repositorio local para o Remoto. 
```
git remote add origin https://github.com/nomedousuario/nomeprojeto.git
git remote add origin git@github.com:usuario/projeto.git 
```

### Adicionando arquivos ao projeto
```
git add nomedoarquivo
git add . (todos os arquivos)
```

### Verificando o status do projeto
```
git status
```

### Executando um commit no projeto
```
git commit -m "titulo do commit"
```

### Verificando commits executados
```
git log
```

### Ver commit de um arquivo especifico
```
git log -p nomedoarquivo
```

### Subir as alterações (commits) no Repositorio Remoto 
```
git push -u origin main (primeira vez)
git push 
```

### Resetando um commit (um estado antigo do arquivo)
```
git checkout hashdocommit
git checkout main (volta para o ultimo commit da branch)
git reset --hard (altera para o commit que setou no checkout)
```

### Atualizar o Projeto local com os dados do Projeto Remoto
```
git pull
```

### Atualizar o Projeto Remoto com os dados do Projeto Local
```
git push
```

### Restaurar um arquivo a partir do repositório Remoto

```
git restore nomearquivo.txt
git restore 
```


### Fazer o download completo do repositorio.
```
git clone git@github.com:usuario/projeto.git
```

## Branches
Linha do tempo atual / alternativas de um projeto

Não é correto ficar fazendo commits direto na branch main.
Tenha uma Branch de Desenvolvimento ou Correção e trabalhe nela.

| Comando | Descrição |
|----|----|
| git branch | listar |
| git branch dev-homol | criar uma nova |
| git checkout dev-homol | trocar branch |
| git checkout -b nova_brach | criar uma nova e trocar |
| git branch -d dev-homol | apagar branch |


## Merge
Junta as alterações de alternativas / linhas do tempo

Quando é feito o push, é criado automaticamente um "Merge Request" (link) ou "Pull Request".
Após testado e validado, preencher esta requisição, Aprovar e em seguida fazer o Merge.
No repositório, é necessário definir os membros para Aprovarem o Request.

Trocar de volta para a Branch Main e fazer o Merge.
```
git checkout main
git merge dev-homol 
```

## Criando uma nova Branch e Subindo no Repositorio
```
git chekout -b dev-homol
git add novo-arquivo.txt
git commit -m "novo-arquivo.txt"
git push -u origin dev-homol
```

## Rebase
Junta as alterações de alternativas / linhas do tempo
Mas não é aconselhável fazer na Branch Main .
Somente em Dev Homol etc. 
Ela não mantem um historico correto dos Commits.

```
git checkout main
git rebase dev-homol
```

## Cherry Pick
Uma forma de pegar um Commit de uma Branch (não main) para outra Branch. Sem utilizar Merge ou Rebase.

```
git checkout branch_5
git log *para ver o hash do commit na branch que deseja capturar o conteudo*
git checkout branch_10
git cherry-pick  HASH 
```

## Fetch
Forma mais suave de atualizar o Repositório Local com o Remoto.
Quando esta em conflito alterações nos 2 locais e mesmo arquivo.

```
git fetch origin
git diff main origin/main
```

## Git LOG
Rastreabilidade
```
git log
git log arquivo.txt
git log --oneline *resumido*
git log -n 2  *2 ultimas alterações*

**git log --oneline -3**

git log --graph *mostra as linhas de branchs*
git log --graph --oneline
git log --author ""
```

## Documentação

<https://git-scm.com/docs>