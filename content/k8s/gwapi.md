# Gateway API

## Ref:

<https://kubernetes.io/docs/concepts/services-networking/gateway/>\
<https://gateway-api.sigs.k8s.io/>\
<https://gateway-api.sigs.k8s.io/guides/>\
<https://docs.nginx.com/nginx-gateway-fabric/install/manifests/>\
<https://docs.nginx.com/nginx-gateway-fabric/traffic-management/basic-routing/>

## Resumo

O API Gateway irá substituir o Ingress.

São 3 componentes:
- GatewayClass ou Gateway Controller
- Gateway
- Rotas 
  - HTTP
  - TCP
  - gRPC

## Como utilizar

### Deverá instalar um Gateway Controller, exemplo Nginx ou Traefik.

```
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.0.1" | kubectl apply -f -
```
```
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.0.1/deploy/crds.yaml
```
```
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.0.1/deploy/default/deploy.yaml
```

### Deverá criar um Gateway. (Este que irá fornecer o IP do LoadBalancer).

```
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: default
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
EOF
```

### Deverá criar uma Rota para aplicação:
```
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: appexample-route
spec:
  parentRefs:
  - name: default
  hostnames:
  - "app.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: appexample-svc
      port: 80
EOF
```
