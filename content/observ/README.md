# Observabilidade

**Referências: ChatGPT**


Observabilidade **não é apenas monitoramento**. Enquanto o monitoramento mostra **o que está acontecendo**, a observabilidade permite entender **por que algo está acontecendo**.

##  Os 3 Pilares da Observabilidade

1. **Logs** – Registros de eventos e erros (ex: "Banco de dados não respondeu").
2. **Métricas** – Valores numéricos ao longo do tempo (ex: CPU = 90%).
3. **Traces (ou Rastreamentos)** – Fluxo de uma requisição de ponta a ponta (ex: usuário clicou no botão → API → banco).

---
## Principais Ferramentas Open source 

- [Métricas - Prometheus](prometheus.md)
- [Traces - Jaeger](tracing.md)
- [Logs - Loki](loki.md)
- [Visualização - Grafana](grafana/README.md)

## Principais Ferramentas Comerciais

### 1. **Datadog** 
- **Pilar forte:** Logs, Métricas e Traces.
- **Destaque:** Plataforma unificada, fácil integração com AWS, Azure e GCP.
- **Ponto forte:** Dashboards intuitivos, alertas automáticos, auto discovery.
- **Ideal para:** Ambientes cloud-native, DevOps, microserviços.

---

### 2. **New Relic**
- **Pilar forte:** Traces + APM (Application Performance Monitoring).
- **Destaque:** Ótimo para identificar gargalos em código.
- **Ponto forte:** Foco em performance de aplicações.
- **Ideal para:** Desenvolvedores e equipes de produto.

---

### 3. **Dynatrace**
- **Pilar forte:** Observabilidade full-stack com IA.
- **Destaque:** Inteligência artificial para detecção e causa raiz.
- **Ponto forte:** Correlação automática entre todos os dados.
- **Ideal para:** Grandes ambientes corporativos e complexos.

---

### 4. **Elastic Observability (ELK Stack)**
- **Pilar forte:** Logs e Métricas.
- **Destaque:** Base open-source com versão comercial.
- **Ponto forte:** Altamente customizável.
- **Ideal para:** Ambientes que já usam Elasticsearch e precisam de flexibilidade.

---

### 5. **Splunk Observability Cloud**
- **Pilar forte:** Logs e métricas em tempo real.
- **Destaque:** Foco em análise em larga escala.
- **Ponto forte:** Muito usado em segurança (SIEM).
- **Ideal para:** Grandes volumes de dados e requisitos de compliance.

---

### 6. **AppDynamics (Cisco)**
- **Pilar forte:** APM.
- **Destaque:** Boa integração com ambientes Cisco.
- **Ponto forte:** Foco em performance de aplicações em ambientes corporativos.
- **Ideal para:** Empresas com infraestrutura tradicional.

---

<br>
<br>
<br>


#  OpenTelemetry 

<https://opentelemetry.io/>\
<https://opentelemetry.io/docs/>\
<https://opentelemetry.io/docs/getting-started/>

Imagine que você está montando um **grande quebra-cabeça** da sua infraestrutura. Cada peça é um pedaço de informação: logs, métricas e rastreamentos. O **OpenTelemetry** (ou simplesmente **OTel**) é o **kit de ferramentas padrão** que te ajuda a **coletar essas peças de forma organizada**, independente da linguagem, ferramenta ou nuvem que você usa.

---

## O que é o OpenTelemetry?

> **OpenTelemetry é um padrão aberto para coletar, processar e exportar dados de observabilidade.**

---

##  Por que ele existe?

Antes do OpenTelemetry, cada ferramenta (Datadog, New Relic, Prometheus, etc.) usava **seu próprio jeito** de coletar dados. Isso gerava muito retrabalho: códigos duplicados, agentes diferentes, integrações difíceis.

A ideia do OpenTelemetry é padronizar tudo isso. Você coleta com OpenTelemetry **e envia para onde quiser**.

---

##  Como funciona (de forma simples)

### Ele tem 3 papéis principais:

1. **Instrumentation (Instrumentação)**  
   Coloca sensores no seu código ou infra. Ele registra coisas como:
   - Quanto tempo uma API demora
   - Qual erro aconteceu
   - Quantos usuários acessaram
   - Qual banco de dados foi usado

