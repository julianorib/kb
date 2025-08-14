# Grafana

## Dashboards

### Variáveis

#### Prometheus 
![1](variables1.png)
![2](variables2.png)

#### Zabbix

| chave/item | valor |
|---|---|
| Query type | Host |
| Group | Firewall |
| Host | /1234_00.*/ |
| Regex | /.*/ |

### Tabelas

- Criar as variáveis
- Criar quantas querys forem necessárias.
- Criar transformações
    - 1 - Labels to fields (não em todos casos)
    - 2 - Merge series/tables
    - 3 - Organize fields by name
    - 4 - Group by
          - Host/Name Group by
          - Itens: calculate last* 
