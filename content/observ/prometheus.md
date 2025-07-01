# Prometheus

Prometheus é um sistema open source criado pela SoundCloud, muito usado para coletar métricas em tempo real, armazená-las e permitir consultas e alertas com base nesses dados.

## Ref:
<https://prometheus.io/docs/introduction/overview/>\
<https://prometheus.io/docs/prometheus/latest/querying/basics/>

## Arquitetura

![](https://prometheus.io/assets/docs/architecture.svg)


## Como funciona

### Coleta de dados

Prometheus "pergunta" periodicamente a aplicações e serviços (chamados de targets) por métricas.
Esses serviços expõem dados em um endpoint HTTP (geralmente /metrics) no formato de texto simples.

### Armazenamento

As métricas coletadas são armazenadas localmente em uma base de dados time series (séries temporais).

### Consulta

Usa uma linguagem própria chamada PromQL para consultar e analisar as métricas.

### Alertas

Com base em regras definidas, ele pode gerar alertas e enviá-los para ferramentas como Alertmanager, Slack, e-mail, etc.

## Exemplo prático

<https://github.com/julianorib/mysite>\
Este projeto é um exemplo de aplicação que expoe métricas.\
Estas podem ser visualizadas no Grafana e Prometheus que sobem junto.

Um servidor ou aplicação expõe métricas como:
```
http_requests_total{method="GET", handler="/"}  5120
```

O Prometheus coleta essa métrica e você pode fazer uma consulta como:

```
rate(http_requests_total[5m])
```
*Isso mostra a média de requisições por segundo nos últimos 5 minutos.*


## Resumo

É necessário configurar os `targets` dos servidores, ou aplicações no Prometheus.\
Estes `targets`estão na sessão `scrape_configs`.\
Deve haver um `job_name` para cada aplicação / endpoint que for monitorado.

`prometheus.yml`
```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'mysite'
    static_configs:
      - targets: ['mysite:8080']

```

## PromQL

<https://prometheus.io/docs/prometheus/latest/querying/basics/>
<https://prometheus.io/docs/prometheus/latest/querying/functions/>

Exemplos Documentação:
<https://prometheus.io/docs/prometheus/latest/querying/examples/>

Se a aplicação tiver métricas, normalmente ficam em `/metrics`.\
Ex:
<http://localhost:8080/metrics>

Será exibido diversas métricas. Conforme exemplo abaixo:

`flask_http_request_total`
|metric|value|
|---|---|
|flask_http_request_total{instance="mysite:8080", job="mysite", method="GET", status="404"}| 54 |
|flask_http_request_total{instance="mysite:8080", job="mysite", method="GET", status="200"} | 441 |
| flask_http_request_total{instance="mysite:8080", job="mysite", method="HEAD", status="200"} | 54010 |

- É possível filtrar essas métricas por labels:

`flask_http_request_total{status="404"}`
|metric|value|
|---|---|
|flask_http_request_total{instance="mysite:8080", job="mysite", method="GET", status="404"}| 54 |

`flask_http_request_total{method="HEAD"}`
|metric|value|
|---|---|
| flask_http_request_total{instance="mysite:8080", job="mysite", method="HEAD", status="200"} | 76863 |

- Outros exemplos:

Filtra mais de uma condição:\
`flask_http_request_total{status=~"200|301"}`

Com intervalo de tempo:\
`flask_http_request_total[1m]`

Média:\
`rate(flask_http_request_total[1m])`

Soma + Agrupamento:\
`sum(rate(flask_http_request_total[5m])) by (status)`