2. **Collection (Coleta)**  
   Junta esses dados e os prepara para envio. Pode coletar de:
   - Aplicações (com SDKs)
   - Bibliotecas (HTTP, gRPC, SQL, etc.)
   - Serviços de nuvem, containers e VMs

3. **Export (Exportação)**  
   Envia os dados para ferramentas como:
   - Datadog
   - Prometheus
   - Grafana
   - Jaeger
   - Splunk
   - Elastic
   - Ou qualquer ferramenta compatível

---

##  Componentes principais

| Componente         | Explicação                                        |
|--------------------|----------------------------------------------------------|
| **SDKs**           | Bibliotecas para instrumentar o código (Java, Python, Go, etc.) |
| **Collector**      | Agente que coleta, transforma e exporta dados            |
| **Exporter**       | Plugin que envia os dados para a ferramenta desejada     |
| **Tracer / Meter** | Geradores de traces e métricas                           |

---

##  Tipos de dados que ele coleta

- **Traces** – Fluxo de uma requisição (ideal para microserviços)
- **Métricas** – CPU, memória, contadores, tempo de resposta
- **Logs** – (em desenvolvimento, com suporte parcial)

---

##  Exemplo de Arquitetura

```plaintext
[App Java com OTel SDK]
       |
       V
[OpenTelemetry Collector] ---> [Datadog]
                           ---> [Prometheus]
                           ---> [Grafana]
```

___

<br>
<br>

#  O que é APM?

**APM** significa **Application Performance Monitoring**, ou em português:

> **Monitoramento de Performance de Aplicações**

É como se fosse um **raio-x em tempo real da sua aplicação**. Ele mostra onde está lento, o que está travando e como cada pedaço do sistema está se comportando — tudo isso com um foco especial no **código da aplicação**.

---

##  Qual é o objetivo do APM?

Responder à pergunta:

> "**Por que meu sistema está lento ou com erro?**"

---

##  Analogia: Um Médico para sua Aplicação

Imagine que sua aplicação é **um paciente** e o APM é **um médico de plantão 24x7**.

- Mede o **batimento cardíaco** da sua aplicação (tempo de resposta).
- Observa onde está sentindo dor (erros, exceções).
- Vê se os **órgãos** (banco de dados, APIs, filas) estão funcionando bem.
- Mostra **exames detalhados** (rastros de execução, queries, funções lentas).

---

##  O que um APM monitora?

| Área Monitorada                  | O que mostra                         |
|----------------------------------|--------------------------------------|
|  Tempo de Resposta             | Quais endpoints estão lentos         |
|  Chamadas Externas             | APIs, bancos, filas, serviços        |
|  Rastreamento de requisições  | Do começo ao fim (Tracing)           |
|  Erros e exceções              | Onde e por que falhou                |
|  Gargalos no código            | Funções lentas, loops pesados        |
|  Consultas a banco             | SQLs lentas, sem índice              |
|  Uso de recursos               | Threads, memória, CPU                |

---


##  Como o APM funciona por trás dos panos?

1. Você **instala um agente** ou **usa um SDK** no seu app.
2. Ele começa a medir **cada requisição**, **cada chamada ao banco**, **cada exceção**.
3. Esses dados são enviados para uma **plataforma APM**, onde são:
   - Processados
   - Correlacionados
   - Exibidos em **dashboards interativos**
4. Você pode configurar **alertas** (ex: se o tempo de resposta > 1s)

---

##  Exemplo real do uso de APM

Imagine que um usuário abre sua aplicação web e clica no botão “Buscar Produtos”.

Com APM, você pode ver:

```plaintext
[Requisição do Usuário]
  └─> Frontend (React)
        └─> API /produtos
              ├─> Ver tempo de resposta
              ├─> Ver consulta no banco
              ├─> Ver chamada externa à API de estoque
              └─> Ver erro se a resposta foi 500
```


<br>
<br>


# Veja mais: 

### Armazenamento de Logs
- Elasticsearch
- Opensearch
- Grafana Loki

### Coletores de Logs
- Logstash
- Fluent-bit
- Promtail

### Visualização de Logs
- Graylog
- Kibana
- Grafana

### Tracing
- Zipkin
- Jaeger
- Grafana Tempo


