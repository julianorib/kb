# Curl

### Buscar algo de uma URL
```
curl https://api.exemplo.com/dados
```

### Post (enviar dados)

```
curl -X POST https://api.exemplo.com/login -d "usuario=teste&senha=123"
```

Ou com JSON:
```
curl -X POST https://api.exemplo.com/login \
     -H "Content-Type: application/json" \
     -d '{"usuario":"teste", "senha":"123"}'

```

## Autenticação

### Basic Auth 
```
curl -u usuario:senha https://api.exemplo.com
```

### Token Bearer
```
curl -H "Authorization: Bearer SEU_TOKEN_AQUI" https://api.exemplo.com/dados
```

## Métodos

- GET: busca dados
- POST: envia dados (cria)
- PUT: atualiza completamente um recurso
- PATCH: atualiza parcialmente
- DELETE: apaga um recurso

```
curl -X DELETE https://api.exemplo.com/usuario/123 -H "Authorization: Bearer TOKEN"
``` 

## Options

-i: mostra os headers da resposta
-v: modo verboso (mostra tudo que está acontecendo)
-H: adiciona headers personalizados
-d: envia dados no corpo da requisição
-X: força o método HTTP (GET, POST etc)