# kafka

## Ref:
<https://kafka.apache.org/quickstart>\
<https://kafka.apache.org/documentation/#operations>\
<https://www.youtube.com/watch?v=N2D7hsXHVGk>


Um cluster de 3 nós, geralmente tem um Favor de Replicação de 2.\
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

## Kafka UI

O Kafka UI é uma aplicação para facilitar a visualização e configuração de alguns itens no Kafka. Pode-se adicionar mais de 1 server, mas não consegui fazer funcionar quando é utilizado o zookeeper.

### Docker run
```
docker run -d -p 8080:8080 -e DYNAMIC_CONFIG_ENABLED=true provectuslabs/kafka-ui
```
### Docker Compose
```
services:
  kafka-ui:
    image: provectuslabs/kafka-ui
    container_name: kafka-ui
    ports:
      - "8080:8080"
    restart: always
    environment:
      - DYNAMIC_CONFIG_ENABLED=true
      - KAFKA_CLUSTERS_0_NAME=meiospg
      - KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafkaserver:9094
```

## Offset Explorer

Esta é outra aplicação, que pode ser instalada no computador para gerenciar um Kafka.

<https://offsetexplorer.com/download.html>
