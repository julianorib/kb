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

