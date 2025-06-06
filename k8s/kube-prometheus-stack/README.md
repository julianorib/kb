# Monitorar um Cluster Kubernetes.

### Kube Prometheus Stack
Essa stack já contém Prometheus, Grafana, Node Exporter, Prometheus-Operator.\
O Grafana vem com alguns dashboards bem completos.

<https://github.com/prometheus-operator/kube-prometheus>

```
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack --create-namespace -n monitoring
```
| Parametros | Descrição |
|---|---|
| --set grafana.enabled=false | Não instalar o Grafana |
| --set prometheus.service.type=LoadBalancer | Cria o serviço como LoadBalancer |


### Grafana

Grafana isolado.

<https://grafana.com/docs/grafana/latest/setup-grafana/installation/helm/>

```
helm upgrade --install grafana grafana/grafana -n monitoring --create-namespace 
```
| Parametros | Descrição |
|---|---|
| --set persistence.enabled=true | Habilita a persistencia de volume |
| --set persistence.storageClassName=nfs-client | Apontamento para o StorageClass NFS |
| --set service.type=LoadBalancer | Cria o serviço como LoadBalancer |

Obtem a senha do Grafana:
```
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

Dashs:
| ID | Description |
|---|---|
| 16966 | Container Log |
| 15757 | k8s-views-global |
| 15758 | k8s-views-namespace |
| 15759 | k8s-views-nodes |
| 15760 | k8s-views-nodes |


### Prometheus Operator

Prometheus Operator isolado.

<https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/getting-started.md#include-servicemonitors>


### Grafana Loki

Grafana Loki para armazenamento de Logs.

<https://grafana.com/docs/loki/latest/setup/install/helm/>

```
helm install loki grafana/loki -n monitoring --values loki.yaml 
```
| Parametros | Descrição |
|---|---|
| --set singleBinary.persistence.storageClass=nfs-client | Apontamento para o StorageClass NFS |

Para criar um Datasources no Grafana:
```
URL: http://loki-gateway.namespace
HTTP Headers: X-Scope-OrgID : 1
```

### Promtail

Promtail funciona para capturar os logs dos Nodes.

<https://grafana.com/docs/loki/latest/send-data/promtail/installation/>

