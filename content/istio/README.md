# Istio - Resumo Técnico

## Ref:
<https://istio.io/latest/docs/overview/>\
<https://istio.io/latest/docs/setup/getting-started/>

## Service Mesh

- Pattern de Networking
- Arquitetura Distribuida
- Adicionar funcionalidades a Rede
- Comportamentos
- Gestão de tráfego
- Segurança
- Observabilidade
- Resiliência

## Introdução ao Istio
Istio é uma **Service Mesh** que fornece uma camada de controle de comunicação entre serviços em um cluster Kubernetes (ou ambiente híbrido). Ele abstrai a lógica de rede do código da aplicação, permitindo **observabilidade, segurança e controle de tráfego** sem modificar o código do serviço.

## Visão Geral sobre Service Mesh
Uma Service Mesh gerencia a comunicação **service-to-service** em arquiteturas distribuídas.  
Funções principais:
- **Descoberta de serviços**  
- **Balanceamento de carga inteligente**  
- **Controle de tráfego** (roteamento, retries, circuit breaking)  
- **Segurança ponta a ponta** (mTLS, autenticação, autorização)  
- **Observabilidade** (métricas, logs e traces distribuídos)  

Istio implementa isso via **sidecars Envoy**, injetados junto aos pods das aplicações.

## Componentes / Arquitetura
- **Envoy Proxy (Data Plane)**: Proxy sidecar que intercepta e gerencia todo o tráfego de entrada e saída dos serviços.  
- **istiod (Control Plane)**: Responsável por configurar os proxies e gerenciar certificados.  
  - **Pilot**: Distribui regras de roteamento e configuração de tráfego.  
  - **Citadel**: Gerencia identidades e certificados para mTLS.  
  - **Galley** (obsoleto): Validação e distribuição de configuração (removido em versões recentes).  
- **Ingress/Egress Gateway**: Proxies especializados que controlam entrada e saída de tráfego no mesh.  

Fluxo:  
`istiod` aplica políticas e configurações → `Envoy` executa → tráfego é monitorado e controlado sem impacto direto no app.

## Envoy
É o proxy de dados do Istio:
- Implementa L3/L4 e L7.  
- Suporta HTTP/1.1, HTTP/2, gRPC.  
- Coleta métricas, logs e traces.  
- Aplicação de filtros de tráfego, autenticação, rate limiting e fault injection.  
Altamente configurável e atualizado dinamicamente via APIs do Istio.

## Descoberta de novos Serviços

A descoberta de serviços e endpoints no Istio é feita de forma dinâmica, através do xDS API (Envoy Discovery Service), um conjunto de APIs de controle que o istiod usa para manter os proxies Envoy atualizados.

Esses canais usam gRPC bidirecional entre cada sidecar (istio-proxy) e o control plane (istiod).

O Istio não faz polling. Ele é reativo e orientado a eventos.

### Fluxo:

O Kubernetes notifica o istiod (via Informers do API Server) sempre que um Service ou EndpointSlice muda — novo pod, IP, label, porta, etc.

O istiod processa o evento e recalcula o conjunto de clusters/endpoints afetados.

Ele envia via xDS push (gRPC stream) as atualizações apenas aos sidecars interessados (scoped push).

Ou seja, a descoberta é instantânea, depende do evento no Kubernetes, não há intervalo fixo de sincronização.

### Frequência e comportamento das atualizações

Atualizações são event-driven (baseadas em mudanças no Kubernetes API).

O istiod mantém uma conexão gRPC streaming aberta com cada sidecar Envoy.

Quando algo muda (novo pod, label, endpoint, rule), o control plane envia um PUSH delta.

O Envoy aplica a atualização em tempo real, geralmente < 1 segundo de latência.

Não há um polling interval fixo, mas existem timers internos de debounce para evitar excesso de push:

PushThrottle ou debounce padrão: cerca de 100–500ms entre eventos consecutivos (configurável via PILOT_PUSH_THROTTLE ou PILOT_DEBOUNCE_AFTER).

Em ambientes muito dinâmicos, isso evita tempestade de atualizações.

### Descoberta de Endpoints (EDS)

O EDS atualiza dinamicamente os IPs dos pods disponíveis para um serviço.

Por exemplo, se um Deployment escala de 3 para 5 réplicas:

O Kubernetes gera novos EndpointSlices.

O istiod detecta o evento via Watch.

Ele envia o novo conjunto de endpoints para todos os Envoys que possuem esse cluster configurado.

O Envoy atualiza a lista de destinos sem precisar reiniciar nem reconectar.

Isso ocorre tipicamente em milissegundos a poucos segundos, dependendo da carga e do debounce.

### Cache e otimização

