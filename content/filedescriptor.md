# Too many open files

## File Descriptor

Tudo no Linux, desde dados, até sockets, é um arquivo.\
Um File Descriptor é um identificador inteiro não negativo para um arquivo aberto no Linux. Cada processo possui uma tabela de descritores de arquivos abertos, onde uma nova entrada é adicionada ao abrir um novo arquivo.

Por padrão, um processo tem 3 file descriptor:
- 0 -> stdin
- 1 -> stdout
- 2 -> stderr

## Verificar File Descriptor abertos

### Global
```
awk '{print $1}' /proc/sys/fs/file-nr
```

### Por Processo
```
lsof -p $(pidof caddy)
```

## Limites de File Descriptors

### Limite por sessão

Limite flexivel
```
ulimit -Sn
```
Limite rigido
```
ulimit -Hn
```

### Limite por processo
```
grep "Max open files" /proc/PID/limits
```

### Limite Global

Existe um limite em todo o sistema para o número total de File Descriptors que podem ser abertos por todos os processos combinados:
```
cat /proc/sys/fs/file-max
```

## Alterando / Aumentando os limites de File Descriptors

### Para sessão atual
```
ulimit -n 4096
ulimit -n
```

### Por Usuário
/etc/security/limits.conf
```
*       hard    nofile  16384
*       soft    nofile  16384
root    hard    nofile  16384
root    soft    nofile  16384
```

### Por serviço
Em distribuições baseadas em systemd, é utilizado o systemctl para configurar limites de serviços especificos.

Exemplo: apache
```
sudo mkdir -p /etc/systemd/system/apache.service.d/
sudo tee /etc/systemd/system/apache.service.d/filelimit.conf <<EOF
[Service]
LimitNOFILE=500000
EOF
```
Recarregar a configuração e reiniciar o serviço
```
sudo systemctl daemon-reload
sudo systemctl restart apache.service
```

### Globalmente

/etc/sysctl.conf
```
fs.file-max = 500000
```
Recarregar
```
sysctl -p
```
