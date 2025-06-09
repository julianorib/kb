## Node e NVM

Como utilizar o Node e NVM sem ser administrador do computador.

Baixe a versão sem instalador:
<https://github.com/coreybutler/nvm-windows/releases>\
<https://github.com/coreybutler/nvm-windows/releases/download/1.2.2/nvm-noinstall.zip>

Descompacte na pasta **c:\nvm**


Crie 2 variáveis de ambiente no Windows:
```
NVM_HOME = c:\nvm
NVM_SYMLINK = C:\nvm\nodejs
```
*Observação: Essa pasta C:\nvm\nodejs não deve existir*


Adicione essas 2 variáveis no PATH do Windows:
```
%NVM_HOME%
%NVM_SYMLINK%
```

Adicione uma permissão para o usuário criar Links simbolicos:
```
gpedit.msc
```
```
Politica Computador Local
    Configuração do Computador
        Configurações do Windows
            Configurações de Segurança
                Politicas Locais
                    Atribuição de direitos do usuário
                        Criar links simbólicos.
```

Reinicie o computador.


Acesse o Terminal.

```
nvm --version
```

```
nvm install 16
nvm install 18
nvm install 20
```

```
nvm use 18
```

```
node --version
```


Erro:
```
activation error: NVM_SYMLINK is set to a physical file/directory at C:\nvm\nodejs
Please remove the location and try again, or select a different location for NVM_SYMLINK.
```

Esse erro significa que existe uma pasta c:\nvm\nodejs.\
Deve ser apagada.
