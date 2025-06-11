Exemplo Repositório:
```
curl --request PUT -u admin \
      --url localhost:9200/_snapshot/teste \
      --header 'Content-Type: application/json' \
      --data '{
        "type": "fs",
        "settings": {
          "location": "/snapshots"
        }
      }'
```
Exemplo Politica:
```
curl --request POST -u admin \
      --url localhost:9200/_plugins/_sm/policies/win-daily-policy \
      --header 'Content-Type: application/json' \
      --data '{
  "description": "Windows Daily snapshot policy",
  "creation": {
    "schedule": {
      "cron": {
        "expression": "0 1 * * *",
        "timezone": "America/Sao_Paulo"
      }
    }
  },
  "deletion": {
    "schedule": {
      "cron": {
        "expression": "0 2 * * *",
        "timezone": "America/Sao_Paulo"
      }
    },
    "condition": {
      "max_age": "7d",
      "max_count": 21,
      "min_count": 7
    }
  },
  "snapshot_config": {
    "date_format": "yyyy-MM-dd-HH:mm",
    "timezone": "America/Sao_Paulo",
    "indices": "windows*",
    "repository": "teste",
    "ignore_unavailable": "true",
    "include_global_state": "false",
    "partial": "true"
  }
}'
```

Consultando politica:
```
curl --request GET -u admin --url localhost:9200/_plugins/_sm/policies?pretty
```