# jsonpath

```
kubectl get pods -o=jsonpath='{}'

kubectl get pods -o=jsonpath='{.items[*]}'
```

- `-o=jsonpath='{}'`
- `-o=jsonpath='{.items[*]}'`

items = cada pod ou deploy, etc

Dentro é cada chave de um manifesto:
- apiVersion
- kind
- metadata
- spec
- status

E os que possuem subchaves:
- spec
    - containers
    - volumes
    - etc

E cada item que tiver mais chaves dentro, vai seguindo.

```
-o=jsonpath='{.items[*].spec.containers[*].name}'
-o=jsonpath='{.items[*].spec.containers[*].resources.requests.cpu}'
```

### Interação

Extraindo mais de um valor por item, como uma tabela.

`-o=jsonpath='{range .items[*]}'`

```
-o=jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}'
```
```
-o=jsonpath='{range .items[*]}{.spec.containers[*].name}{"\t"}{.spec.containers[*].image}{"\n"}
```
```
kubectl get pods -A -o=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.startTime}{"\t"}{.status.phase}{"\n"}'
```

### Filtros[]

`-o=jsonpath='{.contexts[*]}'`

`-o=jsonpath='{.contexts[*].context.user}'`

`-o=jsonpath='{.contexts[?(@.context.user=="aws-user")].name}'`

**Basicamente tem que trocar o [*] por [?(@.chave=="valor")]**


### Custom Columns

É possível adicionar nome de coluna e organizar melhor a saída do que deseja exibir.

```
kubectl get nodes -o=custom-columns=NODE:.metadata.name,CPU:.status.capacity.cpu
```

`-o=custom-columns=NODE:.metadata.name`

`-o=custom-columns=NODE:.metadata.name,CPU:.status.capacity.cpu`


### Sort

```
kubectl get pv -o=custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage --sort-by=.spec.capacity.storage
```