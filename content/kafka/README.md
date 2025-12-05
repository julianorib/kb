# kafka

## Ref:
<https://kafka.apache.org/quickstart>\
<https://kafka.apache.org/documentation/#operations>\
<https://www.youtube.com/watch?v=N2D7hsXHVGk>


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
./kafka-topics.sh  --bootstrap-server kfkp-meiospg-1:9094,kfkp-meiospg-2:9094,kfkp-meiospg-3:9094 --list
./kafka-topics.sh  --bootstrap-server kfkp-meiospg-1:9094,kfkp-meiospg-2:9094,kfkp-meiospg-3:9094 --describe --topic antifraude.lexisnexis.analise
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
./kafka-consumer-groups.sh   --bootstrap-server kfkp-meiospg-1:9094,kfkp-meiospg-2:9094,kfkp-meiospg-3:9094 --list
./kafka-consumer-groups.sh   --bootstrap-server kfkp-meiospg-1:9094,kfkp-meiospg-2:9094,kfkp-meiospg-3:9094 --describe --group consumergroup
```
