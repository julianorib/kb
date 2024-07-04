# Network tests


| Comando | Descrição |
|---------|-----------|
| ip a | Verificar IP em um S.O. Linux | 
| ipconfig | Verificar IP em um S.O. Windows |
| ping | Testar resposta em um destino |
| telnet | Testar conexão em um destino e porta | 
| traceroute | Traçar a rota até determinado destino |
| nslookup | Verificar registros DNS |
| route | Ver tabela de roteamento |
| netstat -na | Exibir conexões ativas |
| ss -ant | Exibir conexões de escuta |
| nmap | Ver portas TCP abertas em um destino |
| nmap -sU -v | Ver portas UDP abertas em um destino |
| tcpdump | Capturar trafego em uma interface de rede |
| iftop | Ver tráfego de rede S.O. Linux em tempo real |
| iptables -L | Ver regras de Firewall ativas |


## Tcpdump 
```
 tcpdump -ni interface protocolo host ip
```

## Netstat 
Catalogando a quantidade de conexões estabelecidas por IP:
```
netstat -tn 2>/dev/null | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr
```

Catalogando a quantidade de conexões estabelecidadas por Porta:
```
netstat -tn 2>/dev/null | grep 443 | awk '{print $5}' | cut -d: -f1 | sort | uniq -c
```


