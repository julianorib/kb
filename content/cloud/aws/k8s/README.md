# EKS - Elastic Kubernetes Service

O Amazon Elastic Kubernetes Service (Amazon EKS) é um serviço gerenciado de Kubernetes que facilita a execução do Kubernetes na AWS e em ambientes on-premises. O Kubernetes é um sistema de código aberto com a finalidade de automatizar a implantação, a escalabilidade e o gerenciamento de aplicações conteinerizadas. A conformidade do Amazon EKS com o Kubernetes é certificada. Portanto, as aplicações existentes executadas no upstream do Kubernetes são compatíveis com o Amazon EKS.

O Amazon EKS gerencia automaticamente a disponibilidade e a escalabilidade dos nós do ambiente de gerenciamento do Kubernetes, que são responsáveis por programar contêineres, gerenciar a disponibilidade das aplicações, armazenar dados de cluster e outras tarefas principais.

O Amazon EKS permite executar suas aplicações do Kubernetes no Amazon Elastic Compute Cloud (Amazon EC2) e no AWS Fargate. Com o Amazon EKS, é possível aproveitar toda a performance, a escala, a confiabilidade e a disponibilidade da infraestrutura da AWS, assim como as integrações com os serviços de segurança e de redes da AWS, como balanceadores de carga da aplicação (ALBs) para distribuição de carga, integração do AWS Identity and Access Management (IAM) com o controle de acesso baseado em função (RBAC) e suporte à AWS Virtual Private Cloud (VPC) para redes de pod.

## Ref:
<https://aws.amazon.com/pt/eks/>\
<https://aws.amazon.com/pt/eks/features/>
<https://aws.amazon.com/pt/eks/pricing/>\
<https://docs.aws.amazon.com/pt_br/eks/latest/userguide/create-kubeconfig.html>

### ENI - Elastic Network Interfaces
<https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI>

## Valores
<https://aws.amazon.com/pt/eks/pricing/>


## eksctl
<https://eksctl.io/installation/>

### basic cluster
```
eksctl create cluster
```

### customized
`cluster.yaml`
```
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: my-cluster
  region: us-east-2

nodeGroups:
  - name: ng-1
    instanceType: t3.large
    desiredCapacity: 2
  - name: ng-2
    instanceType: m5.xlarge
    desiredCapacity: 2
```
```
eksctl create cluster -f cluster.yaml
```

### Visualizar o Cluster
```
eksctl get cluster
```

### Autoscaling

```
eksctl create cluster --name=MyCluster --nodes-min=3 --nodes-max=5
```

### Kubeconfig
```
eksctl utils write-kubeconfig --cluster mycluster --region us-east-2
```
```
aws eks update-kubeconfig --region region-code --name my-cluster
```

### Delete Cluster
```
eksctl delete cluster --name mycluster --region us-east-2
```


## Terraform

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster>

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group>

<https://registry.terraform.io/providers/-/aws/latest/docs/resources/eks_access_entry>


### Cluster EKS com Nodes Ondemand e Spot

[terraform](tf_example)

É criado um Cluster EKS com 2 grupos de autoscaling, sendo 1 ondemand e 1 spot.\
Este cluster tem acesso somente privado, e para acessá-lo, será necessário acessar uma outra Instância pública, que também é criado neste projeto.

Há algumas variáveis para alterar, caso sinta necessidade:

| variável | default | descrição |
|---|---|---|
| project_name | | nome para o projeto |
| region | | defina a região |
| user | | usuário que terá permissão de acesso ao cluster |
| tag-ambiente | test | ambiente do projeto |
| k8s_version | 1.32 | versão do kubernetes |
| eks_public_access | false | permitir acesso publico a api |
| eks_instance_types | t3.micro | instância dos nodes |
| eks_ondemand_desired | 2 | tamanho desejado de Nodes Ondemand |
| eks_ondemand_max | 3 | tamanho máximo de Nodes Ondemand |
| eks_ondemand_min | 1 | tamanho mínimo de Nodes Ondemand |
| eks_spot_desired | 2 | tamanho desejado de Nodes Spot |
| eks_spot_max | 3 | tamanho máximo de Nodes Spot |
| eks_spot_min | 1 | tamanho mínimo de Nodes Ondemand |


#### Acesso

Acesse via SSH a instância pública criada:
```
ssh -l ec2-user -i id_rsa <ippublic>
```
Configure as credenciais no `awscli`:
```
aws configure
```

Crie o kubeconfig:
```
aws eks update-kubeconfig --region region-code --name cluster-name
```

Verifique o cluster:
```
kubectl get nodes
kubectl get pods -A
```