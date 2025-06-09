# Estudos Cloud

## AWS
- [AWS IAM](aws/iam/README.md)
- [AWS S3](aws/s3/README.md)
- [AWS VPC](aws/vpc/README.md)
- [AWS EC2](aws/ec2/README.md)
- [AWS RDS](aws/rds/README.md)
- [AWS ECS](aws/ecs/README.md)
- [AWS K8S](aws/k8s/README.md)
- [AWS WELL](aws/well/README.md)
- [AWS Certificação Pratictioner](aws/certi/practitioner/README.md)


## Azure
- [Azure EntraID](azure/entra/README.md)
- [Azure Blob](azure/blob/README.md)
- [Azure VNET](azure/vnet/README.md)
- [Azure VirtualMachine](azure/virtualmachine/README.md)
- [Azure Database](azure/database/README.md)
- [Azure K8S](azure/k8s/README.md)



## AWS to Azure Service Equivalents

<https://learn.microsoft.com/en-us/azure/architecture/aws-professional/>

<https://github.com/sv222/aws-to-azure-service-equivalents>



## Diferenças de arquitetura entre AWS e Azure:
 
<https://techcommunity.microsoft.com/blog/startupsatmicrosoftblog/key-architectural-differences-between-aws-and-azure-explained/4244702>


## Github Actions with OpenID Connect 

Nunca coloque `access token` no código ou em variáveis do Github para fazer integração com CI-CD.\
Utilize o OpenID Connect, criando um provedor de identidade no Cloud, uma Role, e permissões.

### AWS
<https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services>

<https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services>

<https://mahendranp.medium.com/configure-github-openid-connect-oidc-provider-in-aws-b7af1bca97dd>

### Azure
<https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services>
