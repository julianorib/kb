# cheat git
[init]
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