istiod mantém um cache incremental de configurações por proxy, para enviar apenas o delta (mudanças necessárias).

Envoy também faz cache local de clusters e endpoints — se uma configuração não muda, ela não é retransmitida.

Isso torna o processo escalável e eficiente em grandes malhas (>10k pods).

## Istio + Observabilidade
Istio coleta métricas, logs e traces automaticamente via Envoy, integrando-se a ferramentas como:
- **Prometheus** (métricas)
- **Grafana** (dashboards)
- **Jaeger / Zipkin** (tracing)
- **Kiali** (visão gráfica da topologia do mesh)

Esses dados permitem monitorar latência, erros, tentativas e dependências entre serviços.

## Istio Sidecar Injection

Existem duas formas de injetar o proxy Envoy nos pods:

- **a) Automática (recomendada)**

Basta rotular o namespace para que o Istio injete automaticamente o proxy nos novos pods:
```
kubectl label namespace default istio-injection=enabled
```
Agora, sempre que um pod for criado nesse namespace, o Istio adicionará automaticamente o container istio-proxy (Envoy) junto ao container da aplicação.

- **b) Manual**

Caso a injeção automática não esteja habilitada, é possível injetar manualmente antes do deploy:
```
istioctl kube-inject -f deployment.yaml | kubectl apply -f -
```

## Gestão de Tráfego
Controle granular sobre como as requisições fluem:
- **VirtualService**: Define regras de roteamento (match, rewrite, mirror, etc.).  
- **DestinationRule**: Configura políticas de tráfego por destino (circuit breaking, load balancing, TLS).  
- **Gateway**: Gerencia tráfego de entrada/saída do cluster.

Exemplo de VirtualService:
```
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: reviews-route
  namespace: default
spec:
  hosts:
  - reviews
  http:
  - match:
    - uri:
        prefix: /api/reviews
    route:
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
      retryOn: 5xx,connect-failure,refused-stream
    fault:
      delay:
        percentage:
          value: 5.0
        fixedDelay: 2s
```
Exemplo de DestinationRule
```
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: reviews-destination
  namespace: default
spec:
  host: reviews.default.svc.cluster.local
  trafficPolicy:
    loadBalancer:
      simple: ROUND_ROBIN
    connectionPool:
      tcp:
        maxConnections: 100
      http:
        http1MaxPendingRequests: 50
        maxRequestsPerConnection: 10
    outlierDetection:
      consecutive5xxErrors: 5
      interval: 5s
      baseEjectionTime: 15s
      maxEjectionPercent: 50
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
```
Permite blue/green, canary releases, e roteamento baseado em headers, paths, ou versão do serviço.

## Roteamento de Tráfego Avançado
Permite manipulação detalhada do tráfego:
- **Weighted routing**: Distribui porcentagem de tráfego entre versões (v1:80%, v2:20%).  
- **Request mirroring**: Clona requisições para teste de novas versões.  
- **Timeouts e retries**: Regras de resiliência.  
- **Circuit breakers**: Evita sobrecarga em serviços degradados.  
- **Outlier Detection**: Remoção de instâncias problemáticas.

Exemplo – DestinationRule com Resiliência e Tolerância a Falhas:
```
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: reviews-destination
  namespace: default
spec:
  host: reviews.default.svc.cluster.local
  trafficPolicy:
    # --- Balanceamento de carga ---
    loadBalancer:
      simple: ROUND_ROBIN
      # Alternativamente:
      # consistentHash:
      #   httpHeaderName: "x-user-id"

    # --- Pool de conexões ---
    connectionPool:
      tcp:
        maxConnections: 100                # Máximo de conexões TCP simultâneas
        connectTimeout: 3s                 # Tempo limite para estabelecer conexões
      http:
        http1MaxPendingRequests: 50        # Requisições aguardando conexão
        maxRequestsPerConnection: 10       # Evita conexões muito longas (keep-alive)
        idleTimeout: 30s

    # --- Circuit Breaker ---
    outlierDetection:
      consecutive5xxErrors: 5              # Após 5 erros 5xx consecutivos
      interval: 5s                         # Verifica a cada 5 segundos
      baseEjectionTime: 15s                # Tempo de isolamento da instância com falha
      maxEjectionPercent: 50               # No máximo 50% das instâncias podem ser removidas

    # --- Timeout e Retentativas (comportamento de cliente) ---
    # Observação: esses campos normalmente são definidos no VirtualService.
    # Aqui apenas ilustramos a configuração no destino.
    portLevelSettings:
    - port:
        number: 80
      connectionPool:
        http:
          maxRequestsPerConnection: 5
      outlierDetection:
        consecutive5xxErrors: 3
        interval: 10s
        baseEjectionTime: 30s

  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
```
### Explicação dos principais blocos
### 1. loadBalancer

