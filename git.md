# cheat git

## Iniciando
```
gitv clone
git init
git config --local user.email "seuemail@dominio.com"
git config --local user.name "seu nome"
```
```
git branch -M main 
git remote add origin 
```
```
git add .
git commit -m "init"
git push
```

## Proteja a branch main contra push sem PR
- No projeto, Configurações, Branchs.
- Add classic branch protection rule.
- - Informe o nome "main".
- - Require a pull request before merging.
- - - Require approvals *ATENÇÃO*
- - Require status checks to pass before merging.
- - Do not allow bypassing the above settings.
- - Save.


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

## PR
Não faça as mudanças e commit na "main".\
Trabalhe com a "developer" e "featureX".\
Faça o commit da "developer" e faça o PR na "main".


## Atualizando a Developer após Merge com Main
[main] > [developer]
```
git checkout main
git pull
git checkout developer
git merge main
```

## Tags

Releases.
```
git tag
git tag -a v1.0 -m "mensagem" *criar*
git tag -a v1.0 -m "mensagem" hashcomit *criar*
git tag -d v1.0 *apagar*

git push --tags
```