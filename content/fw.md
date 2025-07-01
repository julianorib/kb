# Regras padrões Firewall

## Windows

Visualizar Regras:
```
Get-NetFirewallRule
```
Apagar todas regras:
```
Get-NetFirewallRule | Remove-NetFirewallRule
```
Libera Ping:
```
New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
```
Libera saída geral:
```
New-NetFirewallRule -DisplayName "Allow All Outbound Traffic" -Direction Outbound -Action Allow
```
Bloqueia entrada geral:
```
New-NetFirewallRule -DisplayName "Block All Inbound Traffic" -Direction Inbound -Action Block
```
Libera entrada 80:
```
New-NetFirewallRule -DisplayName "Allow HTTP Inbound" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow
```

## Linux

Visualizar as regras:
```
iptables -L
```

Limpar todas as regras:
```
iptables -F 
```

Permitir localhost
```
iptables -A INPUT -i lo -j ACCEPT
```

Permitir conexões estabelecidas
```
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

Permitir o ping de qualquer rede
```
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
```

Permitir a entrada de comunicação na porta 80 (HTTP)
```
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

Permitir a entrada de comunicação na porta 22 (SSH)
```
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

Permitir todo o tráfego de saída
```
iptables -A OUTPUT -j ACCEPT
```

Bloquear todo o tráfego de entrada (exceto o que foi explicitamente permitido)
```
iptables -P INPUT DROP
```

Salvar configurações:
Debian derivados:
```
iptables-persistent
netfilter-persistent save
```
Redhat derivados
```
iptables-services
service iptables save
```
