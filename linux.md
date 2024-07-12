# Linux Cheat Sheet

Quick Reference:
<https://linuxconfig.org/linux-commands-cheat-sheet>

### Arquivos e Diretórios
Listar somente pastas ocultas
```
ls -dl .*/ 
```
#### FIND: Pesquisar arquivos maiores de 1GB
```
find /pasta/ -type f -size +1G 
```

#### FIND: Pesquisar um arquivo e executar um comando para cada resultado 
```
find /pasta -name arquivo.txt -exec ls -lh {} \; 
```

#### FIND: Pesquisar arquivos com o conteúdo especifico dentro
```
find . -name "file*" -exec grep -Hin "text" {} \; 
```

#### SED: Substituir uma linha em um arquivo sem entrar dentro dele:
```bash
sed -i "s/#Listen=80/Listen=8080/g" arquivo.txt
```

#### TR: Substituir um caracter por outro em um comando:
```
echo $PATH | tr ":" "\n"
```

#### GREP: Mostrar somente conteúdo descomentado de um arquivo:
<https://www.geeksforgeeks.org/grep-command-in-unixlinux/>
```
cat rsyslog.conf | grep -v "^#" | grep -v "^$"
```

#### GREP: Mostrar as 3 linhas antes e 2 linhas depois do conteúdo filtrado (foo)
```
grep -B 3 -A 2 foo README.txt
```

#### SED: Mostrar uma linha especifica em um arquivo:
```
cat arquivo.conf | sed -n '2p' 
```

#### AWK: Formatar output 
```
ps aux | awk '{print $11}'
```
Será exibido a 11a coluna


#### CUT: Formatar output separado por um delimitador.
Primeira coluna : Segunda Coluna
```
cut -d ':' -f 2
```
Será exibido o texto após o :

| Opções | Descrição |
|--------|-----------|
| -d ' ' | Delimitador da separação do texto |
| -f 2/3/4 | Define a coluna que será exibida |


#### TAIL: Filtrando as palavras que deseja visualizar:
```bash
tail -f arquivo.log | grep 'filtro'
tail -f arquivo.log | egrep (filtro1|filtro2)
tail -f arquivo.log | egrep "filtro1|filtro2|filtro3"
```

#### RSYNC: Sincronizar arquivo mantendo as permissões:
```bash
rsync -avh --progress /origem/	/destino/
rsync -av -e ssh /origem/ root@servidor:/destino/
```

### Compressão
| Comando | Descrição |
|---------|-----------|
| tar cf my_dir.tar my_dir	| Create an uncompressed tar archive |
| tar cfz my_dir.tar my_dir | Create a tar archive with gzip compression |
| gzip file	| Compress a file with gzip compression |
| tar xf file |Extract the contents of any type of tar archive |
| gunzip file.gz |Decompress a file that has gzip compression |

### Permissões
| Comando | Descrição |
|---------|-----------|
| chown | Mudar dono do arquivo. |
| chmod | Mudar permissão do arquivo. |

| No | Permissão |
|----|-----------|
| 0 | sem permissão |
| 1 | x  | 
| 2 | w  |
| 3 | wx |
| 4 | r |
| 5 | rx |
| 6 | rw |
| 7 | rwx |

### Armazenamento
| Comando | Descrição |
|---------|-----------|
| tree | Visualizar estrutura de diretório |
| df -h | Visualizar partições | 
| fdisk -l | Visualizar discos |
| lsblk | Visualizar Partições x Discos LVM |
| du -hs | Visualizar espaço em uso | 
| du -hs * | Visualizar espaço em uso por arquivo/pasta |
| ncdu -x / | Visualizar espaço em uso (treesize) | 
| mount | Montar e desmontar partições | 
| hdparm -t /dev/sda | Velocidade de gravação/leitura disco |

### Users
| Comando | Descrição |
|---------|-----------|
| w / who | ver usuários logados |
| whoami | ver seu usuário da sessão logada |
| last | mostrar a lista de usuários que logaram |

### Processos e Recursos
| Comando | Descrição |
|---------|-----------|
| top | Ver processos e recursos em tempo real |
| ps aux | Ver processos em execução |
| kill | Finalizar um processo |
| lsof | Visualizar processos por várias opções | 
| free -h | Visualizar memória | 
| cat /proc/cpuinfo | Visualizar cpu |


Ver arquivos em uso por usuário, processo, etc.
```bash
lsof
lsof -u usuario
lsof -p PID
lsof -i:porta (80)
lsof -t /pasta
```

### Variáveis
| Comando | Descrição |
|---------|-----------|
| env | Mostra todas variáveis de sistema |
| export MYVAR="xpto" | Criar uma variável MYVAR |
| echo $MYVAR | Visualizar uma variável $MYVAR |
| unset MYVAR | Remover uma variável MYVAR |

