# ECS - Elastic Container Service

![ecs](aws-ecs.png)

## Componentes

- ECS Cluster
- Container Instances
	- Auto Scaling Group 
- Capacity Provider
- Task Definition
- Service
- Task


*Observação:*\
*Task Definition (semelhante a um Deployment do Kubernetes)*\
*Service (semelhante a um ReplicaSet do Kubernetes)*
*Task (semelhante a um Pod do Kubernetes)*


## HandsOn

1. Criar Cluster
- EC2
	- Auto scaling group
	- ondemand / spot
	- s.o Linux
	- instancia (t2.micro)
	- desired (max / min)
	- ebs
- VPC
	- subnets private
- Security Group


2. Criar uma task definition
- Launch type (requires compatibilities
- Network mode: awsvpc
- Task size: cpu e memory
- Task role: IAM role
- Task execution role: IAM role
- Container: 
	- name
	- imagem
	- container port
	- resource limits - none
	- environment
	- log
	- health check
	- etc

3. Service (dentro do Cluster)
- Compute configuration 
	- Launch Type EC2
- Task definition
	- Family (task criada no passo anterior)
- Service Type
	- Replica 2
- Networking
	- VPC
	- Subnets Publicas
	- Security Group
	- Aplication Load Balancer
		- Listener
