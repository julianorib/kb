# Introdução ao Elasticsearch e ao Stack ELK

Este documento e voltado para quem ainda nao conhece o Elasticsearch.
O objetivo e explicar o que e, como funciona, para que serve e como ele se encaixa dentro do Stack ELK.

---

## Sumário

- [O que e o Elasticsearch](#o-que-e-o-elasticsearch)
- [Para que ele serve](#para-que-ele-serve)
- [O Stack ELK](#o-stack-elk)
  - [Elasticsearch](#elasticsearch)
  - [Logstash](#logstash)
  - [Kibana](#kibana)
  - [Beats](#beats)
  - [Como as pecas se conectam](#como-as-pecas-se-conectam)
- [Como o Elasticsearch funciona por dentro](#como-o-elasticsearch-funciona-por-dentro)
  - [Documentos](#documentos)
  - [Indices](#indices)
  - [Shards](#shards)
  - [Replicas](#replicas)
  - [Nos e cluster](#nos-e-cluster)
  - [Master node](#master-node)
  - [Data node](#data-node)
  - [Coordinating node](#coordinating-node)
- [Como os dados sao armazenados](#como-os-dados-sao-armazenados)
  - [O papel do Lucene](#o-papel-do-lucene)
  - [Segmentos](#segmentos)
  - [Indice invertido](#indice-invertido)
  - [Translog](#translog)
- [Como uma busca acontece](#como-uma-busca-acontece)
  - [Fase de dispersao](#fase-de-dispersao)
  - [Fase de coleta](#fase-de-coleta)
  - [Relevancia e score](#relevancia-e-score)
- [Como os dados chegam ao Elasticsearch](#como-os-dados-chegam-ao-elasticsearch)
  - [Indexacao direta via API](#indexacao-direta-via-api)
  - [Via Logstash](#via-logstash)
  - [Via Beats (Filebeat, Metricbeat)](#via-beats)
  - [Via Kafka](#via-kafka)
- [Tipos de dados e campos](#tipos-de-dados-e-campos)
- [O que e o Kibana e para que serve](#o-que-e-o-kibana-e-para-que-serve)
  - [Discover](#discover)
  - [Dashboard](#dashboard)
  - [Lens](#lens)
  - [Dev Tools](#dev-tools)
- [Casos de uso comuns](#casos-de-uso-comuns)
- [Quando nao usar o Elasticsearch](#quando-nao-usar-o-elasticsearch)
- [Comparativo rapido com outras tecnologias](#comparativo-rapido-com-outras-tecnologias)

---

## O que e o Elasticsearch

Elasticsearch e um mecanismo de busca e analise de dados distribuido, de codigo aberto, construido sobre a biblioteca Lucene.

Ele foi criado para armazenar grandes volumes de dados e permitir buscas rapidas, mesmo em conjuntos de dados com bilhoes de documentos.

Em termos simples:

- voce envia dados para o Elasticsearch (textos, logs, metricas, documentos JSON)
- ele indexa esses dados de forma otimizada para busca
- voce faz perguntas (queries) e ele responde em milissegundos

O Elasticsearch e orientado a documentos. Isso significa que cada unidade de dado e um documento JSON. Nao ha tabelas, linhas ou colunas como em um banco relacional.

---

## Para que ele serve

O Elasticsearch e amplamente usado em tres grandes categorias:

**Busca**

- Busca em sites e aplicacoes (e-commerce, portais de conteudo)
- Busca por texto livre em documentos, artigos, produtos
- Autocomplete e sugestoes
- Busca tolerante a erros de digitacao (fuzzy search)

**Observabilidade e monitoramento**

- Armazenamento e busca de logs de aplicacoes e infraestrutura
- Analise de traces e spans de requisicoes
- Monitoramento de metricas ao longo do tempo
- Deteccao de anomalias em series temporais

**Analise de dados**

- Agregacoes e dashboards sobre grandes volumes de dados
- Analise de comportamento de usuarios
- Relatorios operacionais em tempo real

---

## O Stack ELK

O Stack ELK e um conjunto de ferramentas criadas pela empresa Elastic que trabalham juntas para coletar, processar, armazenar e visualizar dados.

O nome vem das iniciais das tres ferramentas originais: **E**lasticsearch, **L**ogstash e **K**ibana.

Com o tempo, os **Beats** foram adicionados e o stack passou a ser chamado tambem de **Elastic Stack**.

### Elasticsearch

O nucleo do stack. Responsavel por armazenar os dados e responder as buscas e agregacoes.

Todas as outras ferramentas do stack ou enviam dados para o Elasticsearch ou consultam dados que estao nele.

### Logstash

Ferramenta de coleta, transformacao e envio de dados.

Ele age como um pipeline: recebe dados de alguma fonte (arquivo, Kafka, Beats, banco de dados), transforma ou enriquece esses dados conforme necessario, e os envia para o Elasticsearch ou outro destino.

O Logstash e util quando e necessario fazer transformacoes complexas nos dados antes de indexar.

Exemplo: um log de aplicacao chega como texto puro. O Logstash extrai os campos (timestamp, nivel, mensagem, servico) e envia um documento JSON estruturado para o Elasticsearch.

### Kibana

Interface grafica do stack.

Com o Kibana, e possivel:

- explorar os dados armazenados no Elasticsearch
- criar dashboards com graficos, tabelas e mapas
- configurar alertas
- gerenciar policies de ciclo de vida (ILM)
- usar o Dev Tools para executar queries diretamente

O Kibana nao armazena dados. Ele consulta o Elasticsearch e exibe os resultados.

### Beats

Agentes leves instalados nos servidores ou pods para coletar dados e enviar diretamente ao Elasticsearch ou ao Logstash.

Cada Beat tem um proposito especifico:

| Beat | O que coleta |
|---|---|
| Filebeat | Arquivos de log |
| Metricbeat | Metricas de sistema e servicos (CPU, memoria, disco) |
| Packetbeat | Trafego de rede |
| Heartbeat | Disponibilidade de endpoints (ping, HTTP, TCP) |
| Auditbeat | Eventos de auditoria do sistema operacional |

A vantagem dos Beats e serem leves. Eles consomem poucos recursos e sao faceis de instalar.

### Como as pecas se conectam

```text
[Fontes de dados]
  Aplicacoes, servidores, Kubernetes, bancos de dados

       |
       v

[Coleta]
  Filebeat / Metricbeat / outros Beats
  (leves, instalados perto da fonte)

       |
       v

[Processamento] (opcional)
  Logstash
  (transformacao, enriquecimento, roteamento)

       |
       v

[Armazenamento e busca]
  Elasticsearch

       |
       v

[Visualizacao]
  Kibana
```

Em ambientes mais simples, os Beats enviam diretamente para o Elasticsearch sem passar pelo Logstash.

Em ambientes mais complexos, o Logstash processa os dados antes de indexar.

---

## Como o Elasticsearch funciona por dentro

### Documentos

A unidade basica de dado no Elasticsearch e o **documento**.

Um documento e um objeto JSON. Cada documento tem um identificador unico (`_id`) e pertence a um indice.

Exemplo de documento:

```json
{
  "_index": "pedidos",
  "_id":    "abc123",
  "_source": {
    "cliente":     "Maria",
    "produto":     "Notebook",
    "valor":       3500.00,
    "status":      "aprovado",
    "data_pedido": "2024-01-15T10:30:00"
  }
}
```

Nao existe schema rigido como em banco relacional. Um documento pode ter campos que outro nao tem.

### Indices

Um indice e uma colecao de documentos relacionados.

Voce pode pensar em um indice como sendo parecido com uma tabela em banco relacional, mas muito mais flexivel.

Exemplos de indices:

- `pedidos` — todos os pedidos da aplicacao
- `logs-app-2024.01.15` — logs da aplicacao do dia 15/01/2024
- `metricas-infra` — metricas de infraestrutura

Em ambientes de logs, e comum criar um indice por dia ou por semana. Isso facilita a exclusao de dados antigos (basta deletar o indice do dia) e melhora o desempenho.

### Shards

Quando um indice e criado, o Elasticsearch o divide internamente em partes menores chamadas **shards**.

Cada shard e uma instancia independente do Lucene e pode ficar em um no diferente do cluster.

Isso permite que:

- o indice seja maior do que o que cabe em um unico servidor
- as buscas sejam processadas em paralelo por varios nos

```text
Indice "logs-app" com 3 shards e 3 nos:

No 1: shard 0 (primaria)   shard 1 (replica)
No 2: shard 1 (primaria)   shard 2 (replica)
No 3: shard 2 (primaria)   shard 0 (replica)
```

O numero de shards primarias e definido na criacao do indice e **nao pode ser alterado depois**.

### Replicas

Replicas sao copias das shards primarias.

Elas servem para dois propositos:

1. **Alta disponibilidade**: se um no falhar e suas shards primarias ficarem inacessiveis, as replicas em outros nos assumem automaticamente
2. **Leitura paralela**: buscas podem ser respondidas tanto pelas shards primarias quanto pelas replicas, aumentando o throughput de leitura

O numero de replicas pode ser ajustado a qualquer momento sem perda de dados.

Em producao com 3 ou mais nos, o recomendado e ter pelo menos 1 replica por shard.

### Nos e cluster

Um **no** e uma instancia do Elasticsearch rodando em um servidor.

Um **cluster** e um conjunto de nos que trabalham juntos e compartilham o mesmo nome de cluster (`cluster.name` no arquivo de configuracao).

Os nos se descobrem automaticamente via o mecanismo de descoberta (Zen Discovery ou seed hosts configurados).

Cada no tem um papel (role) que define o que ele faz dentro do cluster.

### Master node

O no master e responsavel por gerenciar o estado do cluster:

- criar e deletar indices
- alocar shards aos nos
- rastrear quais nos estao no cluster
- monitorar a saude do cluster

Em clusters com 3 ou mais nos, e recomendado ter **3 nos master dedicados** (sem dados). Isso garante quorum e evita o split-brain.

**Quorum**: numero minimo de nos master necessarios para tomar decisoes. Com 3 nos master, o quorum e 2. Se um falhar, os outros dois ainda formam maioria e o cluster continua operando.

**Split-brain**: situacao em que o cluster se divide em dois grupos isolados, cada um achando que e o verdadeiro cluster. Pode causar inconsistencia de dados. O quorum previne isso.

### Data node

Nos de dados armazenam os documentos e processam buscas e agregacoes.

Eles sao os nos que precisam de mais recursos: RAM, disco e CPU.

Em clusters maiores, costuma-se separar nos de dados hot (SSD, dados recentes) e nos de dados warm (HDD, dados mais antigos).

### Coordinating node

Um no coordenador nao armazena dados nem gerencia o cluster.

Ele recebe as requisicoes dos clientes, as distribui para os nos corretos e agrega os resultados antes de devolver ao cliente.

Em clusters com alto volume de requisicoes, nos coordenadores dedicados ajudam a descarregar os nos de dados.

---

## Como os dados sao armazenados

### O papel do Lucene

O Elasticsearch nao implementa o mecanismo de busca diretamente. Por baixo, ele usa a biblioteca **Apache Lucene**.

O Lucene e responsavel por:

- criar e manter o indice invertido
- armazenar os documentos em segmentos
- executar as queries e retornar resultados ranqueados

O Elasticsearch adiciona sobre o Lucene a camada distribuida: distribui os dados em shards, replica entre nos, coordena buscas paralelas e gerencia o cluster.

### Segmentos

Cada shard e composta por varios **segmentos** do Lucene.

Um segmento e imutavel: uma vez criado, nao e modificado. Quando novos documentos chegam, eles vao para um buffer em memoria. Periodicamente (a cada 1 segundo por padrao via `refresh_interval`), esse buffer e transformado em um novo segmento no disco.

Isso significa que um documento indexado so aparece em buscas apos o proximo refresh.

Com o tempo, segmentos pequenos sao fundidos em segmentos maiores num processo chamado **merge** (ou `forcemerge` quando feito manualmente). Isso libera espaco em disco e melhora o desempenho de busca.

### Indice invertido

O indice invertido e a estrutura central que permite buscas rapidas.

Em vez de varrer todos os documentos para encontrar quem contem determinado termo, o Elasticsearch mantem uma lista invertida: para cada termo, a lista dos documentos que o contem.

```text
Documentos originais:
  doc1: "servidor de aplicacao com erro"
  doc2: "erro de conexao no banco"
  doc3: "servidor reiniciado com sucesso"

Indice invertido (simplificado):
  "servidor"    -> doc1, doc3
  "aplicacao"   -> doc1
  "erro"        -> doc1, doc2
  "conexao"     -> doc2
  "banco"       -> doc2
  "reiniciado"  -> doc3
  "sucesso"     -> doc3
```

Uma busca por `erro` consulta diretamente a entrada `erro` no indice invertido e retorna `doc1` e `doc2` sem precisar ler todos os documentos.

### Translog

O **translog** (transaction log) e um arquivo de log de operacoes.

Toda operacao de escrita (indexar, atualizar, deletar) e registrada primeiro no translog antes de ir para o segmento.

O translog serve de protecao: se o no cair antes de um segmento ser persistido no disco, as operacoes do translog podem ser reenviadas na recuperacao.

---

## Como uma busca acontece

Quando voce faz uma busca no Elasticsearch, o processo tem duas fases.

### Fase de dispersao

O no coordenador recebe a requisicao e a envia para uma shard de cada indice envolvido.

O Elasticsearch pode escolher tanto shards primarias quanto replicas para responder, distribuindo a carga.

Cada shard executa a busca localmente e retorna os IDs dos documentos mais relevantes com seus scores, sem retornar o documento completo ainda.

### Fase de coleta

O no coordenador coleta os resultados parciais de todas as shards, ordena por relevancia, descarta os que nao entram na pagina solicitada, e entao vai buscar os documentos completos nas shards que os possuem.

Por fim, o resultado final e montado e devolvido ao cliente.

Essa separacao em duas fases existe porque seria caro buscar os documentos completos em todas as shards. Primeiro se descobre quais sao os mais relevantes (apenas IDs e scores), e so depois busca o conteudo completo dos selecionados.

### Relevancia e score

Quando voce faz uma busca por texto, o Elasticsearch calcula um **score** para cada documento.

O score indica o quao relevante o documento e para a query. Documentos com score maior aparecem primeiro.

O algoritmo padrao e baseado no **BM25** (Best Match 25), que leva em conta:

- frequencia do termo no documento (TF): quanto mais vezes o termo aparece, mais relevante
- frequencia inversa no indice (IDF): termos que aparecem em muitos documentos sao menos distintivos
- tamanho do campo: um termo em um campo curto e mais significativo do que em um campo muito longo

---

## Como os dados chegam ao Elasticsearch

### Indexacao direta via API

O Elasticsearch expoe uma API REST. Qualquer aplicacao pode enviar documentos diretamente via HTTP.

```bash
curl -X POST "http://localhost:9200/pedidos/_doc" \
  -H "Content-Type: application/json" \
  -d '{
    "cliente": "Maria",
    "produto": "Notebook",
    "valor": 3500.00,
    "status": "aprovado"
  }'
```

Esse e o metodo mais direto. Usado em aplicacoes que geram eventos e os enviam em tempo real.

### Via Logstash

Para dados que precisam de transformacao, o Logstash atua como intermediario.

Fluxo tipico com logs de aplicacao:

```text
arquivo de log -> Logstash (grok, mutate, date) -> Elasticsearch
```

O Logstash extrai campos do texto bruto, converte tipos, remove campos desnecessarios e entao envia o documento estruturado.

### Via Beats

Para coleta de logs de arquivos ou metricas de sistema, o Filebeat e o Metricbeat sao os agentes mais simples.

```text
arquivo de log -> Filebeat -> Elasticsearch
arquivo de log -> Filebeat -> Logstash -> Elasticsearch
```

O Filebeat e instalado no servidor ou no pod, monitora os arquivos de log e envia as linhas para o Elasticsearch ou Logstash.

### Via Kafka

Em arquiteturas de alta escala, o Kafka atua como buffer entre os produtores de dados e o Elasticsearch.

```text
aplicacao -> Kafka (topico) -> Logstash (consumer) -> Elasticsearch
```

Isso desacopla a producao do consumo e permite absorver picos de volume sem perder dados.

---

## Tipos de dados e campos

O Elasticsearch suporta varios tipos de campo no mapping:

| Tipo | Uso |
|---|---|
| `text` | Texto livre, analisado para busca full-text (descricoes, mensagens de log) |
| `keyword` | Valor exato, usado para filtros, agregacoes e ordenacao (status, ID, codigo) |
| `integer`, `long`, `float`, `double` | Valores numericos |
| `date` | Datas e timestamps (aceita varios formatos) |
| `boolean` | true / false |
| `ip` | Enderecos IPv4 e IPv6 |
| `geo_point` | Coordenadas geograficas (latitude, longitude) |
| `object` | Objeto JSON aninhado |
| `nested` | Objeto JSON aninhado com busca independente de cada elemento |
| `flattened` | Objeto JSON com chaves dinamicas, tratado como keyword |
| `binary` | Dados binarios codificados em Base64 |

A escolha do tipo certo impacta diretamente o comportamento de busca, o tamanho do indice e a performance das queries.

**text vs keyword**: o campo `text` passa por analise (tokenizacao, lowercase, etc.) e e otimo para busca por partes do texto. O campo `keyword` nao e analisado e serve para correspondencia exata, filtros e agregacoes. Na pratica, um mesmo campo pode ter os dois tipos via `fields`:

```json
{
  "status_descricao": {
    "type": "text",
    "fields": {
      "keyword": { "type": "keyword" }
    }
  }
}
```

Assim `status_descricao` suporta busca full-text e `status_descricao.keyword` suporta filtro exato e agregacao.

---

## O que e o Kibana e para que serve

O Kibana e a interface grafica do Elastic Stack. Ele acessa o Elasticsearch via API e exibe os dados de forma visual.

### Discover

A aba Discover e usada para explorar logs e documentos de forma interativa.

Voce escolhe um index pattern (ex: `logs-app-*`), define o intervalo de tempo, aplica filtros e ve os documentos em formato de tabela ou JSON.

E o ponto de partida para investigar um incidente ou entender o que esta nos dados.

### Dashboard

Dashboards reúnem paineis (graficos, tabelas, contadores) em uma tela unica.

Cada painel executa uma query ou agregacao no Elasticsearch e exibe o resultado visualmente.

Exemplos de paineis comuns:

- grafico de barras de erros por hora
- tabela de top 10 endpoints mais lentos
- contador de erros criticos nas ultimas 24h
- mapa de calor de latencia por servico ao longo do tempo

### Lens

Lens e o editor visual de graficos do Kibana.

Com ele e possivel criar visualizacoes arrastando campos, sem precisar escrever queries manualmente.

### Dev Tools

O Dev Tools e um console interativo dentro do Kibana para executar queries diretamente no Elasticsearch.

Muito usado por desenvolvedores e SREs para:

- testar queries antes de usar em producao
- explorar mappings e configuracoes de indices
- executar comandos de administracao

Exemplo no Dev Tools:

```
GET logs-app-*/_search
{
  "size": 0,
  "aggs": {
    "erros_por_servico": {
      "terms": { "field": "servico.keyword", "size": 10 }
    }
  }
}
```

---

## Casos de uso comuns

**Observabilidade de logs em Kubernetes**

Filebeat coleta logs dos pods, envia para Logstash que estrutura os campos, Elasticsearch armazena e o Kibana exibe dashboards com erros, latencia e volume por servico.

**Busca em e-commerce**

Catalogo de produtos indexado no Elasticsearch. Busca full-text com autocomplete, filtros por categoria/preco/marca, ordenacao por relevancia e metricas de busca em tempo real.

**Analise de fraude**

Eventos de transacao indexados em tempo real. Queries de agregacao detectam padroes suspeitos: multiplos pedidos do mesmo IP, velocidade de transacoes acima do esperado, combinacoes incomuns de campos.

**Monitoramento de metricas de infraestrutura**

Metricbeat coleta CPU, memoria e disco de todos os nos. Kibana exibe dashboards de capacidade com alertas quando algum no ultrapassa os limiares.

---

## Quando nao usar o Elasticsearch

O Elasticsearch e poderoso, mas nao e a ferramenta certa para todos os cenarios.

**Nao use para**:

- **Transacoes ACID**: o Elasticsearch nao suporta transacoes atomicas entre documentos. Para dados financeiros que exigem consistencia forte, use um banco relacional.
- **Joins complexos**: nao e pensado para relacionamentos entre entidades com joins. Para dados altamente relacionados, use um banco relacional ou grafo.
- **Atualizacoes frequentes de documentos**: o Elasticsearch e otimizado para escrita e leitura, nao para atualizacoes constantes no mesmo documento. Cada update cria internamente uma nova versao.
- **Fonte unica de verdade para dados criticos**: o Elasticsearch e um excelente complemento, mas em geral nao deve ser o unico lugar onde dados criticos vivem.

---

## Comparativo rapido com outras tecnologias

| Tecnologia | Elasticsearch | PostgreSQL/MySQL | MongoDB | Splunk |
|---|---|---|---|---|
| Modelo de dado | Documento JSON | Tabela/linha | Documento JSON | Eventos de log |
| Busca full-text | Excelente | Limitada | Moderada | Boa |
| Escala horizontal | Nativa | Complexa | Boa | Boa |
| Transacoes ACID | Nao | Sim | Parcial | Nao |
| Agregacoes em tempo real | Excelente | Boa | Boa | Boa |
| Custo de licenca | Open source (BSL) | Open source | Open source | Alto |
| Curva de aprendizado | Media | Baixa | Baixa | Media |
| Uso tipico em observabilidade | Logs, traces, metricas | Nao usual | Nao usual | Logs |

---

## Proximos passos

Para aprofundar o conhecimento, veja os outros documentos nesta pasta:

- [README.md](README.md) — referencia tecnica com exemplos de queries, mappings, templates, ILM, logstash, agregacoes e manutencao de cluster
