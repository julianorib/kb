# kafka

## O que é o Kafka

Apache Kafka é uma plataforma distribuída de streaming de eventos, usada para publicar,
armazenar e consumir mensagens (eventos) em tempo real, de forma durável e escalável.

Funciona como um sistema de mensageria pub/sub: **produtores** publicam mensagens em
**tópicos**, e **consumidores** leem essas mensagens, de forma assíncrona e desacoplada.
É muito usado para integração entre sistemas, pipelines de dados, filas de eventos,
logs distribuídos e arquiteturas orientadas a eventos.

Conceitos básicos:
- **Broker**: cada nó do cluster Kafka, responsável por armazenar e servir as mensagens.
- **Tópico (topic)**: canal lógico onde as mensagens são publicadas/consumidas.
- **Partição (partition)**: divisão de um tópico, permite paralelismo e escalabilidade.
- **Replicação (replication factor)**: quantidade de cópias de cada partição entre os brokers, para tolerância a falhas.
- **Consumer Group**: conjunto de consumidores que dividem entre si o consumo das partições de um tópico.
- **Offset**: posição/índice de uma mensagem dentro de uma partição.

## Ref:
<https://kafka.apache.org/quickstart>\
<https://kafka.apache.org/documentation/#operations>\
<https://www.youtube.com/watch?v=N2D7hsXHVGk>


Um cluster de 3 nós, geralmente tem um Fator de Replicação de 2.\
Se 2 de 3 nós estiverem off, não será gravado novas mensagens.

Cada tópico tem uma quantidade X de partições.\
Normalmente, o número de partições =  Número de Consumidores.

## Docker
Executar Container do Kafka para utilizar seu Console / Utilitários:
```
docker run -it --workdir /opt/kafka/bin/ --rm apache/kafka sh
```

## Criar / Deletar um topico
```
./kafka-topics.sh  --bootstrap-server <broker> --create --topic <topic_name> --partitions <num_partitions> --replication-factor <replication_factor>
./kafka-topics.sh  --bootstrap-server <broker> --delete --topic <topic_name> 
```

## Listar / Detalhar um topico
```
./kafka-topics.sh  --bootstrap-server kafkaserver-1:9094,kafkaserver-2:9094,kafkaserver-3:9094 --list
./kafka-topics.sh  --bootstrap-server kafkaserver-1:9094,kafkaserver-2:9094,kafkaserver-3:9094 --describe --topic antifraude.lexisnexis.analise
```

## Ajustando as partições de um Tópico
```
./kafka-topics.sh --alter --zookeeper zookeeper001:2181 --topic topicoY.logs --partitions 20
```
```
./kafka-topics.sh --alter --bootstrap-server kafkaserver-1:9094 --topic topicoX.logs --partitions 7
```

*Observação: Um tópico só pode aumentar as partições, nunca diminuir.* 

## Produzir mensagens
```
./kafka-console-producer.sh --bootstrap-server <broker> --topic <topic_name> 
```
*Será aberto um console para digitar mensagens*

## Consumir mensagens
```
./kafka-console-consumer.sh  --bootstrap-server <broker> --topic <topic_name> --from-beginning
```

## Consumer Group
```
./kafka-consumer-groups.sh   --bootstrap-server kafkaserver-1:9094,kafkaserver-2:9094,kafkaserver-3:9094 --list
./kafka-consumer-groups.sh   --bootstrap-server kafkaserver-1:9094,kafkaserver-2:9094,kafkaserver-3:9094 --describe --group consumergroup
```

## Autenticação:

Quando um Kafka é autenticado, é necessário criar um arquivo com as credenciais para conseguir autenticar.
file: client.properties
```

security.protocol=SASL_PLAINTEXT
sasl.mechanism=PLAIN

sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="USER" password="PASSWORD";

```

Cada comando tem um parâmetro diferente, mas basicamente:
- kafka-topics.sh -> --command-config client.properties
- kafka-console-producer.sh ->  --producer.config client.properties
- kafka-console-consumer.sh ->  --consumer.config client.properties

## kcat

Utilitário de linha de comando leve (antigo `kafkacat`), útil para testes rápidos
sem precisar dos scripts `.sh` do Kafka.

Exemplos de uso:
```
# Listar metadados (tópicos, partições, brokers)
kcat -b <broker> -L

# Consumir mensagens de um tópico (do início)
kcat -b <broker> -t <topic_name> -C -o beginning

# Produzir uma mensagem
echo "minha mensagem" | kcat -b <broker> -t <topic_name> -P
```

Mais detalhes: <https://github.com/edenhill/kcat>

## Offset Explorer

Esta é outra aplicação, que pode ser instalada no computador para gerenciar um Kafka.

<https://offsetexplorer.com/download.html>


## KafkIO

Esta é outra aplicação, que pode ser instalada no computador para gerenciar um Kafka.
Esta é mais interessante. Tem muito mais opções, mais completa

<https://kafkio.com/>


## Kafka exporter

O Kafka exporter serve para coletar métricas do Kafka e enviar para o Prometheus.
Necessita uma configuração do lado do Prometheus. 

Do lado do Kafka, necessita do kafka_exporter.

```
kafka_exporter --Kafka.server=servidorkafka:9093
kafka_exporter --Kafka.server=servidorkafka:9093 --sasl.enabled --sasl.mechanism=plain --sasl.username=USER --sasl.password=PASSWORD 
```

systemctl
```
[Unit]
Description=Kafka Exporter
After=network.target

[Service]
User=root
Group=root

# Arquivo externo com segredo
EnvironmentFile=/opt/prometheus/kafka_exporter-1.8.0.linux-386/cred.conf

ExecStart=/opt/prometheus/kafka_exporter-1.8.0.linux-386/kafka_exporter \
  --kafka.server=kfkp-segserv-1.dc.nova:9093 \
  --sasl.enabled \
  --sasl.mechanism=plain \
  --sasl.username=${SASL_USERNAME} \
  --sasl.password=${SASL_PASSWORD}

Restart=always

[Install]
WantedBy=multi-user.target
```
```
SASL_USERNAME=USER
SASL_PASSWORD=PASSWORD
```



