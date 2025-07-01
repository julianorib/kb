# Zabbix Cheat Sheet

## Reference

<https://www.zabbix.com/documentation/current/en/manual/appendix/command_execution>


## Recarregar o Cache do Zabbix Frontend
```
zabbix_server -R config_cache_reload
```

## Testar a captura de um Item 
```
zabbix_get -s IP -p 10050 -k "item"
```

## Testar o envio de valor para um Item
```
zabbix_sender -v -z 127.0.0.1 -s "NOMEHOST" -k NOMEITEM -o valor
zabbix_sender -v -z 127.0.0.1 -s "servidorA" -k ping -o 1
```

## Testar conectividade SNMP
```
snmpwalk -c public -v2c IP
snmpwalk -v3 -n none -u USER -a MD5 -A SENHA -l authNoPriv -c public IP
```



