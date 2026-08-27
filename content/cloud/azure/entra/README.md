# Comandos uteis

## Service Principal
```
az ad sp --name "usuario" -role Contributor --scope /subscriptions/id
```
```
az ad sp list --display-name "usuario" -output table
az ad sp delete -id appId
```

## Groups
```
az ad group show --group 12345ab67-a1b2-c3d4-e6f7-123abc456def --query displayName -o tsv
az ad group list --query "[?contains(displayName, 'VV_CLOUD_SQUAD')].[displayName,id]" -o table
```

## Membros de um Grupo
```
az ad group member list --group 12345ab67-a1b2-c3d4-e6f7-123abc456def --query "[].{Nome:displayName,UPN:userPrincipalName,Id:id}" -o table
```