Define o algoritmo de distribuição de requisições entre as instâncias.
- ROUND_ROBIN: padrão, alterna entre instâncias.
- LEAST_CONN: envia para a instância com menos conexões.
- RANDOM: escolha aleatória.
- CONSISTENT_HASH: mantém afinidade com base em cabeçalho (útil para sessões).

### 2. connectionPool

Controla como o Envoy gerencia conexões com o destino:
- Limita número máximo de conexões TCP.
- Define quantas requisições HTTP simultâneas cada conexão pode suportar.
- Define tempo ocioso antes de fechar conexões.

### 3. outlierDetection (Circuit Breaker)

Monitora endpoints do serviço e ejeita (remove) instâncias com falhas repetidas:
- consecutive5xxErrors: número de erros 5xx consecutivos para marcar instância como ruim.
- interval: frequência da checagem.
- baseEjectionTime: tempo mínimo em que a instância fica fora do pool.
- maxEjectionPercent: proteção para não remover todas as instâncias ao mesmo tempo.

Esse mecanismo evita que requisições continuem sendo enviadas a pods com falha.

### 4. subsets

Permite definir políticas diferentes por versão (v1, v2, etc.), usadas em conjunto com VirtualService para:

- Fazer canary deployments (dividir tráfego).
- Aplicar políticas diferentes (timeouts, balanceamento, etc.) por versão.

### 5. portLevelSettings

Permite granularidade por porta.
Você pode definir diferentes timeouts, pools, e circuit breakers por porta específica.

Exemplo de uso combinado com VirtualService
```
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: reviews-route
spec:
  hosts:
  - reviews
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
      retryOn: 5xx,connect-failure,refused-stream
```
Aqui, o VirtualService define retentativas (retries) e timeout no tráfego, enquanto o DestinationRule define circuit breaking e pool de conexões no lado do cliente.

### Injeção de falhas e atrasos
Simula cenários de falha:
- **Fault injection**: Introduz erros HTTP ou gRPC intencionais.  
- **Delays**: Adiciona latência artificial para testar comportamento sob lentidão.  
Essencial para testes de resiliência e chaos engineering.

## Recurso Sidecar (Custom Resource Definition)

O recurso Sidecar (CRD networking.istio.io/v1alpha3) define como o proxy Envoy se comporta para um determinado workload (ou grupo de workloads).
Ele controla o escopo de configuração visível para aquele sidecar, ou seja:

- Quais serviços e namespaces ele pode alcançar (egress).
- Quais portas ele deve expor para tráfego de entrada (ingress).
- Como o tráfego é roteado (qual rota, cluster, listener o proxy mantém em cache).
- Sem esse recurso, o Istio aplica o comportamento padrão:
- Cada proxy conhece todos os serviços e endpoints do mesh (visão global).

Isso é funcional, mas ineficiente em grandes clusters, pois cada sidecar mantém uma tabela de roteamento gigantesca, com milhares de entradas que não usa.

### Benefícios de usar o recurso Sidecar

- Escalabilidade: reduz a quantidade de configurações que o istiod precisa enviar para cada Envoy.
- Performance: menos listeners e clusters no proxy = menor uso de CPU e memória.
- Segurança: restringe o que o workload pode acessar (limita superfície de ataque).
- Isolamento lógico: workloads só “veem” os serviços que realmente precisam.

Estrutura básica:
```
apiVersion: networking.istio.io/v1alpha3
kind: Sidecar
metadata:
  name: <nome>
  namespace: <namespace>
spec:
  workloadSelector:
    labels:
      app: <workload>
  ingress:
  - port:
      number: 8080
      protocol: HTTP
      name: http
    defaultEndpoint: 127.0.0.1:8080
  egress:
  - hosts:
    - "./*"
    - "istio-system/*"
```
Exemplo: Permitir acesso a outro namespace:
```
apiVersion: networking.istio.io/v1alpha3
kind: Sidecar
metadata:
  name: allow-monitoring-egress
  namespace: default
spec:
  workloadSelector:
    labels:
      app: backend
  egress:
  - hosts:
    - "./*"
    - "istio-system/*"
```
O backend pode se comunicar com:

