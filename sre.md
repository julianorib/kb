# SRE - Site Reliability Engineering

SRE é uma abordagem criada pelo Google para aplicar princípios da engenharia de software à infraestrutura e operações, com o objetivo de garantir sistemas altamente escaláveis, confiáveis e eficiente


## Ref:
<https://sre.google/>\
<https://www.redhat.com/pt-br/topics/devops/what-is-sre>\
<https://www.youtube.com/watch?v=DNuSRFIAgxQ>\
<https://www.youtube.com/watch?v=5fT36r9Fiqg>



## Principios 

- Confiabilidade
- Escalabilidade
- Eficiência
- Desempenho
- Erros são normais
- Automatização
- Mensurar
    - SLI - Service Level Indicator
    - SLO - Service Level Objective
    - SLA - Service Level Agreement
    - Error Budget - Orçamento de Erros
- Monitoramento / Observabilidade
- Gerenciar Incidentes e Post Mortem
- Controle de Mudanças


## Como aplicar (básico)

### 1 Definir o que é confiável

- Identificar serviços, aplicações criticas
- Definir SLI, SLO, SLA.

### 2 Definir o orçamento de Erros

- Calcule com base no SLO.
- Se houver estouro de indisponibilidade
    - Pause deploys, releases. 
    - Foque em resolver o problema, ganhar Confiabilidade novamente.

### 3 Observabilidade

- Colete métricas
- Logs estruturados, centralizados
- Traces
- Notificações
- Correções automáticas

### 4 Automatize operações

- Deploys 
- Autoscaling
- Scripts para tarefas repetitivas

### 5 Resposta a incidentes

- Runbooks com procedimentos para lidar com problemas conhecidos
- Gerenciar incidentes
- Identifique causa raiz
- Post mortem sem culpa

### 6 Gerencie Mudanças

- Canary
- Blue/Green
- Testes automatizados

### 7 Fomentar a cultura DevOps

- Reuniões conjuntas com times de dev, ops, produto, etc
- Compartilhar resultados mensais/ trimestrais.

