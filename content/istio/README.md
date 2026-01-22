# Istio — Resumo Técnico (SRE / DevOps)

## Referências

* [https://istio.io/latest/docs/overview/](https://istio.io/latest/docs/overview/)
* [https://istio.io/latest/docs/setup/getting-started/](https://istio.io/latest/docs/setup/getting-started/)
* [https://www.youtube.com/watch?v=wJrwZFA-iZ8](https://www.youtube.com/watch?v=wJrwZFA-iZ8)

---

## 1. O que é Service Mesh

**Service Mesh** é um *pattern de networking* para arquiteturas distribuídas que move responsabilidades de comunicação **do código da aplicação para a infraestrutura**.

### Capacidades principais

* Descoberta de serviços
* Balanceamento de carga inteligente
* Controle de tráfego (L7)
* Segurança ponta a ponta (mTLS)
* Observabilidade (métricas, logs, tracing)
* Resiliência (retries, circuit breaking, fault injection)

---

## 2. O que é o Istio

Istio é uma **Service Mesh** que atua como **camada de controle de comunicação** entre serviços, principalmente em Kubernetes.

**Objetivo:**
Adicionar **segurança, observabilidade e controle de tráfego** sem alterar o código das aplicações.

---

## 3. Arquitetura do Istio

### Visão Geral

* **Data Plane:** Envoy sidecars
* **Control Plane:** istiod
* **Gateways:** entrada e saída do mesh

![istio](istio.png)

### Componentes

#### Envoy Proxy (Data Plane)

* Intercepta todo tráfego **inbound/outbound**
* L3/L4/L7 (HTTP, gRPC, TCP)
* Aplica:

  * Roteamento
  * mTLS
  * Retries
  * Circuit breakers
  * Métricas e traces

#### istiod (Control Plane)

Responsável por:

* Distribuir configuração (xDS)
* Gerenciar certificados (mTLS)
* Validar e aplicar políticas

> Pilot, Citadel e Galley foram consolidados dentro do `istiod`.

#### Ingress / Egress Gateway

* **Ingress:** tráfego externo → mesh
* **Egress:** mesh → tráfego externo (controle e observabilidade)

---

## 4. Descoberta de Serviços (xDS)

### Como funciona

* Baseado em **eventos**, não polling
* Comunicação via **gRPC streaming**
* Atualizações incrementais (delta)

### Fluxo

1. Kubernetes gera evento (Service / EndpointSlice)
2. istiod processa a mudança
3. Push via xDS apenas para proxies afetados
4. Envoy aplica em tempo real

### Características

* Latência típica: **< 1 segundo**
* Push com debounce (100–500ms)
* Escalável para **10k+ pods**

### EDS (Endpoint Discovery Service)

* Atualiza IPs dinamicamente
* Não exige restart
* Suporte nativo a autoscaling

---

## 5. Observabilidade

Coletada automaticamente via Envoy.

### Integrações comuns

* **Prometheus:** métricas
* **Grafana:** dashboards
* **Jaeger / Zipkin:** tracing
* **Kiali:** topologia do mesh

### Métricas típicas

* Latência
* Taxa de erro
* Retries
* Dependência entre serviços

---

## 6. Sidecar Injection

### Automática (recomendada)

```bash
kubectl label namespace default istio-injection=enabled
```

### Manual

```bash
istioctl kube-inject -f deployment.yaml | kubectl apply -f -
```

---

## 7. Gestão de Tráfego (Core CRDs)

### Principais recursos

| Recurso         | Função                                  |
| --------------- | --------------------------------------- |
| VirtualService  | Define regras de roteamento             |
| DestinationRule | Define políticas de tráfego por destino |
| Gateway         | Entrada e saída do mesh                 |
| Sidecar         | Escopo de visibilidade do proxy         |

---

## 8. VirtualService

Define **como** o tráfego é roteado.

### Usos comuns

* Canary / Blue-Green
* Roteamento por header/path
* Retries e timeout
* Fault injection

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
spec:
  hosts: [reviews]
  http:
  - route:
    - destination:
        host: reviews
        subset: v1
      weight: 80
    - destination:
        host: reviews
        subset: v2
      weight: 20
    timeout: 3s
    retries:
      attempts: 2
      perTryTimeout: 2s
```

---

## 9. DestinationRule

Define **políticas do lado do cliente** (Envoy → destino).

### Principais blocos

#### Load Balancer

* ROUND_ROBIN
* LEAST_CONN
* RANDOM
* CONSISTENT_HASH

#### Connection Pool

* Limites de conexões TCP/HTTP
* Controle de keep-alive

#### Outlier Detection (Circuit Breaker)

* Remove instâncias com falhas
* Protege o serviço de cascata de erros

#### Subsets

* Versionamento (v1, v2)
* Base para canary

> **Regra prática:**
> *VirtualService controla o caminho da requisição*
> *DestinationRule controla como o cliente se comporta*

---

## 10. Sidecar CRD (Escopo do Proxy)

Controla **o que o proxy enxerga**, ou seja,\
O Sidecar CRD define o escopo de configuração que o Envoy enxerga.

- **Sem o Sidecar**, cada envoy conhece todos os serviços do mesh.
 - Cada envoy mantém milhares de clusters/listeners
 - Recebe pushs grandes
- **Com o Sidecar**, o envoy conhece apenas o necessário.
 - O envoy carrega serviços do próprio namespace
 - Serviços explicitamente permitidos
 - Push menor e mais rápido.

### Por que usar

* Reduz uso de CPU/memória
* Melhora tempo de push
* Aumenta segurança (menor superfície)

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Sidecar
spec:
  workloadSelector:
    labels:
      app: backend
  egress:
  - hosts:
    - "./*"
    - "istio-system/*"
```

---

## 11. Segurança

### mTLS

* Automático
* Certificados x.509
* Rotação automática
* Modos:

  * PERMISSIVE
  * STRICT
  * DISABLE

### Autenticação

* **PeerAuthentication:** identidade entre serviços
* **RequestAuthentication:** JWT / OIDC

---

## 12. AuthorizationPolicy (RBAC)

Define **quem pode acessar o quê**.

### Comportamento

* Sem policy → allow all
* Com policy → default deny

```yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
spec:
  selector:
    matchLabels:
      app: reviews
  action: ALLOW
  rules:
  - from:
    - source:
        principals:
        - cluster.local/ns/default/sa/productpage
```

---

## 13. Serviços Externos

### ServiceEntry

Registra serviços externos no mesh.

#### Casos de uso

* APIs públicas
* SaaS
* Multi-região / failover
* Observabilidade de egress

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
spec:
  hosts:
  - api.github.com
  location: MESH_EXTERNAL
  ports:
  - number: 443
    protocol: HTTPS
```

---

## 14. Diagnóstico

```bash
istioctl proxy-config endpoints <pod>.<ns>
istioctl proxy-config clusters <pod>.<ns>
istioctl proxy-config listeners <pod>.<ns>
```

---

## 15. Quando usar Istio (Visão SRE)

### Faz sentido quando:

* Muitos microsserviços
* Necessidade forte de mTLS
* Canary e controle fino de tráfego
* Observabilidade distribuída

### Evite quando:

* Poucos serviços
* Cluster pequeno
* Time não preparado para operar mesh
* Overhead operacional não justificado

---

## 16. Próximos tópicos recomendados

* Kiali (debug visual)
* Envoy filters
* Egress Gateway avançado
* Performance tuning do istiod
* k6 + Istio (resiliência)


