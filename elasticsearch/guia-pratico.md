# Guia Prático de Elasticsearch

Este documento complementa o [README.md](README.md) com explicacoes mais detalhadas, contexto adicional e exemplos praticos para quem ja tem uma nocao basica do Elasticsearch e quer aprofundar o entendimento.

---

## Sumário

- [Como o mapping dinamico funciona](#como-o-mapping-dinamico-funciona)
- [Tipos de queries e quando usar cada uma](#tipos-de-queries-e-quando-usar-cada-uma)
- [Paginacao de resultados](#paginacao-de-resultados)
- [Ordenacao de resultados](#ordenacao-de-resultados)
- [Source filtering](#source-filtering)
- [Multi-index e wildcards](#multi-index-e-wildcards)
- [Gerenciamento de indices via API](#gerenciamento-de-indices-via-api)
- [Reindex](#reindex)
- [Snapshots e backup](#snapshots-e-backup)
- [Seguranca](#seguranca)
- [Performance de indexacao](#performance-de-indexacao)
- [Performance de busca](#performance-de-busca)
- [Diagnostico e troubleshooting](#diagnostico-e-troubleshooting)
- [Glossario](#glossario)

---

## Como o mapping dinamico funciona

Por padrao, o Elasticsearch nao exige que voce defina o mapping antes de indexar.

Quando o primeiro documento chega a um indice novo, o Elasticsearch infere o tipo de cada campo automaticamente. Esse comportamento se chama **dynamic mapping**.

### Regras de inferencia padrao

| Valor no JSON | Tipo inferido |
|---|---|
| `"texto qualquer"` | `text` + `keyword` (subfield) |
| `123` | `long` |
| `12.5` | `float` |
| `true` / `false` | `boolean` |
| `"2024-01-15"` | `date` (se bater com formatos de data conhecidos) |
| `{"campo": "valor"}` | `object` |
| `["a", "b"]` | mesmo tipo dos elementos |

### Problema do dynamic mapping em producao

O dynamic mapping e conveniente para desenvolvimento, mas arriscado em producao:

1. **Tipos errados**: um campo `codigo_pedido` pode chegar como `"1234"` (string) num documento e como `1234` (numero) em outro, causando `mapper_parsing_exception`
2. **Explosao de campos**: JSONs dinamicos podem criar centenas de novos campos, ultrapassando o limite de 1000
3. **Tipo errado para o uso**: um campo de ID pode ser mapeado como `text` quando deveria ser `keyword`

### Como controlar o dynamic mapping

Desabilitar o mapping dinamico para novos campos desconhecidos:

```bash
curl -X PUT "http://localhost:9200/pedidos" \
  -H "Content-Type: application/json" \
  -d '{
    "mappings": {
      "dynamic": "strict",
      "properties": {
        "cliente": { "type": "keyword" },
        "valor":   { "type": "float"   },
        "status":  { "type": "keyword" }
      }
    }
  }'
```

Opcoes para `dynamic`:

| Valor | Comportamento |
|---|---|
| `true` | Cria campo novo automaticamente (padrao) |
| `false` | Ignora campos desconhecidos silenciosamente (nao indexa) |
| `strict` | Rejeita o documento se houver campo desconhecido (erro) |

---

## Tipos de queries e quando usar cada uma

### Visao geral

```text
Busca por texto livre (analisado)   -> match, match_phrase, multi_match
Busca por valor exato               -> term, terms
Filtro por faixa                    -> range
Busca aproximada (erro de digitacao)-> match com fuzziness
Busca por padrao                    -> wildcard, prefix, regexp
Combinacao de condicoes             -> bool (must, filter, should, must_not)
Busca em varios campos ao mesmo tempo -> multi_match
```

### `term` vs `match`

Essa e a confusao mais comum.

`term` busca o valor exatamente como foi indexado. Nao passa por analyzer. Funciona em campos `keyword`.

`match` passa o valor pelo analyzer antes de buscar. Funciona em campos `text`.

```bash
# CORRETO: term em campo keyword
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{ "query": { "term": { "status": "aprovado" } } }'

# ERRADO: term em campo text (pode nao encontrar porque o valor foi analisado na indexacao)
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{ "query": { "term": { "descricao": "Notebook Dell" } } }'

# CORRETO: match em campo text
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{ "query": { "match": { "descricao": "Notebook Dell" } } }'
```

### `terms` (plural)

Busca documentos onde o campo tenha qualquer um dos valores da lista. Equivale ao `IN` do SQL.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "terms": {
        "status": ["aprovado", "pendente"]
      }
    }
  }'
```

### `range` com datas

```bash
curl -X GET "http://localhost:9200/logs/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "range": {
        "@timestamp": {
          "gte": "now-1h",
          "lte": "now"
        }
      }
    }
  }'
```

Expressoes de data relativa: `now-1h`, `now-30m`, `now-7d`, `now/d` (inicio do dia).

### `multi_match`

Busca o mesmo texto em varios campos ao mesmo tempo.

```bash
curl -X GET "http://localhost:9200/produtos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "multi_match": {
        "query": "notebook dell",
        "fields": ["nome", "descricao", "tags"],
        "type": "best_fields"
      }
    }
  }'
```

Tipos de `multi_match`:

| Tipo | Comportamento |
|---|---|
| `best_fields` | Score do campo onde a correspondencia e melhor (padrao) |
| `most_fields` | Soma o score de todos os campos com correspondencia |
| `cross_fields` | Trata todos os campos como um unico campo combinado |
| `phrase` | Busca a frase em cada campo |

### `exists`

Filtra documentos que tem (ou nao tem) um determinado campo:

```bash
# documentos que tem o campo "desconto"
{ "query": { "exists": { "field": "desconto" } } }

# documentos que NAO tem o campo "desconto"
{ "query": { "bool": { "must_not": [ { "exists": { "field": "desconto" } } ] } } }
```

---

## Paginacao de resultados

Por padrao, o Elasticsearch retorna os 10 primeiros resultados.

Para paginar, use `from` e `size`:

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "from": 20,
    "size": 10,
    "query": { "match_all": {} }
  }'
```

- `from`: a partir do resultado numero X (zero-indexed)
- `size`: quantos resultados retornar

### Limite de paginacao profunda

Por padrao, o Elasticsearch rejeita buscas com `from + size > 10000`.

Isso porque paginacao profunda e custosa: para retornar a pagina 1000 com 10 itens, o Elasticsearch precisa calcular os 10010 documentos mais relevantes e descartar os primeiros 10000.

Para navegar em conjuntos grandes, use **Search After**:

```bash
# primeira pagina
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 10,
    "sort": [{ "data_pedido": "desc" }, { "_id": "asc" }],
    "query": { "match_all": {} }
  }'

# pagina seguinte: use os valores de sort do ultimo resultado
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 10,
    "sort": [{ "data_pedido": "desc" }, { "_id": "asc" }],
    "search_after": ["2024-01-15T10:30:00", "abc123"],
    "query": { "match_all": {} }
  }'
```

O `search_after` usa os valores de sort do ultimo documento da pagina anterior como cursor. Mais eficiente e sem limite de profundidade.

---

## Ordenacao de resultados

Por padrao, resultados sao ordenados por score (relevancia).

Para ordenar por um campo especifico:

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "sort": [
      { "data_pedido": { "order": "desc" } },
      { "valor":       { "order": "desc" } }
    ],
    "query": { "match_all": {} }
  }'
```

Campos `text` nao podem ser usados para ordenacao. Use o subfield `keyword`:

```bash
{ "sort": [ { "nome.keyword": { "order": "asc" } } ] }
```

Para ordenar por `_score` e por campo ao mesmo tempo:

```bash
{
  "sort": [
    "_score",
    { "data_pedido": { "order": "desc" } }
  ]
}
```

---

## Source filtering

Por padrao, o Elasticsearch retorna o documento completo em `_source`.

Para retornar apenas os campos necessarios (economiza banda e processamento):

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "_source": ["cliente", "status", "valor"],
    "query": { "match_all": {} }
  }'
```

Para excluir campos especificos:

```bash
{
  "_source": {
    "excludes": ["campo_grande", "dados_internos"]
  }
}
```

Para nao retornar nenhum campo (util em agregacoes):

```bash
{ "_source": false, "size": 0, "aggs": { ... } }
```

---

## Multi-index e wildcards

Voce pode buscar em varios indices ao mesmo tempo:

```bash
# indice especifico
GET /logs-app-2024.01.15/_search

# multiplos indices separados por virgula
GET /logs-app-2024.01.15,logs-app-2024.01.16/_search

# wildcard (todos os indices que comecam com logs-app-)
GET /logs-app-*/_search

# todos os indices
GET /_all/_search
GET /*/_search
```

Wildcards sao muito usados para buscas em indices diarios sem precisar especificar cada um.

---

## Gerenciamento de indices via API

### Criar indice com configuracao

```bash
curl -X PUT "http://localhost:9200/meu-indice" \
  -H "Content-Type: application/json" \
  -d '{
    "settings": {
      "number_of_shards":   2,
      "number_of_replicas": 1,
      "refresh_interval":   "5s"
    },
    "mappings": {
      "properties": {
        "titulo":    { "type": "text"    },
        "status":    { "type": "keyword" },
        "criado_em": { "type": "date"    },
        "valor":     { "type": "float"   }
      }
    }
  }'
```

### Verificar mapping de um indice

```bash
curl -X GET "http://localhost:9200/pedidos/_mapping?pretty"
```

### Alterar settings em um indice existente

```bash
# aumentar replicas
curl -X PUT "http://localhost:9200/pedidos/_settings" \
  -H "Content-Type: application/json" \
  -d '{ "index": { "number_of_replicas": 2 } }'

# desabilitar refresh temporariamente (melhora velocidade de indexacao em massa)
curl -X PUT "http://localhost:9200/pedidos/_settings" \
  -H "Content-Type: application/json" \
  -d '{ "index": { "refresh_interval": "-1" } }'

# reabilitar refresh
curl -X PUT "http://localhost:9200/pedidos/_settings" \
  -H "Content-Type: application/json" \
  -d '{ "index": { "refresh_interval": "1s" } }'
```

### Fechar e abrir um indice

Um indice fechado nao aceita leituras nem escritas, mas continua ocupando espaco em disco. Util para arquivamento temporario sem exclusao.

```bash
# fechar
curl -X POST "http://localhost:9200/logs-2023-01-01/_close"

# abrir
curl -X POST "http://localhost:9200/logs-2023-01-01/_open"
```

### Deletar um indice

```bash
# deletar indice especifico (irreversivel)
curl -X DELETE "http://localhost:9200/logs-app-2024.01.01"

# deletar via wildcard
curl -X DELETE "http://localhost:9200/logs-app-2023.*"
```

### Ver informacoes de todos os indices

```bash
# listagem rapida com status, contagem e tamanho
curl -X GET "http://localhost:9200/_cat/indices?v&s=index"

# apenas indices de um padrao
curl -X GET "http://localhost:9200/_cat/indices/logs-app-*?v&s=store.size:desc"
```

---

## Reindex

O `_reindex` copia documentos de um indice para outro.

E a forma correta de migrar dados quando voce precisa:

- mudar o numero de shards primarias
- alterar o tipo de um campo no mapping
- aplicar um novo analyzer
- reorganizar dados de multiplos indices em um so

### Reindex basico

```bash
curl -X POST "http://localhost:9200/_reindex" \
  -H "Content-Type: application/json" \
  -d '{
    "source": { "index": "pedidos-v1" },
    "dest":   { "index": "pedidos-v2" }
  }'
```

### Reindex com filtro

Copia apenas documentos aprovados:

```bash
curl -X POST "http://localhost:9200/_reindex" \
  -H "Content-Type: application/json" \
  -d '{
    "source": {
      "index": "pedidos-v1",
      "query": {
        "term": { "status": "aprovado" }
      }
    },
    "dest": { "index": "pedidos-v2" }
  }'
```

### Reindex de multiplos indices

```bash
curl -X POST "http://localhost:9200/_reindex" \
  -H "Content-Type: application/json" \
  -d '{
    "source": { "index": ["logs-app-2024.01.01", "logs-app-2024.01.02"] },
    "dest":   { "index": "logs-app-janeiro-2024" }
  }'
```

### Boas praticas no reindex

- Crie o indice destino com o mapping correto antes de iniciar o reindex
- Use `"conflicts": "proceed"` se quiser ignorar erros de versao em vez de parar
- Em indices grandes, considere usar `slices` para paralelizar:

```bash
{
  "source": { "index": "pedidos-grande" },
  "dest":   { "index": "pedidos-novo" },
  "conflicts": "proceed"
}
# execute com ?slices=auto para paralelismo automatico
```

---

## Snapshots e backup

O Elasticsearch nao tem backup automatico nativo fora do ILM com searchable snapshots.

O mecanismo de backup padrao sao os **snapshots**.

### Repositorio de snapshot

Antes de tirar um snapshot, e preciso configurar um repositorio (onde o snapshot sera salvo).

Tipos de repositorio suportados:

- Sistema de arquivos compartilhado (NFS, SMB)
- Amazon S3
- Azure Blob Storage
- Google Cloud Storage
- HDFS

Exemplo configurando repositorio em sistema de arquivos:

```bash
curl -X PUT "http://localhost:9200/_snapshot/backup-nfs" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "fs",
    "settings": {
      "location": "/mnt/backup/elasticsearch"
    }
  }'
```

### Criar um snapshot

```bash
# snapshot de todos os indices
curl -X PUT "http://localhost:9200/_snapshot/backup-nfs/snapshot-2024-01-15" \
  -H "Content-Type: application/json" \
  -d '{
    "indices": "*",
    "ignore_unavailable": true,
    "include_global_state": false
  }'

# snapshot de indices especificos
curl -X PUT "http://localhost:9200/_snapshot/backup-nfs/snapshot-logs-janeiro" \
  -H "Content-Type: application/json" \
  -d '{
    "indices": "logs-app-2024.01.*",
    "ignore_unavailable": true
  }'
```

### Verificar status do snapshot

```bash
curl -X GET "http://localhost:9200/_snapshot/backup-nfs/snapshot-2024-01-15?pretty"
```

### Restaurar um snapshot

```bash
curl -X POST "http://localhost:9200/_snapshot/backup-nfs/snapshot-2024-01-15/_restore" \
  -H "Content-Type: application/json" \
  -d '{
    "indices": "pedidos",
    "rename_pattern":     "(.+)",
    "rename_replacement": "restaurado-$1"
  }'
```

O `rename_replacement` renomeia o indice ao restaurar, evitando conflito com o indice ativo.

### Politica automatica de snapshot via SLM

O SLM (Snapshot Lifecycle Management) automatiza a criacao e retencao de snapshots:

```bash
curl -X PUT "http://localhost:9200/_slm/policy/backup-diario" \
  -H "Content-Type: application/json" \
  -d '{
    "schedule":   "0 30 2 * * ?",
    "name":       "<backup-{now/d}>",
    "repository": "backup-nfs",
    "config": {
      "indices": "*",
      "include_global_state": false
    },
    "retention": {
      "expire_after": "30d",
      "min_count":    5,
      "max_count":    30
    }
  }'
```

- `schedule`: cron expression — nesse caso, todo dia as 02:30
- `expire_after`: deleta snapshots mais antigos que 30 dias
- `min_count` / `max_count`: garante minimo de 5 e maximo de 30 snapshots

---

## Seguranca

### Autenticacao e autorizacao

A partir da versao 8.x, o Elasticsearch habilita seguranca por padrao (TLS e autenticacao obrigatorios).

O usuario `elastic` e criado automaticamente com senha gerada na instalacao.

Principais usuarios internos:

| Usuario | Uso |
|---|---|
| `elastic` | Superusuario, acesso total |
| `kibana_system` | Usado pelo Kibana para se conectar ao Elasticsearch |
| `logstash_system` | Usado pelo Logstash para enviar metricas de monitoramento |
| `beats_system` | Usado pelos Beats para enviar metricas internas |

### Roles e permissoes

O Elasticsearch usa um modelo de RBAC (Role-Based Access Control).

Roles definem permissoes sobre indices e acoes do cluster.

Exemplo de role customizada para uma aplicacao que so precisa indexar logs:

```bash
curl -X PUT "http://localhost:9200/_security/role/app-logs-writer" \
  -H "Content-Type: application/json" \
  -d '{
    "indices": [
      {
        "names":      ["logs-app-*"],
        "privileges": ["create_index", "index", "write"]
      }
    ]
  }'
```

Criando usuario e associando a role:

```bash
curl -X PUT "http://localhost:9200/_security/user/app-logs" \
  -H "Content-Type: application/json" \
  -d '{
    "password": "senha-segura-aqui",
    "roles":    ["app-logs-writer"],
    "full_name": "App Logs Service Account"
  }'
```

### TLS

Em producao, toda comunicacao deve ser encriptada.

O Elasticsearch usa TLS para:

- comunicacao entre nos do cluster (transport layer)
- comunicacao com clientes externos (HTTP layer)

Gerador de certificados integrado:

```bash
# gerar CA e certificados para os nos
./bin/elasticsearch-certutil ca
./bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12
```

---

## Performance de indexacao

### Ajustar `refresh_interval`

O `refresh_interval` define com que frequencia o Elasticsearch torna os novos documentos visiveis para buscas.

O padrao e `1s`. Reduzir ou desabilitar durante indexacao em massa melhora muito o throughput:

```bash
# desabilitar refresh durante carga em massa
PUT /meu-indice/_settings
{ "index": { "refresh_interval": "-1" } }

# reabilitar apos a carga
PUT /meu-indice/_settings
{ "index": { "refresh_interval": "1s" } }
```

### Bulk API

Em vez de enviar um documento por vez, use a Bulk API para enviar multiplos documentos em um unico request:

```bash
curl -X POST "http://localhost:9200/_bulk" \
  -H "Content-Type: application/x-ndjson" \
  --data-binary '
{"index": {"_index": "pedidos"}}
{"cliente": "Maria", "valor": 150.0, "status": "aprovado"}
{"index": {"_index": "pedidos"}}
{"cliente": "Joao", "valor": 89.90, "status": "pendente"}
{"index": {"_index": "pedidos"}}
{"cliente": "Ana", "valor": 320.0, "status": "aprovado"}
'
```

Cada par de linhas e: linha de acao (index, create, update, delete) + linha com o documento.

Tamanho recomendado por batch: entre 5MB e 15MB ou 1000 a 5000 documentos.

### Replicas durante carga inicial

Se voce esta carregando dados pela primeira vez em um indice, definir replicas como 0 durante a carga e restaurar depois pode dobrar a velocidade de indexacao:

```bash
# antes da carga
PUT /meu-indice/_settings
{ "index": { "number_of_replicas": 0 } }

# depois da carga
PUT /meu-indice/_settings
{ "index": { "number_of_replicas": 1 } }
```

---

## Performance de busca

### Use `filter` em vez de `must` para condicoes exatas

Condicoes em `filter` nao calculam score e sao cacheadas. Para filtros por status, data, categoria, etc., sempre prefira `filter`:

```bash
{
  "query": {
    "bool": {
      "must":   [ { "match": { "descricao": "notebook" } } ],
      "filter": [
        { "term":  { "status": "ativo" } },
        { "range": { "preco": { "lte": 2000 } } }
      ]
    }
  }
}
```

### Prefira `keyword` para filtros e agregacoes

Campos `text` passam por analise e nao sao adequados para filtros exatos ou agregacoes. Use o subfield `.keyword`:

```bash
# ERRADO (busca analisada, nao agrega valores exatos)
{ "aggs": { "por_status": { "terms": { "field": "status" } } } }

# CORRETO
{ "aggs": { "por_status": { "terms": { "field": "status.keyword" } } } }
```

### `_source: false` em queries de contagem

Se voce so precisa de contagem ou agregacoes, nao precisa retornar o conteudo dos documentos:

```bash
{ "size": 0, "_source": false, "aggs": { ... } }
```

### `forcemerge` em indices inativos

Indices que nao recebem mais escritas (fases warm e cold) podem ter seus segmentos compactados em um unico segmento. Isso reduz consumo de recursos:

```bash
curl -X POST "http://localhost:9200/logs-app-2024.01.01/_forcemerge?max_num_segments=1"
```

Nao execute `forcemerge` em indices ativos. Pode causar sobrecarga.

---

## Diagnostico e troubleshooting

### Cluster amarelo ou vermelho

```bash
# saude detalhada
curl -X GET "http://localhost:9200/_cluster/health?pretty"

# entender o motivo das shards nao alocadas
curl -X GET "http://localhost:9200/_cluster/allocation/explain?pretty"

# ver todas as shards com problemas
curl -X GET "http://localhost:9200/_cat/shards?v" | grep -v STARTED
```

Causas comuns de cluster amarelo:

- **Shards de replica sem no disponivel**: o cluster tem menos nos do que replicas configuradas. Com 1 no e 1 replica, a replica nao tem onde ficar.
- **No fora do cluster**: um no de dados saiu e as replicas que estavam nele precisam ser recuperadas
- **Disco cheio**: no com disco acima de 90% nao recebe novas shards (`flood stage`)

Causas comuns de cluster vermelho:

- **Shards primarias nao alocadas**: dados indisponiveis. Pode indicar perda de no sem replicas suficientes.

### Disco quase cheio

O Elasticsearch tem limiares de disco:

| Threshold | Percentual padrao | Acao |
|---|---|---|
| Low watermark | 85% | Para de alocar novas shards nesse no |
| High watermark | 90% | Comeca a mover shards para outros nos |
| Flood stage | 95% | Coloca os indices do no em modo somente leitura |

Para verificar uso de disco por no:

```bash
curl -X GET "http://localhost:9200/_cat/nodes?v&h=name,disk.used_percent,disk.avail,disk.total"
```

Se o cluster entrou em flood stage e os indices ficaram read-only, apos liberar espaco e necessario remover o bloqueio manualmente:

```bash
curl -X PUT "http://localhost:9200/nome-do-indice/_settings" \
  -H "Content-Type: application/json" \
  -d '{ "index.blocks.read_only_allow_delete": null }'
```

### Heap alto

```bash
# ver heap por no
curl -X GET "http://localhost:9200/_cat/nodes?v&h=name,heap.current,heap.max,heap.percent"
```

Se o heap estiver acima de 75% com frequencia, investigar:

- indices com mapping muito grande (muitos campos)
- fielddata habilitado em campos `text` (consume muito heap)
- agregacoes muito pesadas
- `forcemerge` nao executado em indices antigos

### Tasks lentas

```bash
# ver tasks em execucao
curl -X GET "http://localhost:9200/_tasks?detailed=true&pretty" | head -100

# ver tasks de reindex, merge, etc
curl -X GET "http://localhost:9200/_tasks?actions=*reindex*,*merge*&pretty"
```

### Slow logs

O Elasticsearch pode registrar queries e indexacoes lentas em logs especificos.

Habilitar slow log de busca para queries acima de 5 segundos:

```bash
curl -X PUT "http://localhost:9200/meu-indice/_settings" \
  -H "Content-Type: application/json" \
  -d '{
    "index.search.slowlog.threshold.query.warn":  "5s",
    "index.search.slowlog.threshold.query.info":  "2s",
    "index.search.slowlog.threshold.fetch.warn":  "1s",
    "index.search.slowlog.level": "info"
  }'
```

Os logs aparecem no arquivo `logs/<cluster_name>_index_search_slowlog.log`.

### Verificar se um documento existe e como foi indexado

```bash
# verificar se o documento existe
curl -X GET "http://localhost:9200/pedidos/_doc/abc123"

# ver como um campo foi analisado (tokenizacao)
curl -X GET "http://localhost:9200/pedidos/_analyze" \
  -H "Content-Type: application/json" \
  -d '{
    "field": "descricao",
    "text":  "Notebook Dell Inspiron"
  }'
```

O `_analyze` e muito util para entender por que uma busca esta ou nao encontrando um documento.

### Explicar o score de uma query

```bash
curl -X GET "http://localhost:9200/pedidos/_explain/abc123" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "match": { "descricao": "notebook" }
    }
  }'
```

Retorna a explicacao detalhada de como o score foi calculado para aquele documento.

---

## Glossario

| Termo | Significado |
|---|---|
| Documento | Unidade basica de dado, armazenado como JSON |
| Indice | Colecao de documentos relacionados |
| Shard | Parte de um indice; instancia independente do Lucene |
| Replica | Copia de uma shard primaria para alta disponibilidade |
| Node (No) | Instancia do Elasticsearch rodando em um servidor |
| Cluster | Conjunto de nos com o mesmo `cluster.name` |
| Master node | No responsavel por gerenciar o estado do cluster |
| Data node | No que armazena dados e processa buscas |
| Coordinating node | No que roteia requests e agrega resultados |
| Mapping | Definicao dos tipos de campos de um indice |
| Analyzer | Pipeline que processa texto (tokenizer + filters) |
| Tokenizer | Componente que quebra o texto em tokens |
| Token filter | Componente que transforma tokens (lowercase, remover stopwords) |
| Indice invertido | Estrutura que mapeia termos para documentos |
| Segment | Parte imutavel de uma shard no Lucene |
| Merge | Fusao de segmentos pequenos em segmentos maiores |
| Refresh | Torna documentos recentes visiveis para busca |
| Flush | Persiste o translog e cria novo checkpoint no disco |
| Translog | Log de operacoes de escrita para recuperacao em falhas |
| Score | Valor de relevancia de um documento para uma query |
| BM25 | Algoritmo de ranking de relevancia padrao |
| ILM | Index Lifecycle Management: gerencia hot/warm/cold/delete |
| SLM | Snapshot Lifecycle Management: automatiza backups |
| Rollover | Criacao de novo indice quando o atual atinge criterio |
| Alias | Nome virtual que aponta para um ou mais indices |
| Dynamic mapping | Inferencia automatica de tipos de campos |
| Fielddata | Cache em heap para ordenar/agregar em campos `text` (evitar) |
| Forcemerge | Compactacao manual de segmentos em indices inativos |
| Snapshot | Backup point-in-time de um ou mais indices |
| Quorum | Maioria de nos master necessaria para decisoes do cluster |
| Split-brain | Cluster dividido em dois grupos isolados (situacao de risco) |
| Flood stage | Limiar de disco (95%) que bloqueia escritas no indice |
