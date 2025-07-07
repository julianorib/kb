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