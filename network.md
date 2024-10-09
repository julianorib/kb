# Redes privadas IPv4

| Classe | Bloco | Faixa | Ips |
|---|---|---|---|
| A | 10.0.0.0/8 | 10.0.0.0 -> 10.255.255.255 | 16.777.216 |
| B | 172.16.0.0/12 | 172.16.0.0 -> 172.31.255.255 | 1.048.576 |
| C | 192.168.0.0/16 | 192.168.0.0 -> 192.168.255.255 | 65.536 |


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
| netstat -ltu | Exibir somente portas abertas |
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


