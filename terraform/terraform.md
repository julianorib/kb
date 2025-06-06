# Terraform / Opentofu Cheat Sheet

### Quick Reference

<https://opentofu.org/docs/cli/commands/>\
<https://github.com/devops-cheat-sheets/terraform-cheat-sheet>


| Comando | Descrição |
|---------|-----------|
| terraform init | Iniciar um projeto |
| terraform init -backend-config environment/dev/backend.tfvars | Iniciar um projeto com backend remoto |
| terraform fmt | Formatar corretamente um projeto |
| terraform validate | Validar syntaxe do projeto |
| terraform plan | Planejar - Não será criado/excluido nada |
| terraform apply | Aplicar - Será criado/atualizado/ |
| terraform apply -var-file=environment/dev/terraform.tfvars | Aplicar projeto apontando um arquivo de variável diferente |
| terraform console | Testar funções |
| terraform import | Importar um recurso criado manualmente |
| terraform state | Consultar / Manipular o state do projeto |
| terraform workspace | Reaproveitar projeto em diferentes ambientes |
| terraform destroy | Destruir um projeto |


### Backend AWS

`backend.tf`
```
terraform {
  backend "s3" {
  }
}
```

`environment/dev/backend.tfvars`
```
bucket = "seubucket"
key = "terraform/dev/state"
region = "us-east-1"
```

### Template User data 

`efs.tlp`
```
#!/bin/bash

yum install -y amazon-efs-utils

mkdir /mnt/nfs

mount -t efs ${EFS}:/ /mnt/nfs
echo ${EFS}:/ /mnt/nfs efs _netdev,noresvport 0 0
```

`Resource aws_instance`
```
resource "aws_instance" "amazonlinux" {
  ami             = data.aws_ami.amzn-linux-2023-ami.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.main.key_name
  subnet_id       = aws_subnet.private-1a.id
  security_groups = [aws_security_group.linux.id]
  tags            = merge({ Name = format("%s-ec2-amazonlinux", var.project_name) }, local.common_tags)
    user_data = base64encode(templatefile("${path.module}/templates/wp.tpl", {
    EFS    = aws_efs_file_system.main.id
  }))
}
```