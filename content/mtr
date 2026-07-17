# MTR - Guia Rápido

## Como usar:

```
# Modo interativo (tempo real)
mtr destino.com

# TCP em porta específica (melhor para firewalls)
mtr --tcp --port 443 destino.com

# Gera relatório e sai
mtr --report --tcp --port 443 destino.com
```

## Colunas
| Coluna	| O que é| 
| --| --| 
| Loss%	| % de pacotes perdidos nesse hop| 
| Snt	| Total de pacotes enviados| 
| Last	| Latência do último pacote (ms)| 
| Avg	| Latência média (ms)| 
| Best	| Menor latência (ms)| 
| Wrst	| Maior latência (ms)| 
| StDev	| Jitter — quanto a latência varia| 

## Interpretação rápida

Loss% no meio mas 0% no destino → falso positivo, roteador ignorando ICMP. Normal.

Loss% cresce e persiste até o destino → perda real. Problema no hop onde começou.

StDev alto (ex: >50ms) → latência instável, jitter. Link congestionado ou instável.

Avg salta muito entre dois hops → link lento ou geográfico entre esses dois pontos.