- Serviços do próprio namespace (./*)
- Serviços do namespace istio-system (como Prometheus, Telemetry, etc.)
- Qualquer outro destino será bloqueado.

## Segurança
Camada de segurança integrada sem alterar código da aplicação:
- **Autenticação mTLS automática** entre sidecars.  
- **Autorização baseada em políticas** (RBAC e ABAC).  
- **Rotação automática de certificados**.  

## Autenticação
Istio suporta:
- **Peer authentication** (entre serviços): via mTLS.  
- **Request authentication** (usuários): valida tokens JWT ou OIDC.  
Pode ser combinada para validar identidade da aplicação e do usuário.

## AuthorizationPolicy
O recurso AuthorizationPolicy implementa controle de acesso baseado em identidade (RBAC) dentro do Istio.
Ele define quem pode acessar o quê (usuário, serviço, namespace), como (método HTTP, porta, caminho), e em que contexto (origem, destino, namespace).

### Como funciona

O Istio aplica essas políticas no Envoy sidecar de cada workload.
Cada requisição é avaliada localmente conforme as regras declaradas — sem precisar de um serviço central de autorização.

Por padrão, se não existir nenhuma AuthorizationPolicy, o tráfego é permitido (modo permissivo).
Assim que uma política é aplicada a um workload, o comportamento se torna "default deny" — apenas o que for explicitamente permitido é aceito.

Exemplo: Bloquear todo acesso por padrão
```
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: deny-all
  namespace: default
spec:
  selector:
    matchLabels:
      app: reviews
  action: DENY
  rules:
  - {}
```

Exemplo 2: Permitir apenas acesso do serviço `productpage`
```
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: allow-productpage
  namespace: default
spec:
  selector:
    matchLabels:
      app: reviews
  action: ALLOW
  rules:
  - from:
    - source:
        principals: ["cluster.local/ns/default/sa/productpage"]
```
Exemplo 3: Permitir apenas métodos HTTP especificos:
```
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: allow-get
  namespace: default
spec:
  selector:
    matchLabels:
      app: data-service
  action: ALLOW
  rules:
  - to:
    - operation:
        methods: ["GET", "HEAD"]
        paths: ["/api/data*"]
```


## TLS
O **mTLS** é gerenciado pelo Istio de forma automática:
- Certificados x.509 provisionados e rotacionados por **Citadel** (agora dentro do `istiod`).  
- Comunicação criptografada ponta a ponta sem necessidade de configuração manual.  
- Modos: `PERMISSIVE`, `STRICT`, `DISABLE` controlam exigência do mTLS por namespace ou workload.

## Integrando Serviços Externos
Istio pode controlar tráfego para fora do cluster:
- **Egress Gateway**: canaliza tráfego externo (ex.: APIs públicas, bancos, SaaS).  
- **ServiceEntry**: registra serviços externos para observabilidade e controle de políticas.  
- **TLS origination**: Permite que o Envoy inicie conexões seguras para destinos fora do mesh.

## ServiceEntry

O recurso ServiceEntry permite registrar serviços externos (fora do mesh ou fora do cluster Kubernetes) dentro do contexto do Istio, como se fossem serviços internos.
Isso é necessário porque o Istio só conhece os serviços registrados no Kubernetes (Service), e qualquer comunicação para fora precisa ser explicitamente declarada.

Além disto, é possível fazer Failover de serviços para outro Cluster, outra Região, etc.

### Principais usos:

- Permitir que workloads do mesh acessem APIs externas (Google, GitHub, bancos, SaaS).
- Tornar serviços externos observáveis e sujeitos a políticas (mTLS, logs, métricas, rate limit).
- Configurar Egress Control via Egress Gateway.
- Fazer TLS origination (Envoy inicia a conexão TLS para o destino externo).

Exemplo: Permitir acesso a uma API externa.
```
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: github-api-external
  namespace: default
spec:
  hosts:
  - api.github.com
  ports:
  - number: 443
    name: https
    protocol: HTTPS
  resolution: DNS
  location: MESH_EXTERNAL
```
Exemplo: Failover outra região dynamodb
```
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: dynamodb-global
  namespace: default
spec:
  hosts:
  - dynamodb.amazonaws.com
  location: MESH_EXTERNAL                 # Serviço fora do cluster
  resolution: STATIC                      # Endpoints definidos manualmente
  ports:
  - number: 443
    name: https
    protocol: TLS

  endpoints:
  - address: dynamodb.us-east-1.amazonaws.com
    ports:
      https: 443
    labels:
      region: us-east-1
  - address: dynamodb.us-west-2.amazonaws.com
    ports:
      https: 443
    labels:
      region: us-west-2
```

# Comandos / Diagnostico

Para inspecionar o estado de descoberta em execução:
```
istioctl proxy-config endpoints <pod_name>.<namespace>
```

Para ver clusters e listeners:
```
istioctl proxy-config clusters <pod_name>.<namespace>
istioctl proxy-config listeners <pod_name>.<namespace>
```

# Ver mais:

- Kiali
- K6
