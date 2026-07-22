# Elasticsearch

Resumo simples de alguns conceitos basicos do Elasticsearch, com exemplos curtos para estudo.

## Sumario

- [Indice invertido](#indice-invertido)
- [Indices](#indices)
- [Shards](#shards)
- [Replicas](#replicas)
- [Mapping](#mapping)
- [Campo `flattened`](#campo-flattened)
- [Analyzer](#analyzer)
- [Tipos de analyzers](#tipos-de-analyzers)
- [Indexacao com N-grams](#indexacao-com-n-grams)
- [Queries via curl + JSON](#queries-via-curl--json)
- [Logstash](#logstash)
  - [Como funciona](#como-funciona)
  - [Estrutura de configuracao](#estrutura-de-configuracao)
  - [Inputs mais utilizados](#inputs-mais-utilizados)
  - [Filters mais utilizados](#filters-mais-utilizados)
  - [Outputs mais utilizados](#outputs-mais-utilizados)
  - [Exemplo completo de pipeline](#exemplo-completo-de-pipeline)
- [Agregacoes](#agregacoes)
  - [Como funciona uma agregacao](#como-funciona-uma-agregacao)
  - [Tipos de agregacao](#tipos-de-agregacao)
  - [Bucket aggregations](#bucket-aggregations)
  - [Metric aggregations](#metric-aggregations)
  - [Pipeline aggregations](#pipeline-aggregations)
  - [Agregacoes aninhadas](#agregacoes-aninhadas)
- [Templates de Indice](#templates-de-indice)
  - [Index Template](#index-template)
  - [Component Template](#component-template)
  - [Configuracoes importantes em um template](#configuracoes-importantes-em-um-template)
- [Alias de Indices](#alias-de-indices)
  - [Para que serve](#para-que-serve)
  - [Criando e usando aliases](#criando-e-usando-aliases)
  - [Write alias](#write-alias)
- [Rotacao de Indices](#rotacao-de-indices)
  - [Rollover](#rollover)
  - [Rollover com alias](#rollover-com-alias)
- [Ciclo de Vida dos Indices](#ciclo-de-vida-dos-indices)
  - [Fases do ILM](#fases-do-ilm)
  - [Criando uma politica de ILM](#criando-uma-politica-de-ilm)
  - [Associando a politica ao template](#associando-a-politica-ao-template)
- [Capacidade e Dimensionamento](#capacidade-e-dimensionamento)
  - [Numero de shards](#numero-de-shards)
  - [Numero de replicas](#numero-de-replicas)
  - [Boas praticas de dimensionamento](#boas-praticas-de-dimensionamento)
- [Caracteristicas de Servidor](#caracteristicas-de-servidor)
  - [Memoria RAM e Heap](#memoria-ram-e-heap)
  - [CPU](#cpu)
  - [Disco](#disco)
  - [Rede](#rede)
  - [Resumo de hardware recomendado](#resumo-de-hardware-recomendado)
- [Manutencao do Cluster](#manutencao-do-cluster)
  - [Quando usar rolling restart](#quando-usar-rolling-restart)
  - [Verificar saude antes de comecar](#verificar-saude-antes-de-comecar)
  - [Passo 1 - Parar indexacao de novos dados](#passo-1---parar-indexacao-de-novos-dados)
  - [Passo 2 - Desabilitar alocacao de shards](#passo-2---desabilitar-alocacao-de-shards)
  - [Passo 3 - Realizar flush sincronizado](#passo-3---realizar-flush-sincronizado)
  - [Passo 4 - Desativar o no e fazer manutencao](#passo-4---desativar-o-no-e-fazer-manutencao)
  - [Passo 5 - Habilitar alocacao de shards](#passo-5---habilitar-alocacao-de-shards)
  - [Passo 6 - Aguardar o cluster voltar ao verde](#passo-6---aguardar-o-cluster-voltar-ao-verde)
  - [Repetir para os demais nos](#repetir-para-os-demais-nos)
  - [Comandos de monitoramento durante a manutencao](#comandos-de-monitoramento-durante-a-manutencao)
  - [Exemplos praticos](#exemplos-praticos)

## Indice invertido

O indice invertido e a estrutura usada pelo Elasticsearch para procurar texto com rapidez.

Em vez de guardar apenas o documento completo, ele organiza os termos e registra em quais documentos cada termo aparece.

### Exemplo

Documentos:

- Documento 1: `gato preto`
- Documento 2: `gato branco`

Visao simplificada do indice invertido:

```text
gato -> doc1, doc2
preto -> doc1
branco -> doc2
```

Se a busca for por `gato`, o Elasticsearch encontra rapidamente os documentos `doc1` e `doc2`.

## Indices

Um indice e o lugar onde os documentos ficam armazenados e organizados.

Uma forma simples de pensar nele e como uma colecao de documentos do mesmo assunto.

### Exemplo

- Indice `clientes`: documentos de clientes
- Indice `pedidos`: documentos de pedidos

Exemplo de documento no indice `clientes`:

```json
{
  "nome": "Maria",
  "idade": 32,
  "cidade": "Sao Paulo"
}
```

## Shards

Shards sao partes de um indice.

O Elasticsearch divide um indice em varias partes para distribuir armazenamento e processamento entre diferentes nos.

### Exemplo

Se o indice `pedidos` tiver 3 shards, os documentos ficam distribuídos entre essas 3 partes.

```text
indice pedidos
- shard 1 -> parte dos documentos
- shard 2 -> parte dos documentos
- shard 3 -> parte dos documentos
```

Isso ajuda a escalar o ambiente e distribuir a carga de consulta.

## Replicas

Replicas sao copias das shards principais.

Elas servem para aumentar a disponibilidade dos dados e tambem ajudar no processamento de leitura.

### Exemplo

Se um indice tiver:

- 1 shard principal
- 1 replica

Entao existirao 2 copias daquela shard:

- 1 principal
- 1 replica

Se a principal falhar, a replica pode assumir.

## Mapping

Mapping define a estrutura dos campos de um documento.

Ele informa ao Elasticsearch qual e o tipo de cada campo, por exemplo texto, numero, data ou boolean.

### Exemplo

```json
{
  "mappings": {
    "properties": {
      "nome": { "type": "text" },
      "idade": { "type": "integer" },
      "criado_em": { "type": "date" }
    }
  }
}
```

Nesse exemplo:

- `nome` e texto
- `idade` e inteiro
- `criado_em` e data

### Erro de mapping exception

Esse erro pode acontecer quando o tipo definido no mapping nao combina com o valor enviado no documento.

Em outras palavras, o campo foi configurado com um tipo, mas o documento chegou com outro tipo diferente.

### Exemplo

Se o mapping tiver:

```json
{
  "idade": { "type": "integer" }
}
```

E o documento enviado for:

```json
{
  "idade": "trinta"
}
```

O Elasticsearch pode retornar erro como:

```text
mapper_parsing_exception
Failed to parse field [idade] of type [integer] in document with id [xpto]
```

### Possivel contorno

Uma configuracao que pode ajudar em alguns casos e:

```json
{
  "settings": {
    "index.mapping.ignore_malformed": true
  }
}
```

Isso faz o Elasticsearch ignorar alguns valores malformados, em vez de falhar o documento inteiro.

### Limitacao importante

Esse contorno nem sempre resolve.

Ainda pode haver erro, dependendo do tipo do campo, da estrutura do documento ou do tipo de inconsistencia enviado.

Entao, a melhor pratica continua sendo garantir que o documento respeite o mapping esperado.

### Limite padrao de campos

Por padrao, existe um limite total de campos no mapping do indice. Um valor comum e `1000`.

Quando esse limite e ultrapassado, pode ocorrer erro como:

```text
illegal_argument_exception
Limit of total fields [1000] has been exceeded
```

Isso costuma acontecer quando o indice recebe muitos campos diferentes, especialmente em cenarios com JSON dinamico.

### Possivel contorno

Uma configuracao possivel e aumentar o limite:

```json
{
  "settings": {
    "index.mapping.total_fields.limit": 1100
  }
}
```

### Cuidado pratico

Aumentar esse limite pode contornar o erro no curto prazo, mas nao corrige a causa raiz.

Se o documento continua criando campos demais, o problema pode voltar.

Nesses casos, vale revisar:

- se ha campos dinamicos demais
- se `flattened` faz mais sentido para parte da estrutura
- se o mapping dinamico precisa ser controlado melhor

## Campo `flattened`

`flattened` e um tipo de campo usado para guardar objetos JSON com muitas chaves dinamicas.

Ele e util quando a estrutura do objeto pode mudar bastante e voce nao quer que cada chave interna vire um campo separado no mapping.

Na pratica, ele ajuda a evitar explosao de campos.

### Quando usar

- quando o documento tem muitos atributos variaveis
- quando as chaves mudam de um documento para outro
- quando voce quer pesquisar valores sem detalhar toda a estrutura no mapping

### Exemplo

Imagine um documento com metadados variaveis:

```json
{
  "nome": "produto-a",
  "atributos": {
    "cor": "azul",
    "tamanho": "M",
    "origem": "brasil"
  }
}
```

O mapping pode ser:

```json
{
  "mappings": {
    "properties": {
      "nome": { "type": "keyword" },
      "atributos": { "type": "flattened" }
    }
  }
}
```

Nesse caso, `atributos` e tratado como um objeto flexivel, sem precisar mapear `cor`, `tamanho` e `origem` separadamente.

### Exemplo de consulta

Voce pode consultar uma chave interna assim:

```json
{
  "query": {
    "term": {
      "atributos.cor": "azul"
    }
  }
}
```

### Vantagem principal

Evita criar muitos campos no mapping quando os dados sao muito variaveis.

### Limitacao importante

`flattened` e bom para flexibilidade, mas nao tem o mesmo comportamento rico de um objeto mapeado campo a campo.

Os campos internos de um `flattened` sao tratados de forma parecida com `keyword`.

Isso significa que a busca e mais literal e orientada a valor exato, sem a analise de texto que acontece em campos `text`.

Por isso, ele resolve bem cenarios de metadados dinamicos, mas nao substitui todos os tipos tradicionais quando voce precisa de analises mais detalhadas.

### O que isso muda na busca

Se voce tiver:

```json
{
  "atributos": {
    "cor": "azul escuro"
  }
}
```

Uma consulta por valor exato pode funcionar bem:

```json
{
  "query": {
    "term": {
      "atributos.cor": "azul escuro"
    }
  }
}
```

Mas ele nao foi feito para o mesmo tipo de busca textual mais flexivel de um campo `text`, como quebrar a frase em varios termos ou aplicar analyzer.

Entao, ao usar `flattened`, pense mais em busca de chave/valor e menos em busca textual rica.

## Analyzer

Analyzer e o mecanismo usado para preparar um texto antes de indexar e tambem durante a busca.

De forma simples, ele pode:

- quebrar o texto em partes menores
- transformar tudo em minusculo
- remover palavras muito comuns, dependendo da configuracao
- aplicar regras do idioma

### Exemplo

Texto original:

```text
O Produto e Muito Bom
```

Depois da analise, os termos podem ficar parecidos com:

```text
produto
muito
bom
```

Isso ajuda a busca a encontrar resultados mesmo quando o texto digitado nao esta identico ao original.

### Exemplo de mapping com analyzer

```json
{
  "mappings": {
    "properties": {
      "titulo": {
        "type": "text",
        "analyzer": "standard"
      }
    }
  }
}
```

## Tipos de analyzers

O Elasticsearch tem analyzers prontos e tambem permite criar analyzers customizados.

### `standard`

E o analyzer padrao do Elasticsearch.

Ele separa o texto em termos de forma geral e costuma funcionar bem para texto comum.

**Exemplo:**

```text
"Busca no Elasticsearch"
```

Pode virar:

```text
busca
no
elasticsearch
```

### `simple`

Divide o texto usando caracteres nao alfabeticos e converte para minusculo.

**Exemplo:**

```text
"Produto-123 Novo"
```

Pode virar:

```text
produto
novo
```

O numero `123` nao entra como termo.

### `whitespace`

Divide o texto apenas pelos espacos.

**Exemplo:**

```text
"erro-api timeout"
```

Pode virar:

```text
erro-api
timeout
```

O hifen continua dentro do termo porque a separacao foi feita apenas por espaco.

### `stop`

Parecido com o analyzer simples, mas remove palavras muito comuns, chamadas de stop words.

**Exemplo:**

```text
"o sistema esta no ar"
```

Pode virar algo como:

```text
sistema
esta
ar
```

### `keyword`

Nao quebra o texto. O valor inteiro vira um unico termo.

Esse caso e util quando voce quer busca exata, filtro ou agregacao.

Na busca, campos `keyword` funcionam melhor quando voce procura o valor inteiro exatamente como ele foi indexado.

Ou seja, em vez de procurar partes do texto, o Elasticsearch compara o termo completo.

**Exemplo:**

```text
"pedido-123-final"
```

Fica como:

```text
pedido-123-final
```

### Como pesquisar em `keyword`

O mais comum e usar consultas como `term` para bater exatamente com o valor gravado.

**Exemplo:**

```json
{
  "query": {
    "term": {
      "codigo_pedido": "pedido-123-final"
    }
  }
}
```

Esse tipo de consulta funciona bem para:

- IDs
- codigos
- status
- nomes curtos padronizados
- campos usados em filtro e agregacao

Se o valor salvo for `pedido-123-final`, buscar apenas por `pedido` nao encontra resultado em uma consulta exata de `keyword`.

Para buscas parciais ou mais livres, normalmente o tipo mais adequado e `text`.

### Analyzers de idioma

Existem analyzers prontos para alguns idiomas, como ingles.

Eles aplicam regras especificas do idioma, como remocao de palavras comuns e reducao de palavras ao radical.

**Exemplo em ingles:**

```text
"running services"
```

Pode gerar termos proximos de:

```text
run
servic
```

### Custom analyzer

Voce tambem pode montar um analyzer customizado combinando:

- `tokenizer`
- `filters`
- `char_filters`

**Exemplo:**

```json
{
  "settings": {
    "analysis": {
      "analyzer": {
        "meu_analyzer": {
          "type": "custom",
          "tokenizer": "standard",
          "filter": ["lowercase", "asciifolding"]
        }
      }
    }
  }
}
```

Nesse caso:

- `lowercase` transforma em minusculo
- `asciifolding` ajuda a remover acentos

## Indexacao com N-grams

N-grams sao pequenos pedaços de texto gerados a partir de uma palavra.

Eles sao usados quando voce quer permitir buscas parciais, autocomplete ou match de trechos menores.

Em vez de indexar apenas a palavra inteira, o Elasticsearch pode indexar varias partes dela.

### Exemplo simples

Suponha a palavra:

```text
casa
```

Dependendo da configuracao, ela pode ser quebrada em varios grupos menores.

### `unigram`

Unigram significa grupos de 1 caractere.

Exemplo com `casa`:

```text
c
a
s
a
```

### `bigram`

Bigram significa grupos de 2 caracteres.

Exemplo com `casa`:

```text
ca
as
sa
```

### `trigram`

Trigram significa grupos de 3 caracteres.

Exemplo com `casa`:

```text
cas
asa
```

### `4-gram`

4-gram significa grupos de 4 caracteres.

Exemplo com `casa`:

```text
casa
```

Se a palavra fosse maior, haveria mais combinacoes.

### `edge n-gram`

`edge n-gram` gera pedaços a partir do inicio da palavra.

Isso e muito comum em cenarios de autocomplete.

Exemplo com `casa`:

```text
c
ca
cas
casa
```

Diferenca simples:

- `n-gram`: gera pedaços em varias posicoes da palavra
- `edge n-gram`: gera pedaços a partir do inicio

### Quando isso e util

Esse tipo de indexacao costuma ser util quando voce precisa de:

- autocomplete
- busca enquanto o usuario digita
- busca parcial por trechos da palavra
- experiencias de pesquisa mais tolerantes em nomes, produtos ou termos curtos

### Quando usar com cuidado

N-grams aumentam a quantidade de termos indexados.

Na pratica, isso pode:

- aumentar o tamanho do indice
- elevar custo de indexacao
- trazer mais ruido em buscas se a configuracao for muito aberta

Por isso, eles sao uteis, mas precisam de configuracao cuidadosa.

### Exemplo de analyzer para autocomplete

Para usar autocomplete, normalmente isso precisa ser configurado na criacao do indice, dentro de `settings.analysis`.

Exemplo com `edge_ngram`:

```json
{
  "settings": {
    "analysis": {
      "filter": {
        "autocomplete_filter": {
          "type": "edge_ngram",
          "min_gram": 1,
          "max_gram": 20
        }
      },
      "analyzer": {
        "autocomplete": {
          "type": "custom",
          "tokenizer": "standard",
          "filter": ["lowercase", "asciifolding", "autocomplete_filter"]
        },
        "autocomplete_search": {
          "type": "custom",
          "tokenizer": "standard",
          "filter": ["lowercase", "asciifolding"]
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "nome": {
        "type": "text",
        "analyzer": "autocomplete",
        "search_analyzer": "autocomplete_search"
      }
    }
  }
}
```

### Como isso funciona

Nesse exemplo:

- `autocomplete` e o analyzer usado na indexacao
- `autocomplete_search` e o analyzer usado na busca
- `edge_ngram` gera prefixos a partir do inicio do termo
- `search_analyzer` evita que a busca tambem seja quebrada em muitos pedacos

Se o valor indexado for:

```text
notebook
```

O analyzer de indexacao pode gerar termos como:

```text
n
no
not
note
noteb
notebo
noteboo
notebook
```

Assim, uma busca por `not`, `note` ou `noteb` pode encontrar o documento.

### Exemplo de criacao de indice

```bash
curl -X PUT "http://localhost:9200/produtos_autocomplete" \
  -H "Content-Type: application/json" \
  -d '{
    "settings": {
      "analysis": {
        "filter": {
          "autocomplete_filter": {
            "type": "edge_ngram",
            "min_gram": 1,
            "max_gram": 20
          }
        },
        "analyzer": {
          "autocomplete": {
            "type": "custom",
            "tokenizer": "standard",
            "filter": ["lowercase", "asciifolding", "autocomplete_filter"]
          },
          "autocomplete_search": {
            "type": "custom",
            "tokenizer": "standard",
            "filter": ["lowercase", "asciifolding"]
          }
        }
      }
    },
    "mappings": {
      "properties": {
        "nome": {
          "type": "text",
          "analyzer": "autocomplete",
          "search_analyzer": "autocomplete_search"
        }
      }
    }
  }'
```

### Exemplo de busca

Depois disso, uma busca simples pode ser:

```bash
curl -X GET "http://localhost:9200/produtos_autocomplete/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "match": {
        "nome": "noteb"
      }
    }
  }'
```

### Resumo pratico

- `unigram`, `bigram`, `trigram` e `4-gram` quebram a palavra em grupos de tamanho fixo
- `edge n-gram` gera prefixos e costuma ser melhor para autocomplete
- isso precisa ser configurado no analyzer durante a criacao do indice
- e util para busca parcial, mas aumenta custo e tamanho do indice

## Queries via curl + JSON

No Elasticsearch, uma forma muito comum de consultar dados e usar `curl` enviando um JSON no corpo da requisicao.

O endpoint mais usado para isso e o `_search`.

### Estrutura basica

Exemplo simples:

```bash
curl -X GET "http://localhost:9200/produtos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "match_all": {}
    }
  }'
```

Nesse exemplo:

- `produtos` e o indice
- `_search` executa a busca
- o JSON define a consulta

### `match`

`match` e usado principalmente para campos `text`.

Ele analisa o texto informado antes de pesquisar. Por isso, funciona bem para buscas mais livres.

**Exemplo:**

```bash
curl -X GET "http://localhost:9200/produtos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "match": {
        "descricao": "tenis corrida"
      }
    }
  }'
```

Se `descricao` for um campo `text`, o Elasticsearch pode quebrar esse valor em termos e procurar documentos relacionados a `tenis` e `corrida`.

### Fuzzy matches

Fuzzy match e uma forma de busca aproximada.

Ele ajuda quando a palavra pesquisada tem pequeno erro de digitacao ou uma variacao simples em relacao ao valor indexado.

Essa ideia usa a distancia de Levenshtein.

De forma simples, ela mede quantas mudancas sao necessarias para transformar uma palavra em outra.

A distancia trata principalmente:

- substituicao de caracteres
- inclusao de caracteres
- exclusao de caracteres

### Exemplo simples

Suponha que o valor correto indexado seja:

```text
notebook
```

E a busca seja por:

```text
notbok
```

Nesse caso, ha uma pequena diferenca entre as palavras, e a busca fuzzy pode ainda assim encontrar o documento.

Outro exemplo:

- valor indexado: `camiseta`
- termo pesquisado: `camissta`

Aqui houve uma substituicao ou ausencia de caractere em relacao ao termo original, e a busca fuzzy pode ajudar.

### Query com `fuzziness`

Um exemplo com `match` e `fuzziness`:

```bash
curl -X GET "http://localhost:9200/produtos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "match": {
        "descricao": {
          "query": "notbok",
          "fuzziness": "AUTO"
        }
      }
    }
  }'
```

Nesse caso:

- `query` e o texto buscado
- `fuzziness` define o nivel de tolerancia para diferencas
- `AUTO` faz o Elasticsearch ajustar essa tolerancia de forma automatica

### Observacao pratica

Fuzzy match e util para erros pequenos de digitacao, mas nao deve ser usado como substituto de qualquer tipo de busca.

Se a diferenca entre os termos for muito grande, ou se o campo exigir busca exata, outras abordagens podem fazer mais sentido.

### `wildcard`

`wildcard` permite pesquisar usando curingas.

Os caracteres mais comuns sao:

- `*`: representa zero ou varios caracteres
- `?`: representa exatamente um caractere

Esse tipo de busca costuma ser usado em campos mais parecidos com `keyword`, quando voce quer casar padroes simples.

**Exemplo:**

```bash
curl -X GET "http://localhost:9200/produtos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "wildcard": {
        "codigo": {
          "value": "prod-*"
        }
      }
    }
  }'
```

Esse exemplo pode encontrar valores como:

- `prod-001`
- `prod-abc`
- `prod-xpto`

### `prefix`

`prefix` procura valores que comecam com um determinado trecho.

Ele e uma forma mais simples e objetiva de buscar por inicio de valor.

**Exemplo:**

```bash
curl -X GET "http://localhost:9200/produtos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "prefix": {
        "codigo": "prod"
      }
    }
  }'
```

Esse exemplo pode retornar valores como:

- `prod001`
- `produto-a`
- `prod-x`

### `regexp`

`regexp` permite pesquisar usando expressao regular.

Ela oferece mais flexibilidade que `wildcard`, mas tambem pode ser mais cara em desempenho.

**Exemplo:**

```bash
curl -X GET "http://localhost:9200/produtos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "regexp": {
        "codigo": "prod-[0-9]+"
      }
    }
  }'
```

Esse exemplo pode encontrar valores como:

- `prod-1`
- `prod-22`
- `prod-999`

### Observacao pratica

Consultas `wildcard`, `prefix` e `regexp` podem ser uteis, mas devem ser usadas com cuidado.

Em geral:

- `prefix` tende a ser mais simples
- `wildcard` e bom para padroes com curingas
- `regexp` e o mais flexivel, mas tambem costuma ser o mais pesado

Quando possivel, vale preferir consultas mais objetivas, principalmente em indices grandes.

### `match_phrase`

O nome correto da consulta e `match_phrase`.

Ela e usada quando voce quer encontrar os termos na mesma ordem da frase informada.

**Exemplo:**

```bash
curl -X GET "http://localhost:9200/produtos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "match_phrase": {
        "descricao": "tenis corrida"
      }
    }
  }'
```

Aqui, a busca fica mais restrita do que em `match`, porque tenta encontrar a frase como uma sequencia.

### `slop`

`slop` e um ajuste usado com `match_phrase`.

Ele permite uma pequena flexibilidade na distancia entre os termos.

**Exemplo:**

```bash
curl -X GET "http://localhost:9200/produtos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "match_phrase": {
        "descricao": {
          "query": "tenis corrida",
          "slop": 2
        }
      }
    }
  }'
```

Com isso, o Elasticsearch aceita pequenas variacoes entre as palavras.

Por exemplo, algo como `tenis de corrida` pode combinar mesmo sem ser exatamente a frase original.

### `bool`

`bool` serve para combinar varias condicoes na mesma consulta.

Os blocos mais comuns sao:

- `must`: deve atender
- `should`: deveria atender, ajuda na relevancia
- `must_not`: nao pode atender
- `filter`: filtra sem influenciar score

**Exemplo:**

```bash
curl -X GET "http://localhost:9200/produtos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "bool": {
        "must": [
          {
            "match": {
              "descricao": "tenis"
            }
          }
        ],
        "filter": [
          {
            "term": {
              "categoria": "esporte"
            }
          }
        ],
        "must_not": [
          {
            "term": {
              "status": "inativo"
            }
          }
        ]
      }
    }
  }'
```

Essa consulta significa:

- o texto `tenis` precisa aparecer em `descricao`
- `categoria` precisa ser `esporte`
- `status` nao pode ser `inativo`

### `filter`

`filter` e muito usado para condicoes exatas, como:

- status
- categoria
- data
- ambiente
- codigo

Ele e parecido com uma restricao de filtro. A principal ideia e que ele nao participa do calculo de relevancia da busca.

Por isso, costuma ser uma boa escolha para filtros objetivos.

**Exemplo:**

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "bool": {
        "filter": [
          {
            "term": {
              "status": "aprovado"
            }
          },
          {
            "range": {
              "valor_total": {
                "gte": 100
              }
            }
          }
        ]
      }
    }
  }'
```

Nesse caso:

- `status` precisa ser `aprovado`
- `valor_total` precisa ser maior ou igual a `100`

### `must` x `filter`

Uma forma simples de diferenciar:

- `must`: entra na logica da busca e pode influenciar score
- `filter`: restringe o resultado, mas sem foco em score

Na pratica:

- use `must` quando a condicao faz parte da relevancia textual
- use `filter` quando a condicao e objetiva e exata

### Exemplo mais completo

```bash
curl -X GET "http://localhost:9200/produtos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "bool": {
        "must": [
          {
            "match": {
              "descricao": "tenis corrida"
            }
          }
        ],
        "filter": [
          {
            "term": {
              "marca": "nike"
            }
          },
          {
            "range": {
              "preco": {
                "lte": 500
              }
            }
          }
        ],
        "should": [
          {
            "match_phrase": {
              "descricao": {
                "query": "tenis corrida",
                "slop": 1
              }
            }
          }
        ],
        "must_not": [
          {
            "term": {
              "status": "indisponivel"
            }
          }
        ]
      }
    }
  }'
```

Leitura simples desse exemplo:

- busca produtos relacionados a `tenis corrida`
- filtra apenas a marca `nike`
- filtra preco ate `500`
- favorece resultados onde a frase aparece mais proxima
- remove produtos indisponiveis

## Logstash

Logstash e uma ferramenta de coleta, transformacao e envio de dados.

Ele faz parte do Elastic Stack (ELK) e seu papel principal e receber dados de diferentes fontes, processar esses dados e enviá-los para um ou mais destinos.

Na pratica, o Logstash atua como um pipeline de dados entre a origem e o destino.

Casos de uso comuns:

- receber logs de aplicacoes e enviar para o Elasticsearch
- transformar campos antes de indexar
- filtrar eventos que nao devem ser armazenados
- enriquecer logs com informacoes extras
- consumir mensagens de filas como Kafka

## Como funciona

O Logstash funciona como um pipeline com tres etapas:

```text
[input] -> [filter] -> [output]
```

- `input`: de onde vem o dado
- `filter`: o que fazer com o dado antes de enviar
- `output`: para onde o dado vai

Cada etapa pode ter um ou mais plugins configurados.

O Logstash processa os dados em eventos. Cada linha de log, mensagem ou registro que entra no pipeline vira um evento e percorre as tres etapas.

## Estrutura de configuracao

A configuracao do Logstash e feita em um arquivo `.conf` com a seguinte estrutura:

```ruby
input {
  # de onde vem o dado
}

filter {
  # como transformar o dado
}

output {
  # para onde enviar o dado
}
```

Exemplo minimo funcional:

```ruby
input {
  stdin {}
}

filter {
  mutate {
    add_field => { "ambiente" => "producao" }
  }
}

output {
  stdout { codec => rubydebug }
}
```

Nesse exemplo:

- o input le dados da entrada padrao (teclado)
- o filter adiciona um campo `ambiente` com valor `producao`
- o output imprime o evento formatado no terminal

## Inputs mais utilizados

### `file`

Le linhas de um ou mais arquivos em disco. Muito usado para consumir logs de arquivo gerados por aplicacoes.

```ruby
input {
  file {
    path => "/var/log/app/*.log"
    start_position => "beginning"
    sincedb_path => "/dev/null"
  }
}
```

- `path`: caminho do arquivo ou padrao glob
- `start_position`: `beginning` le desde o inicio, `end` le apenas novos registros
- `sincedb_path`: arquivo que guarda posicao de leitura; `/dev/null` faz comecar do zero sempre

### `beats`

Recebe eventos enviados pelo Filebeat, Metricbeat ou outros agentes do tipo Beats.

```ruby
input {
  beats {
    port => 5044
  }
}
```

E o input mais comum em ambientes com Filebeat coletando logs de pods ou servidores.

### `kafka`

Consome mensagens de um topico Kafka.

```ruby
input {
  kafka {
    bootstrap_servers => "kafka:9092"
    topics => ["logs-app"]
    group_id => "logstash-consumer"
    codec => "json"
  }
}
```

- `bootstrap_servers`: endereco do broker Kafka
- `topics`: lista de topicos a consumir
- `group_id`: identificador do grupo de consumo
- `codec`: formato esperado da mensagem

### `http`

Expoe um endpoint HTTP para receber eventos via requisicao POST.

```ruby
input {
  http {
    host => "0.0.0.0"
    port => 8080
    codec => "json"
  }
}
```

### `stdin`

Le dados da entrada padrao. Util para testes e depuracao local.

```ruby
input {
  stdin {}
}
```

### `tcp` / `udp`

Recebe eventos por conexao TCP ou UDP. Usado em integrações com syslog ou ferramentas que enviam logs por rede.

```ruby
input {
  tcp {
    port => 5000
    codec => "json_lines"
  }
}
```

### `jdbc`

Faz consultas periodicas em bancos de dados relacionais via JDBC. Util para sincronizar dados de banco com Elasticsearch.

```ruby
input {
  jdbc {
    jdbc_connection_string => "jdbc:mysql://localhost:3306/meudb"
    jdbc_user => "usuario"
    jdbc_password => "senha"
    jdbc_driver_library => "/opt/drivers/mysql-connector.jar"
    jdbc_driver_class => "com.mysql.jdbc.Driver"
    statement => "SELECT * FROM pedidos WHERE atualizado_em > :sql_last_value"
    schedule => "*/5 * * * *"
  }
}
```

## Filters mais utilizados

### `grok`

E o filter mais usado. Ele analisa texto nao estruturado usando padroes e extrai campos.

Muito usado para parsear logs no formato de linha unica com campos misturados.

```ruby
filter {
  grok {
    match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:nivel} %{GREEDYDATA:mensagem}" }
  }
}
```

Nesse exemplo, a linha de log:

```text
2024-01-15T10:30:00 ERROR conexao recusada pelo banco
```

Gera os campos:

- `timestamp`: `2024-01-15T10:30:00`
- `nivel`: `ERROR`
- `mensagem`: `conexao recusada pelo banco`

O Logstash tem varios padroes prontos como `%{IP}`, `%{NUMBER}`, `%{WORD}`, `%{URI}`, etc.

### `mutate`

Transforma campos: renomear, remover, adicionar, converter tipo, substituir valor.

```ruby
filter {
  mutate {
    rename => { "host" => "servidor" }
    remove_field => ["agent", "ecs", "@version"]
    add_field => { "ambiente" => "producao" }
    convert => { "status_code" => "integer" }
    uppercase => ["nivel"]
  }
}
```

### `date`

Parsa um campo como data e define como o timestamp oficial do evento (`@timestamp`).

```ruby
filter {
  date {
    match => ["timestamp", "ISO8601", "dd/MMM/yyyy:HH:mm:ss Z"]
    target => "@timestamp"
    timezone => "America/Sao_Paulo"
  }
}
```

Sem esse filter, o `@timestamp` fica com o horario de ingestao, nao o horario real do log.

### `json`

Faz o parse de um campo que contem JSON em string, transformando em campos separados.

```ruby
filter {
  json {
    source => "message"
    target => "log"
  }
}
```

Se `message` contiver:

```json
{"nivel": "ERROR", "servico": "pagamentos", "latencia": 320}
```

O filter cria os campos `log.nivel`, `log.servico` e `log.latencia`.

### `dissect`

Alternativa mais rapida ao `grok` para logs com formato fixo e bem delimitado.

```ruby
filter {
  dissect {
    mapping => {
      "message" => "%{timestamp} %{nivel} %{+mensagem}"
    }
  }
}
```

Nao usa regex, entao e mais eficiente para formatos previsíveis.

### `drop`

Descarta eventos que atendem a uma condicao. Util para filtrar logs de saude, metricas internas ou eventos desnecessários.

```ruby
filter {
  if [nivel] == "DEBUG" {
    drop {}
  }
}
```

### `ruby`

Permite executar codigo Ruby arbitrario dentro do pipeline. Util para logica customizada que outros filters nao cobrem.

```ruby
filter {
  ruby {
    code => "
      event.set('latencia_segundos', event.get('latencia_ms').to_f / 1000)
    "
  }
}
```

### `aggregate`

Agrega multiplos eventos de uma mesma transacao em um unico evento. Usado em cenarios de correlacao de logs por ID de requisicao.

```ruby
filter {
  aggregate {
    task_id => "%{request_id}"
    code => "map['duracao_total'] ||= 0; map['duracao_total'] += event.get('duracao').to_i"
    push_map_as_event_on_timeout => true
    timeout => 30
  }
}
```

### `useragent`

Parsea um campo de user agent HTTP e extrai informacoes como browser, sistema operacional e dispositivo.

```ruby
filter {
  useragent {
    source => "agent"
    target => "ua"
  }
}
```

### `geoip`

Enriquece um campo de IP com informacoes de localizacao geografica.

```ruby
filter {
  geoip {
    source => "ip_cliente"
    target => "geo"
  }
}
```

## Outputs mais utilizados

### `elasticsearch`

E o output mais comum. Envia os eventos para um indice no Elasticsearch.

```ruby
output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    index => "logs-app-%{+YYYY.MM.dd}"
    user => "elastic"
    password => "senha"
  }
}
```

- `index`: nome do indice, podendo usar variaveis de data
- `user` / `password`: credenciais quando a autenticacao esta ativa

### `stdout`

Imprime os eventos no terminal. Muito usado para depuracao.

```ruby
output {
  stdout { codec => rubydebug }
}
```

`rubydebug` formata o evento de forma legivel com todos os campos.

### `kafka`

Publica os eventos em um topico Kafka. Util quando o Logstash e um produtor de mensagens.

```ruby
output {
  kafka {
    bootstrap_servers => "kafka:9092"
    topic_id => "logs-processados"
    codec => "json"
  }
}
```

### `file`

Grava os eventos em um arquivo. Util para arquivamento ou auditoria.

```ruby
output {
  file {
    path => "/tmp/saida-%{+YYYY-MM-dd}.log"
    codec => line { format => "%{message}" }
  }
}
```

### `http`

Envia os eventos para um endpoint HTTP via POST. Util para integrar com webhooks ou APIs externas.

```ruby
output {
  http {
    url => "https://api.interna/eventos"
    http_method => "post"
    format => "json"
    headers => {
      "Authorization" => "Bearer ${API_TOKEN}"
    }
  }
}
```

## Exemplo completo de pipeline

Um pipeline realista recebendo logs do Filebeat, parseando, transformando e enviando ao Elasticsearch:

```ruby
input {
  beats {
    port => 5044
  }
}

filter {
  # parsear a mensagem de log
  grok {
    match => {
      "message" => "%{TIMESTAMP_ISO8601:log_timestamp} %{LOGLEVEL:nivel} \\[%{DATA:servico}\\] %{GREEDYDATA:log_mensagem}"
    }
  }

  # usar o timestamp do log como @timestamp
  date {
    match => ["log_timestamp", "ISO8601"]
    target => "@timestamp"
    timezone => "America/Sao_Paulo"
  }

  # descarta logs de debug para nao sobrecarregar o indice
  if [nivel] == "DEBUG" {
    drop {}
  }

  # limpa campos desnecessarios
  mutate {
    remove_field => ["agent", "ecs", "@version", "log_timestamp"]
    uppercase => ["nivel"]
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    index => "logs-app-%{+YYYY.MM.dd}"
    user => "elastic"
    password => "${ES_PASSWORD}"
  }

  # saida de debug pode ser desabilitada em producao
  # stdout { codec => rubydebug }
}
```

Fluxo desse pipeline:

1. Filebeat envia logs para a porta 5044
2. `grok` extrai `timestamp`, `nivel`, `servico` e `mensagem`
3. `date` ajusta o `@timestamp` para o horario real do log
4. logs `DEBUG` sao descartados
5. `mutate` remove campos e padroniza o nivel
6. o evento e indexado no Elasticsearch com indice diario

## Agregacoes

Agregacoes sao consultas que resumem, agrupam e calculam metricas sobre um conjunto de documentos.

Em vez de retornar os documentos individuais, uma agregacao responde perguntas como:

- quantos pedidos existem por status?
- qual e o valor medio de venda por dia?
- quais sao os 10 produtos mais vendidos?
- qual e o total de erros por servico na ultima hora?

Isso torna as agregacoes fundamentais para analise de dados, dashboards e monitoramento.

## Como funciona uma agregacao

Uma agregacao e enviada junto com a consulta, dentro do campo `aggs` (ou `aggregations`).

Estrutura basica:

```json
{
  "query": { ... },
  "aggs": {
    "nome_da_agregacao": {
      "tipo_de_agregacao": {
        "field": "nome_do_campo"
      }
    }
  }
}
```

- `query`: filtra os documentos que serao agregados (opcional)
- `aggs`: define as agregacoes
- `nome_da_agregacao`: nome livre que identifica o resultado
- `tipo_de_agregacao`: o tipo, como `terms`, `avg`, `sum`, etc.
- `field`: o campo sobre o qual a agregacao atua

O campo `size: 0` e frequentemente usado junto para nao retornar documentos individuais, apenas o resultado da agregacao:

```json
{
  "size": 0,
  "aggs": {
    "por_status": {
      "terms": {
        "field": "status"
      }
    }
  }
}
```

## Tipos de agregacao

Existem tres grandes categorias:

- **Bucket**: agrupa documentos em baldes (buckets) com base em valores, intervalos ou datas
- **Metric**: calcula metricas numericas sobre os documentos, como soma, media ou maximo
- **Pipeline**: opera sobre o resultado de outras agregacoes

## Bucket aggregations

Agregacoes do tipo bucket dividem os documentos em grupos.

### `terms`

Agrupa documentos por valor unico de um campo. Muito usado para contar ocorrencias por categoria.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "por_status": {
        "terms": {
          "field": "status",
          "size": 10
        }
      }
    }
  }'
```

Resultado esperado:

```json
{
  "aggregations": {
    "por_status": {
      "buckets": [
        { "key": "aprovado",  "doc_count": 4200 },
        { "key": "pendente",  "doc_count": 830  },
        { "key": "cancelado", "doc_count": 210  }
      ]
    }
  }
}
```

- `key`: o valor do campo
- `doc_count`: quantos documentos tem esse valor
- `size`: quantos buckets retornar (padrão 10)

### `date_histogram`

Agrupa documentos por intervalos de tempo. Fundamental para graficos de serie temporal.

```bash
curl -X GET "http://localhost:9200/logs/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "erros_por_hora": {
        "date_histogram": {
          "field": "@timestamp",
          "calendar_interval": "1h",
          "time_zone": "America/Sao_Paulo"
        }
      }
    }
  }'
```

Opções comuns para `calendar_interval`: `minute`, `hour`, `day`, `week`, `month`.

Também é possível usar `fixed_interval` para intervalos exatos: `10m`, `30m`, `6h`.

### `range`

Agrupa documentos em faixas de valores numericos definidas manualmente.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "faixas_de_valor": {
        "range": {
          "field": "valor_total",
          "ranges": [
            { "to": 100 },
            { "from": 100, "to": 500 },
            { "from": 500 }
          ]
        }
      }
    }
  }'
```

Resultado agrupa pedidos em: abaixo de 100, entre 100 e 500, acima de 500.

### `filter` e `filters`

`filter` cria um unico bucket com os documentos que atendem a uma condicao.

```bash
curl -X GET "http://localhost:9200/logs/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "apenas_erros": {
        "filter": {
          "term": { "nivel": "ERROR" }
        }
      }
    }
  }'
```

`filters` cria varios buckets nomeados, um por condicao:

```bash
curl -X GET "http://localhost:9200/logs/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "por_nivel": {
        "filters": {
          "filters": {
            "erros":      { "term": { "nivel": "ERROR" } },
            "avisos":     { "term": { "nivel": "WARN"  } },
            "informativos": { "term": { "nivel": "INFO"  } }
          }
        }
      }
    }
  }'
```

### `histogram`

Semelhante ao `range`, mas com intervalos de tamanho fixo e automatico.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "distribuicao_valor": {
        "histogram": {
          "field": "valor_total",
          "interval": 100
        }
      }
    }
  }'
```

Agrupa automaticamente em faixas de 100 em 100: 0-100, 100-200, 200-300, etc.

### `cardinality`

Nao e estritamente um bucket, mas conta valores unicos de um campo. Equivalente ao `COUNT DISTINCT` em SQL.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "clientes_unicos": {
        "cardinality": {
          "field": "cliente_id"
        }
      }
    }
  }'
```

Retorna o numero aproximado de valores distintos. Para grandes volumes, o resultado e uma estimativa.

## Metric aggregations

Agregacoes de metrica calculam valores numericos sobre os documentos de um grupo.

### `avg`

Calcula a media de um campo numerico.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "ticket_medio": {
        "avg": {
          "field": "valor_total"
        }
      }
    }
  }'
```

### `sum`

Soma os valores de um campo numerico.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "receita_total": {
        "sum": {
          "field": "valor_total"
        }
      }
    }
  }'
```

### `min` e `max`

Retornam o menor e o maior valor de um campo.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "menor_pedido": { "min": { "field": "valor_total" } },
      "maior_pedido": { "max": { "field": "valor_total" } }
    }
  }'
```

### `value_count`

Conta quantos documentos tem um valor nao nulo para o campo informado.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "total_com_desconto": {
        "value_count": {
          "field": "desconto"
        }
      }
    }
  }'
```

### `stats`

Retorna varias metricas de uma vez: `count`, `min`, `max`, `avg` e `sum`.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "estatisticas_valor": {
        "stats": {
          "field": "valor_total"
        }
      }
    }
  }'
```

Resultado:

```json
{
  "aggregations": {
    "estatisticas_valor": {
      "count": 5000,
      "min":   9.9,
      "max":   4500.0,
      "avg":   312.5,
      "sum":   1562500.0
    }
  }
}
```

### `percentiles`

Calcula percentis de um campo numerico. Muito usado para analisar latencia e distribuicao.

```bash
curl -X GET "http://localhost:9200/requisicoes/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "latencia_percentis": {
        "percentiles": {
          "field": "latencia_ms",
          "percents": [50, 75, 90, 95, 99]
        }
      }
    }
  }'
```

Resultado:

```json
{
  "aggregations": {
    "latencia_percentis": {
      "values": {
        "50.0": 120,
        "75.0": 250,
        "90.0": 480,
        "95.0": 820,
        "99.0": 1950
      }
    }
  }
}
```

Isso significa que 99% das requisicoes respondem em ate 1950ms.

### `top_hits`

Retorna os documentos mais relevantes dentro de cada bucket. Util para ver exemplos reais por grupo.

```bash
curl -X GET "http://localhost:9200/logs/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "por_servico": {
        "terms": { "field": "servico" },
        "aggs": {
          "ultimo_erro": {
            "top_hits": {
              "size": 1,
              "sort": [ { "@timestamp": { "order": "desc" } } ],
              "_source": ["@timestamp", "message", "nivel"]
            }
          }
        }
      }
    }
  }'
```

Retorna o ultimo log de erro de cada servico.

## Pipeline aggregations

Agregacoes de pipeline operam sobre o resultado de outras agregacoes, nao sobre os documentos diretamente.

### `avg_bucket`

Calcula a media dos valores de todos os buckets de uma agregacao anterior.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "vendas_por_dia": {
        "date_histogram": {
          "field": "data_pedido",
          "calendar_interval": "day"
        },
        "aggs": {
          "receita_dia": {
            "sum": { "field": "valor_total" }
          }
        }
      },
      "media_diaria": {
        "avg_bucket": {
          "buckets_path": "vendas_por_dia>receita_dia"
        }
      }
    }
  }'
```

- `buckets_path`: referencia o caminho ate a agregacao base no formato `agregacao_pai>metrica`

Outras agregacoes de pipeline similares: `sum_bucket`, `min_bucket`, `max_bucket`.

### `derivative`

Calcula a derivada (variacao) entre buckets consecutivos. Util para detectar tendencias.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "vendas_por_hora": {
        "date_histogram": {
          "field": "data_pedido",
          "calendar_interval": "hour"
        },
        "aggs": {
          "receita": { "sum": { "field": "valor_total" } },
          "variacao_receita": {
            "derivative": { "buckets_path": "receita" }
          }
        }
      }
    }
  }'
```

### `moving_avg`

Calcula a media movel sobre buckets. Util para suavizar series temporais em graficos.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "vendas_por_dia": {
        "date_histogram": {
          "field": "data_pedido",
          "calendar_interval": "day"
        },
        "aggs": {
          "receita": { "sum": { "field": "valor_total" } },
          "media_movel": {
            "moving_avg": {
              "buckets_path": "receita",
              "window": 7
            }
          }
        }
      }
    }
  }'
```

`window: 7` calcula a media dos ultimos 7 dias.

## Agregacoes aninhadas

Agregacoes podem ser aninhadas: um bucket pode conter metricas ou outros buckets dentro dele.

Exemplo: receita total por status, e dentro de cada status, ticket medio por dia.

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "aggs": {
      "por_status": {
        "terms": { "field": "status" },
        "aggs": {
          "receita_total": {
            "sum": { "field": "valor_total" }
          },
          "ticket_medio": {
            "avg": { "field": "valor_total" }
          },
          "por_dia": {
            "date_histogram": {
              "field": "data_pedido",
              "calendar_interval": "day"
            },
            "aggs": {
              "receita_dia": {
                "sum": { "field": "valor_total" }
              }
            }
          }
        }
      }
    }
  }'
```

Esse exemplo retorna para cada status: receita total, ticket medio, e dentro de cada status a receita por dia.

## Exemplos praticos

### Top 5 servicos com mais erros na ultima hora

```bash
curl -X GET "http://localhost:9200/logs/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "query": {
      "bool": {
        "filter": [
          { "term":  { "nivel": "ERROR" } },
          { "range": { "@timestamp": { "gte": "now-1h" } } }
        ]
      }
    },
    "aggs": {
      "top_servicos": {
        "terms": {
          "field": "servico",
          "size": 5,
          "order": { "_count": "desc" }
        }
      }
    }
  }'
```

### Latencia p95 por endpoint nas ultimas 24 horas

```bash
curl -X GET "http://localhost:9200/requisicoes/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "query": {
      "range": { "@timestamp": { "gte": "now-24h" } }
    },
    "aggs": {
      "por_endpoint": {
        "terms": {
          "field": "endpoint",
          "size": 20
        },
        "aggs": {
          "p95_latencia": {
            "percentiles": {
              "field": "latencia_ms",
              "percents": [95]
            }
          }
        }
      }
    }
  }'
```

### Volume de logs por nivel ao longo do tempo

```bash
curl -X GET "http://localhost:9200/logs/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "query": {
      "range": { "@timestamp": { "gte": "now-6h" } }
    },
    "aggs": {
      "por_tempo": {
        "date_histogram": {
          "field": "@timestamp",
          "fixed_interval": "10m"
        },
        "aggs": {
          "por_nivel": {
            "terms": { "field": "nivel" }
          }
        }
      }
    }
  }'
```

Retorna a contagem de logs por nivel (INFO, WARN, ERROR) em janelas de 10 minutos nas ultimas 6 horas.

### Receita diaria com media movel de 7 dias

```bash
curl -X GET "http://localhost:9200/pedidos/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "size": 0,
    "query": {
      "range": { "data_pedido": { "gte": "now-30d" } }
    },
    "aggs": {
      "por_dia": {
        "date_histogram": {
          "field": "data_pedido",
          "calendar_interval": "day"
        },
        "aggs": {
          "receita": { "sum": { "field": "valor_total" } },
          "media_movel_7d": {
            "moving_avg": {
              "buckets_path": "receita",
              "window": 7
            }
          }
        }
      }
    }
  }'
```

## Templates de Indice

Templates de indice definem configuracoes e mappings que serao aplicados automaticamente quando um novo indice for criado com nome que bate com um padrao.

Sem um template, cada indice precisa ser criado manualmente com suas configuracoes. Com um template, o Elasticsearch aplica tudo automaticamente.

Isso e essencial em ambientes com indices diarios, como `logs-app-2024.01.01`, onde seria inviavel configurar cada indice manualmente.

## Index Template

Um Index Template moderno (a partir da versao 7.8, usando `_index_template`) define:

- quais indices ele cobre via `index_patterns`
- `settings`: configuracoes do indice como numero de shards e replicas
- `mappings`: tipos dos campos
- `aliases`: aliases aplicados na criacao
- `composed_of`: component templates reutilizaveis

```bash
curl -X PUT "http://localhost:9200/_index_template/logs-template" \
  -H "Content-Type: application/json" \
  -d '{
    "index_patterns": ["logs-app-*"],
    "priority": 100,
    "template": {
      "settings": {
        "number_of_shards": 2,
        "number_of_replicas": 1,
        "index.lifecycle.name": "politica-logs",
        "index.lifecycle.rollover_alias": "logs-app"
      },
      "mappings": {
        "properties": {
          "@timestamp":  { "type": "date" },
          "nivel":       { "type": "keyword" },
          "servico":     { "type": "keyword" },
          "message":     { "type": "text" },
          "latencia_ms": { "type": "integer" }
        }
      },
      "aliases": {
        "logs-app": {}
      }
    }
  }'
```

- `index_patterns`: padrao de nome dos indices que usarao esse template
- `priority`: quando varios templates batem, o de maior prioridade vence
- `settings`: configuracoes aplicadas ao indice
- `mappings`: tipos dos campos definidos com antecedencia

## Component Template

Component Templates sao blocos reutilizaveis de configuracao que podem ser compostos em varios Index Templates.

Util quando varias series de indices compartilham o mesmo mapping ou settings base.

```bash
# componente com settings comuns
curl -X PUT "http://localhost:9200/_component_template/settings-base" \
  -H "Content-Type: application/json" \
  -d '{
    "template": {
      "settings": {
        "number_of_shards": 2,
        "number_of_replicas": 1
      }
    }
  }'

# componente com mapping comum
curl -X PUT "http://localhost:9200/_component_template/mapping-logs" \
  -H "Content-Type: application/json" \
  -d '{
    "template": {
      "mappings": {
        "properties": {
          "@timestamp": { "type": "date" },
          "nivel":      { "type": "keyword" },
          "servico":    { "type": "keyword" },
          "message":    { "type": "text" }
        }
      }
    }
  }'

# index template que usa os dois componentes
curl -X PUT "http://localhost:9200/_index_template/logs-app-template" \
  -H "Content-Type: application/json" \
  -d '{
    "index_patterns": ["logs-app-*"],
    "composed_of": ["settings-base", "mapping-logs"],
    "priority": 100
  }'
```

## Configuracoes importantes em um template

| Configuracao | Descricao |
|---|---|
| `number_of_shards` | Quantas shards primarias o indice tera. Nao pode ser alterado apos criacao. |
| `number_of_replicas` | Quantas replicas por shard. Pode ser alterado a qualquer momento. |
| `index.lifecycle.name` | Nome da politica de ILM associada. |
| `index.lifecycle.rollover_alias` | Alias usado pelo ILM para criar novos indices no rollover. |
| `index.mapping.total_fields.limit` | Limite de campos no mapping. Padrao 1000. |
| `index.refresh_interval` | Com que frequencia o indice e atualizado para buscas. Padrao `1s`. |
| `index.codec` | Compressao dos dados. `best_compression` economiza disco com custo de CPU. |

## Alias de Indices

## Para que serve

Um alias e um nome alternativo que aponta para um ou mais indices.

Vantagens:

- o aplicativo sempre usa o alias, sem precisar conhecer o nome real do indice
- e possivel rotacionar indices sem alterar o codigo da aplicacao
- um alias pode apontar para multiplos indices ao mesmo tempo, permitindo busca em varios periodos com uma unica query
- um alias pode ter apenas um indice de escrita (write index)

## Criando e usando aliases

Criando um alias para um indice:

```bash
curl -X POST "http://localhost:9200/_aliases" \
  -H "Content-Type: application/json" \
  -d '{
    "actions": [
      {
        "add": {
          "index": "logs-app-2024.01.01",
          "alias": "logs-app"
        }
      }
    ]
  }'
```

Consultando pelo alias (transparente para a aplicacao):

```bash
curl -X GET "http://localhost:9200/logs-app/_search" \
  -H "Content-Type: application/json" \
  -d '{ "query": { "match_all": {} } }'
```

Adicionando um segundo indice ao mesmo alias (busca abrange os dois):

```bash
curl -X POST "http://localhost:9200/_aliases" \
  -H "Content-Type: application/json" \
  -d '{
    "actions": [
      { "add": { "index": "logs-app-2024.01.02", "alias": "logs-app" } }
    ]
  }'
```

## Write alias

Quando um alias aponta para varios indices, e necessario definir qual deles recebe as novas escritas.

```bash
curl -X POST "http://localhost:9200/_aliases" \
  -H "Content-Type: application/json" \
  -d '{
    "actions": [
      {
        "add": {
          "index": "logs-app-000002",
          "alias": "logs-app",
          "is_write_index": true
        }
      },
      {
        "add": {
          "index": "logs-app-000001",
          "alias": "logs-app",
          "is_write_index": false
        }
      }
    ]
  }'
```

- `logs-app-000002` recebe as novas escritas
- `logs-app-000001` fica acessivel apenas para leitura via o mesmo alias

## Rotacao de Indices

Rodar indices significa criar periodicamente um novo indice e direcionar as escritas para ele, mantendo os indices antigos apenas para leitura.

Motivos para rodar indices:

- controlar o tamanho de cada indice
- facilitar a exclusao de dados antigos (basta deletar o indice, nao documentos individuais)
- melhorar desempenho de busca e manutencao
- permitir aplicar configuracoes diferentes por periodo

As duas abordagens mais comuns sao rotacao por data (nome com data no sufixo) e rotacao por tamanho ou volume usando rollover.

## Rollover

Rollover e o mecanismo nativo do Elasticsearch para criar um novo indice quando o atual atinge um criterio.

Criterios possiveis:

- `max_age`: tempo de vida maximo do indice atual
- `max_docs`: numero maximo de documentos
- `max_size`: tamanho maximo em bytes
- `max_primary_shard_size`: tamanho maximo por shard primaria

Exemplo de chamada manual de rollover:

```bash
curl -X POST "http://localhost:9200/logs-app/_rollover" \
  -H "Content-Type: application/json" \
  -d '{
    "conditions": {
      "max_age": "7d",
      "max_docs": 10000000,
      "max_primary_shard_size": "50gb"
    }
  }'
```

O Elasticsearch cria um novo indice (ex: `logs-app-000002`) e move o write alias para ele automaticamente, se alguma condicao for atendida.

## Rollover com alias

O rollover exige que o indice inicial tenha sido criado com o alias de escrita configurado:

```bash
# criar o indice inicial com o alias de escrita
curl -X PUT "http://localhost:9200/logs-app-000001" \
  -H "Content-Type: application/json" \
  -d '{
    "aliases": {
      "logs-app": {
        "is_write_index": true
      }
    }
  }'
```

A partir dai, o rollover usa o alias `logs-app` e sabe qual e o indice de escrita atual.

Na pratica, o ILM gerencia o rollover automaticamente. Rollover manual e mais usado para testes ou situacoes especificas.

## Ciclo de Vida dos Indices

O ILM (Index Lifecycle Management) e o mecanismo do Elasticsearch para gerenciar automaticamente o ciclo de vida de um indice desde a criacao ate a exclusao.

Sem ILM, e necessario criar scripts externos para rodar indices, mover shards, reduzir replicas ou excluir dados antigos. Com ILM, tudo isso e configurado em uma politica e executado automaticamente.

## Fases do ILM

### Hot

Indice ativo, recebendo escritas e consultas frequentes.

Caracteristicas esperadas:

- shards primarias no numero completo
- disco rapido (SSD)
- replicas ativas
- rollover configurado por tamanho, idade ou volume

### Warm

Indice nao recebe mais escritas, mas ainda e consultado com alguma frequencia.

Acoes tipicas na fase warm:

- reduzir replicas para economizar espaco
- executar `forcemerge` para compactar segmentos e liberar recursos
- mover shards para nos com disco mais lento e mais barato
- converter para `best_compression`

### Cold

Indice raramente consultado. Foco em custo de armazenamento.

Acoes tipicas na fase cold:

- congelar o indice (em versoes mais antigas, `freeze`; em versoes recentes, uso de `searchable snapshots`)
- mover para nos de armazenamento mais barato ou para object storage
- replicas podem ser removidas se houver snapshot disponivel

### Delete

Indice excluido permanentemente.

Definido por uma idade maxima ou apos a conclusao de um snapshot.

## Criando uma politica de ILM

```bash
curl -X PUT "http://localhost:9200/_ilm/policy/politica-logs" \
  -H "Content-Type: application/json" \
  -d '{
    "policy": {
      "phases": {
        "hot": {
          "min_age": "0ms",
          "actions": {
            "rollover": {
              "max_age": "7d",
              "max_primary_shard_size": "50gb"
            },
            "set_priority": { "priority": 100 }
          }
        },
        "warm": {
          "min_age": "7d",
          "actions": {
            "forcemerge": { "max_num_segments": 1 },
            "shrink":     { "number_of_shards": 1 },
            "allocate":   { "number_of_replicas": 1 },
            "set_priority": { "priority": 50 }
          }
        },
        "cold": {
          "min_age": "30d",
          "actions": {
            "allocate": { "number_of_replicas": 0 },
            "set_priority": { "priority": 0 }
          }
        },
        "delete": {
          "min_age": "90d",
          "actions": {
            "delete": {}
          }
        }
      }
    }
  }'
```

Fluxo dessa politica:

- **0 a 7 dias**: indice hot, rollover quando atingir 7 dias ou 50GB por shard
- **7 a 30 dias**: indice warm, compactado, com 1 shard e 1 replica
- **30 a 90 dias**: indice cold, sem replicas
- **apos 90 dias**: indice excluido

## Associando a politica ao template

A forma mais pratica e referenciar a politica diretamente no Index Template:

```bash
curl -X PUT "http://localhost:9200/_index_template/logs-app-template" \
  -H "Content-Type: application/json" \
  -d '{
    "index_patterns": ["logs-app-*"],
    "priority": 100,
    "template": {
      "settings": {
        "number_of_shards": 2,
        "number_of_replicas": 1,
        "index.lifecycle.name": "politica-logs",
        "index.lifecycle.rollover_alias": "logs-app"
      }
    }
  }'
```

Assim, qualquer indice criado com o padrao `logs-app-*` herda automaticamente a politica de ciclo de vida.

## Capacidade e Dimensionamento

## Numero de shards

O numero de shards determina como o indice e dividido entre os nos do cluster.

Nao existe um numero certo universal, mas existem referencias praticas:

**Tamanho por shard**

Uma shard primaria deve ter entre **10GB e 50GB** em producao.

- Shards muito pequenas (menos de 1GB) criam overhead desnecessario de metadados e gerenciamento
- Shards muito grandes (acima de 50-60GB) prejudicam a velocidade de recuperacao em falhas e o balanceamento

**Regra pratica para definir o numero de shards**

```text
numero de shards = volume total esperado do indice / tamanho alvo por shard
```

Exemplo: indice que vai crescer ate 200GB, com shards de 50GB:

```text
200GB / 50GB = 4 shards primarias
```

**Shards e nos**

O numero de shards limita o paralelismo de busca. O Elasticsearch distribui shards entre nos, entao ter mais shards que nos nao agrega paralelismo real em buscas.

Uma boa referencia e:

```text
numero de shards <= numero de nos de dados
```

Ou, em clusters maiores:

```text
numero de shards = numero de nos * fator de paralelismo desejado
```

**Atencao**: o numero de shards primarias nao pode ser alterado apos a criacao do indice. Planejar com antecedencia e importante.

**Limite de shards por no**

Por padrao, o Elasticsearch limita a **1000 shards por no** (contando primarias e replicas).

Um cluster com 3 nos suporta ate 3000 shards totais. Em ambientes com muitos indices diarios, esse limite pode ser atingido se os indices antigos nao forem excluidos ou consolidados.

## Numero de replicas

Replicas aumentam a disponibilidade e a capacidade de leitura.

| Cenario | Replicas recomendadas |
|---|---|
| Ambiente de desenvolvimento | 0 (economiza recursos) |
| Producao com 2 nos | 1 |
| Producao com 3 ou mais nos | 1 ou 2 |
| Dados criticos sem backup externo | 2 |
| Fase cold / arquivamento | 0 (se houver snapshot) |

Diferente das shards primarias, o numero de replicas pode ser alterado a qualquer momento:

```bash
curl -X PUT "http://localhost:9200/logs-app-000001/_settings" \
  -H "Content-Type: application/json" \
  -d '{
    "index": {
      "number_of_replicas": 1
    }
  }'
```

## Boas praticas de dimensionamento

- **Prefira menos shards maiores** a muitas shards pequenas. O overhead de gerenciar milhares de shards e significativo.
- **Use ILM** para controlar o ciclo de vida e evitar acumulo de indices e shards.
- **Monitore o tamanho real das shards** com a API `_cat/shards` antes de definir o padrao do template.
- **Evite over-sharding em indices pequenos**. Se o indice diario for pequeno, uma shard e suficiente.
- **Ajuste replicas pelo risco**, nao pelo desempenho de leitura. Para leitura, preferir mais nos e menos replicas.
- **Use `forcemerge` na fase warm** para reduzir segmentos e liberar memoria de heap.
- **Faca rollover por tamanho, nao apenas por data**, para evitar shards desbalanceadas.

```bash
# verificar tamanho e distribuicao das shards
curl -X GET "http://localhost:9200/_cat/shards?v&s=store:desc"

# verificar saude e uso de cada no
curl -X GET "http://localhost:9200/_cat/nodes?v&h=name,heap.percent,ram.percent,cpu,disk.used_percent"

# verificar indices mais pesados
curl -X GET "http://localhost:9200/_cat/indices?v&s=store.size:desc"
```

## Caracteristicas de Servidor

## Memoria RAM e Heap

A memoria e o recurso mais critico para o Elasticsearch.

O Elasticsearch usa dois tipos de memoria:

- **Heap JVM**: usada internamente pela JVM para estruturas de dados como mappings, buffers de indexacao, caches de query e agregacoes
- **Memoria de sistema (fora do heap)**: usada pelo Lucene para armazenar segmentos de indice em cache de paginas do sistema operacional. Quanto mais memoria disponivel fora do heap, mais rapidas sao as buscas porque os dados ficam em memoria

**Regra do heap**

O heap deve ser exatamente **metade da RAM total do servidor**, com limite maximo de **31GB**.

Nunca ultrapassar 31GB porque acima desse valor a JVM desabilita a otimizacao de ponteiros comprimidos (Compressed OOPs), o que aumenta o consumo de memoria e reduz o desempenho.

Para um servidor com **32GB de RAM**:

```text
Heap JVM  = 16GB   (metade da RAM)
SO/Lucene = 16GB   (metade restante para cache de paginas)
```

Configuracao do heap no arquivo `jvm.options`:

```text
-Xms16g
-Xmx16g
```

Os valores de `-Xms` e `-Xmx` devem ser **identicos** para evitar que a JVM redimensione o heap em tempo de execucao, o que causa pauses de GC.

**Verificar uso de heap em tempo real**

```bash
curl -X GET "http://localhost:9200/_cat/nodes?v&h=name,heap.current,heap.max,heap.percent"
```

Um heap acima de 75-80% com frequencia indica necessidade de mais memoria ou reducao de carga.

**Bootstrap checks**

Em producao, o Elasticsearch executa verificacoes no inicio. Uma delas exige que o `mlockall` esteja habilitado para prevenir swap:

```yaml
# elasticsearch.yml
bootstrap.memory_lock: true
```

Se o sistema operacional permitir, isso garante que o processo nunca sera movido para o swap.

## CPU

CPU tem importancia secundaria comparada a memoria e disco.

O Elasticsearch usa CPU principalmente para:

- indexacao (compressao, analise de texto)
- buscas com scoring complexo
- agregacoes pesadas
- `forcemerge`

Para a maioria dos casos de uso com logs e monitoramento, a carga de CPU e moderada.

Recomendacao: **8 a 16 cores** ja atendem bem a maioria dos nos de dados. Investir em mais RAM e disco trara mais ganho que adicionar CPU.

## Disco

**Use SSD obrigatoriamente nos nos hot.**

O Lucene faz muitas operacoes de leitura aleatoria em segmentos de indice. Disco rotativo (HDD) causa latencia alta nessas operacoes e degrada significativamente o desempenho de busca e indexacao.

**RAID 0 nos nos de dados**

RAID 0 (striping sem paridade) e a configuracao recomendada para nos de dados do Elasticsearch.

Motivo: o cluster ja e redundante por design. Shards primarias e suas replicas ficam em nos diferentes. Se um disco falhar, o no e removido do cluster e o Elasticsearch restaura as shards a partir das replicas nos outros nos.

Vantagem do RAID 0:

- throughput de disco multiplicado pelo numero de discos
- sem overhead de paridade
- mais espaco util

RAID 1, RAID 5 ou RAID 10 nao trazem beneficio real e adicionam custo e latencia desnecessarios.

**Exemplo com 4 discos SSD de 1TB em RAID 0:**

```text
Capacidade util: 4TB
Throughput:      ~4x o de um disco individual
Redundancia:     garantida pelo cluster (replicas em outros nos)
```

**Evitar compartilhar disco entre processos**

O disco do no Elasticsearch nao deve ser compartilhado com outros servicos que gerem I/O intenso, pois isso degrada o cache de paginas do Lucene.

**Monitorar latencia de disco**

```bash
# verificar disk.used_percent em cada no
curl -X GET "http://localhost:9200/_cat/nodes?v&h=name,disk.used_percent,disk.avail"
```

Um no com disco acima de **85%** pode comecar a ter problemas de alocacao de novas shards.

## Rede

Rede rapida e de baixa latencia e fundamental para o cluster funcionar bem.

Os nos do Elasticsearch se comunicam constantemente para:

- replicar documentos de shards primarias para replicas
- distribuir resultados de buscas entre nos
- coordenar eleicao de master
- sincronizar estado do cluster

Recomendacoes:

- **10 Gbps** entre nos de dados em producao
- Nos do cluster na mesma rede local ou datacenter (evitar WAN entre nos)
- Latencia menor que 1ms entre nos e desejavel
- Evitar compartilhar interface de rede com trafego de alta variacao

## Resumo de hardware recomendado

Perfil para um **no de dados** com 32GB de RAM:

| Componente | Recomendacao |
|---|---|
| RAM | 32GB |
| Heap JVM | 16GB (`-Xms16g -Xmx16g`) |
| CPU | 8-16 cores |
| Disco | SSD, RAID 0 entre os discos do no |
| Disco minimo | 500GB util por no (depende do volume de dados) |
| Rede | 10 Gbps |
| Swap | Desabilitado ou `memory_lock: true` |

Perfil tipico de cluster para logs em producao:

```text
3 nos master dedicados   (menor, sem dados: 8GB RAM, 4 cores)
3+ nos de dados hot      (32GB RAM, SSD, 10Gbps)
2+ nos de dados warm     (32GB RAM, HDD ou SSD mais barato)
1+ no coordenador        (opcional, recebe requests e distribui)
```

## Manutencao do Cluster

Manutencoes planejadas em um cluster Elasticsearch incluem situacoes como:

- atualizacao de versao do Elasticsearch
- aplicacao de patches do sistema operacional que exigem reboot
- troca ou expansao de disco
- atualizacao de configuracao da JVM (heap, flags)
- substituicao de hardware

O procedimento recomendado para esses cenarios e o **rolling restart**: reiniciar os nos um a um, garantindo que o cluster se mantenha operacional e nao haja perda de dados durante o processo.

## Quando usar rolling restart

- Sempre que o cluster tiver pelo menos 2 nos com replicas ativas
- Patches de SO ou atualizacoes menores do Elasticsearch (mesma major version)
- Qualquer reinicializacao planejada que nao exija parada total

Se a atualizacao exigir parada total (full cluster restart), como em saltos de major version, o procedimento e diferente e deve seguir a documentacao oficial da versao alvo.

## Verificar saude antes de comecar

Antes de qualquer acao, confirmar que o cluster esta verde e sem problemas:

```bash
# saude geral do cluster
curl -X GET "http://localhost:9200/_cluster/health?pretty"
```

Resultado esperado antes de comecar:

```json
{
  "cluster_name": "meu-cluster",
  "status": "green",
  "number_of_nodes": 6,
  "number_of_data_nodes": 3,
  "active_primary_shards": 120,
  "active_shards": 240,
  "relocating_shards": 0,
  "initializing_shards": 0,
  "unassigned_shards": 0
}
```

Nao iniciar o rolling restart se `status` for `yellow` ou `red`, ou se houver `unassigned_shards` ou `relocating_shards`.

```bash
# listar todos os nos com status de uso
curl -X GET "http://localhost:9200/_cat/nodes?v&h=name,ip,role,heap.percent,ram.percent,cpu,disk.used_percent,master"

# verificar shards nao alocadas e o motivo
curl -X GET "http://localhost:9200/_cluster/allocation/explain?pretty"

# listar shards e em qual no estao
curl -X GET "http://localhost:9200/_cat/shards?v&s=state,index"
```

## Passo 1 - Parar indexacao de novos dados

Se possivel e se a arquitetura permitir, pausar o envio de novos dados ao cluster durante a manutencao de cada no.

Isso pode ser feito:

- pausando os agentes de coleta (Filebeat, Logstash, Fluentd) no lado do produtor
- pausando consumidores Kafka se o Logstash for o consumidor
- usando `_index` com configuracao de `refresh_interval: -1` para atrasar a visibilidade (nao bloqueia indexacao, mas reduz overhead)

Na maioria dos casos praticos em ambiente de logs, nao e necessario parar a indexacao se o cluster tiver replicas. O rolling restart e projetado para funcionar com o cluster ativo.

Se a decisao for pausar, documentar o momento da pausa e retomar logo apos o no voltar ao verde.

## Passo 2 - Desabilitar alocacao de shards

Antes de parar o no, desabilitar a realocacao automatica de shards.

Sem isso, ao parar o no, o Elasticsearch comecara imediatamente a mover as shards daquele no para outros nos. Isso gera trafego de rede e disco desnecessario, pois o no voltara em breve.

```bash
curl -X PUT "http://localhost:9200/_cluster/settings" \
  -H "Content-Type: application/json" \
  -d '{
    "persistent": {
      "cluster.routing.allocation.enable": "primaries"
    }
  }'
```

- `primaries`: permite apenas alocacao de shards primarias, bloqueando a realocacao de replicas
- Alternativa mais restritiva: `"none"` bloqueia toda alocacao

Usar `primaries` e preferido porque ainda permite que shards primarias se recuperem em caso de problema real, mas evita a realocacao massiva de replicas durante o restart planejado.

## Passo 3 - Realizar flush sincronizado

Antes de parar o no, solicitar um flush para persistir os dados em memoria no disco:

```bash
curl -X POST "http://localhost:9200/_flush"
```

Isso reduz o tempo de recuperacao do no ao reiniciar, pois o Elasticsearch nao precisara fazer replay de operacoes do translog.

## Passo 4 - Desativar o no e fazer manutencao

Parar o servico do Elasticsearch no no alvo:

```bash
# via systemd
sudo systemctl stop elasticsearch

# verificar que o processo parou
sudo systemctl status elasticsearch
```

Realizar a manutencao desejada:

- aplicar patches do SO e reiniciar o servidor
- atualizar o pacote do Elasticsearch
- substituir disco / expandir storage
- alterar configuracoes de heap em `jvm.options`
- alterar configuracoes em `elasticsearch.yml`

Apos a manutencao, iniciar o servico:

```bash
sudo systemctl start elasticsearch

# acompanhar o log de inicializacao
sudo journalctl -u elasticsearch -f
```

Verificar que o no voltou ao cluster:

```bash
# o no deve aparecer na lista com status normal
curl -X GET "http://localhost:9200/_cat/nodes?v&h=name,ip,role,master,heap.percent,disk.used_percent"
```

## Passo 5 - Habilitar alocacao de shards

Com o no de volta ao cluster, reabilitar a alocacao de shards:

```bash
curl -X PUT "http://localhost:9200/_cluster/settings" \
  -H "Content-Type: application/json" \
  -d '{
    "persistent": {
      "cluster.routing.allocation.enable": null
    }
  }'
```

Usar `null` remove a configuracao persistente e volta ao padrao (`all`), que permite alocacao livre de shards.

Apos reabilitar, o Elasticsearch comecara a realocar as shards que estavam sem replica enquanto o no estava fora.

## Passo 6 - Aguardar o cluster voltar ao verde

Monitorar o status do cluster ate que volte a `green`:

```bash
# verificacao rapida do status
curl -s "http://localhost:9200/_cluster/health" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(f\"Status: {d['status']} | Shards: {d['active_shards']} ativos | Nao alocadas: {d['unassigned_shards']} | Realocando: {d['relocating_shards']}\")
"

# aguardar ate ficar verde com timeout de 5 minutos
curl -X GET "http://localhost:9200/_cluster/health?wait_for_status=green&timeout=5m&pretty"
```

Nao iniciar a manutencao do proximo no enquanto o cluster nao estiver verde.

Se o cluster ficar `yellow` por muito tempo, investigar:

```bash
# ver shards nao alocadas
curl -X GET "http://localhost:9200/_cat/shards?v&s=state" | grep -v STARTED

# entender o motivo da nao alocacao
curl -X GET "http://localhost:9200/_cluster/allocation/explain?pretty"
```

## Repetir para os demais nos

Repetir os passos 2 a 6 para cada no do cluster, um de cada vez.

Ordem sugerida:

1. Nos de dados primeiro (hot, warm)
2. Nos coordenadores
3. Nos master por ultimo (manter quorum durante todo o processo)

Em um cluster com 3 nos master, sempre manter pelo menos 2 nos master ativos simultaneamente para nao perder quorum.

Resumo do fluxo completo:

```text
para cada no:
  1. confirmar cluster verde
  2. desabilitar alocacao de shards  (allocation: primaries)
  3. flush
  4. parar servico -> manutencao -> iniciar servico
  5. confirmar que o no voltou ao cluster
  6. reabilitar alocacao de shards   (allocation: null)
  7. aguardar cluster verde
  8. proximo no
```

## Comandos de monitoramento durante a manutencao

```bash
# saude resumida do cluster
curl -s "http://localhost:9200/_cluster/health?pretty"

# listar nos ativos com uso de recursos
curl -X GET "http://localhost:9200/_cat/nodes?v&h=name,ip,role,master,heap.percent,ram.percent,cpu,disk.used_percent"

# listar shards e seu estado
curl -X GET "http://localhost:9200/_cat/shards?v&s=state,index" | head -40

# ver apenas shards fora do estado STARTED
curl -X GET "http://localhost:9200/_cat/shards?v" | grep -v STARTED

# tamanho e contagem de documentos por indice
curl -X GET "http://localhost:9200/_cat/indices?v&s=store.size:desc" | head -20

# verificar configuracoes de alocacao atuais
curl -X GET "http://localhost:9200/_cluster/settings?pretty&include_defaults=false"

# ver tasks em execucao no cluster (rebalanceamento, merge, etc)
curl -X GET "http://localhost:9200/_tasks?detailed=true&actions=*rebalance*,*merge*&pretty"

# ver recuperacao de shards em andamento
curl -X GET "http://localhost:9200/_cat/recovery?v&active_only=true"
```

## Resumo rapido

- Indice invertido: organiza termos para busca rapida
- Indices: colecoes de documentos
- Shards: divisao do indice em partes
- Replicas: copias das shards para alta disponibilidade
- Mapping: define os tipos dos campos
- Analyzer: prepara o texto para indexacao e busca
- Logstash: pipeline de ingestao com input, filter e output
- Agregacoes: resumem e calculam metricas sobre documentos (bucket, metric, pipeline)
- Templates: configuram automaticamente novos indices via padrao de nome
- Aliases: nome virtual que aponta para um ou mais indices
- Rollover: cria novo indice quando o atual atinge criterio de tamanho ou idade
- ILM: gerencia o ciclo de vida hot > warm > cold > delete automaticamente
- Heap: metade da RAM, maximo 31GB, Xms igual a Xmx
- Disco: SSD obrigatorio em hot, RAID 0, sem swap
