# Azure Commands

## Outros
- --no-wait
- --nsg ""
- --public-ip-address ""


## Login
```
az login
```

## VMs
```
rg=NomeGrupoRecursos
vm=NomeVM

az group create -n $rg -l brazilsouth

az vm create -g $rg -n $vm --image Win2022Datacenter --admin-username user --admin-password Su4s3nh4
az vm create -g $rg -n $vm --image debian --admin-username user --generate-ssh-keys --public-ip-sku basic
az vm create -g $rg -n $vm --image ubuntuLTS --admin-username user --ssh-key-value ~/.ssh/id_rsa.pub --public-ip-sku basic

az vm list -g $rg -o yaml

az vm show -g $rg -n $vm -o yaml
az vm show -g $rg -n $vm --query "name"
az vm show -d -g $rg -n $vm --query publicIps -o tsv

az vm run-command invoke -g $rg -n $vm --command-id RunShellScript --scripts "apt update"
az vm run-command invoke -g $rg -n $vm --command-id RunPowerShellScript --scripts "Get-Sevice"

az vm open-port --port 80 -g $rg -n $vm

az group delete -n $rg -y
```

## App Service
```
appplan=plano-containers
appservice=appservicecontainersapps
rg=grupoderecursos
local=brazilsouth

az appservice plan create -g $rg -n $appplan --sku FREE -l $local --is-linux
az appservice plan update -g $rg -n $appplan --sku B1
az appservice plan update -g $rg -n $applan --number-of-workers 2 


az webapp create -g $rg -p $appplan -n $appservice -i registry.com/imagem

az webapp browse -n $appservice -g $rg

az webapp deployment container config --enable-cd true -n $appservice -g $rg
az webapp deployment container show-cd-url -n $appservice -g $rg
az webapp deployment container show-cd-url -n $appservice -g $rg --quuery CI_CD_URL --output tsv

az webapp deployment slot create -n $appservice -g $rg --slot dev
az webapp deployment slot list -n $appservice -g $rg

az webapp deployment slot swap -g $rg -n $appservice --slot dev --target-slot production

az webapp traffic-routing set --distribution dev=50 -n $appserivce -g $rg
az webapp traffic-routing show -n $appservice -g $rg
az webapp traffic-routing clear -n $appservice -g $rg
```

## VNET
```
az network vnet create -n vnetname -g $rg -l brazilsouth --address-prefix 10.0.0.0/16 
az network vnet subnet create -n subnetname --vnet-name vnetname --address-prefixes 10.0.1.0/24

az network vnet list
az network vnet subnet list -g $rg --vnet-name vnetname -o table

az network vnet show -g $rg -n vnetname --query id -o tsv

az network vnet create -n vnetname -g $rg --address-prefix 10.0.0.0/16 --subnet-name bd --subnet-prefix 10.0.1.0/24 --subnet-name webapp --subnet-prefix 10.0.2.0/24

az network vnet subnet delete -n subnetname --vnet-name vnetname

az network vnet peering
```

## Peering
```
export MSYS_NO_PATHCONV=1

idvnet1=$(az network vnet show -g $rg1 -n vnetname1 --query id -o tsv)
idvnet2=$(az network vnet show -g $rg2 -n vnetname2 --query id -o tsv)

az network vnet peering create -n peering-vnet1-vnet2 -g $rg1 --vnet-name vnetname1 --remote-vnet $idvnet2 --allow-vnet-access
az network vnet peering create -n peering-vnet2-vnet1 -g $rg2 --vnet-name vnetname2 --remote-vnet $idvnet1 --allow-vnet-access
```

## VPN Site to Site
- VNET
- Subnet(GatewaySubnet) 
- Ip Publico
- Virtual Network Gateway (demora 1h)
- Local Network Gateway
    - Apontar para o IP da outra Ponta
    - Apontar Subrede da outra Ponta
- Connection

```
rg=rgname1
vnet=vnetname1
local=brazilsouth
subnet=subnet1

az group create -g $rg -l $local
az network vnet create -g $rg -n $vnet --address-prefixes 10.0.0.0/16 --subnet-name $subnet --subnet-prefixes 10.0.0.0/24

az network vnet subnet create -g $rg --vnet-name $vnet -n GatewaySubnet --address-prefixes 10.0.1.0/24

az network public-ip create -g $rg -n ipname --allocation-method Dynamic
az network public-ip show -g $rg -n ipname --query ipAddress -o tsv

az network vnet-gateway create -g $rg -n vnetgateway --public-ip-addresses ipname --vnet $vnet --gateway-type Vpn --vpn-type RouteBased --sku VpnGw1 --no-wait

az network vnet-gateway list -g $rg -o table

az network local-gateway create -g $rg -n localngw --gateway-ip-adderss ipnameOutraPonta --local-address-prefixes SubredeOutraPonta 

az network vpn-connection create -g $rg -n nomeConexao --vnet-gateway vnetgateway1 --local-gateway2 localngw --shared-key 123456
```

## IPs
```
az network public-ip list -g grupoderecursos --query "[].{IP:ipAddress}" --output tsv
```

## Hub/Spoke

Add peering 
Use the remote virtual network gateway or Route Server.
- Ip public
- Virtual Network Gateway
- Rota de uma Spoke para outra 

### Vnets e Subnets
```
az group create -g rghub -l brasilsouth
az network vnet create -g rghub -n vnethub --address-prefixes 10.0.0.0/16 --subnet-name subnethub --subnet-prefixes 10.0.0.0/24

az group create -g rgspoke1 -l eastus2
az network vnet create -g rgspoke1 -n vnetspoke1 --address-prefixes 10.1.0.0/16 --subnet-name subnetspoke1 --subnet-prefixes 10.1.0.0/24

az group create -g rgspoke2 -l eastus2
az network vnet create -g rgspoke2 -n vnetspoke2 --address-prefixes 10.2.0.0/16 --subnet-name subnetspoke2 --subnet-prefixes 10.2.0.0/24
```

### Bation
```
az network public-ip create -g rghub -n ipBastion --allowcation-method Dynamic
az network vnet subnet create -n AzureBastionSubnet -g rghub --vnet-name vnethub --address-prefix 10.0.1.0/26
az network bastion creatte -g rghub -n bastionHost --vnet-name vnethub --public-ip-address ipBastion
```

### Vnet Gateway
```
az network public-ip create -g rghub -n ipvnetgw --allowcation-method Dynamic
az network vnet subnet create -g rghub --vnet-name vnethub -n GatewaySubnet --address-prefix 10.0.255.0/27
az network vnet-gateway create -g rghub -n VnetGateway -l brazilsouth --public-ip-address ipvnetgw --vnet vnethub --gateway-type Vpn --sku VpnGw1 --vpn-type RouteBased
```

### Peering
```
export MSYS_NO_PATCHCONV=1
vnetIdhub   =$(az network vnet show -g rghub -n vnethub --query id -o tsv)
vnetIdspoke1=$(az network vnet show -g rgspoke1 -n vnetspoke1 --query id -o tsv)
vnetIdspoke2=$(az network vnet show -g rgspoke2 -n vnetspoke2 --query id -o tsv)

az network vnet peering create -g rgspoke1 -n peering-vnetspoke1-hub --vnet-name vnetspoke1 --remote-vnet vnetIdhub --allow-forwarded-trafic --allow-vnet-access --allow-gateway-transit --use-remote-gateways
az network vnet peering create -g rghub -n peering-hub-vnetspoke1 --vnet-name vnethub --remote-vnet vnetIdspoke1 --allow-forwarded-trafic --allow-vnet-access --allow-gateway-transit --use-remote-gateways

az network vnet peering create -g rgspoke2 -n peering-vnetspoke2-hub --vnet-name vnetspoke2 --remote-vnet vnetIdhub --allow-forwarded-trafic --allow-vnet-access --allow-gateway-transit --use-remote-gateways
az network vnet peering create -g rghub -n peering-hub-vnetspoke2 --vnet-name vnethub --remote-vnet vnetIdspoke2 --allow-forwarded-trafic --allow-vnet-access --allow-gateway-transit --use-remote-gateways
```

### Route Table
```
az network route-table create -g rgspoke1 -n rtspoke1
az network vnet subnet update -g rgspoke1 -n subnetspoke1 --vnet-name vnetspoke1 --route-table rtspoke1
az network route-table route create -g rgspoke1 -n routeSpoke1Spoke2 --route-table rtspoke1 --next-hop-type VirtualNetworkGateway --address-prefix 10.2.0.0/24

az network route-table create -g rgspoke2 -n rtspoke2
az network vnet subnet update -g rgspoke2 -n subnetspoke2 --vnet-name vnetspoke2 --route-table rtspoke2
az network route-table route create -g rgspoke2 -n routeSpoke2Spoke1 --route-table rtspoke2 --next-hop-type VirtualNetworkGateway --address-prefix 10.1.0.0/24
```

## NSG
```
az network nsg create --name NsgName -g rg --location brasilsouth
az network nsg rule create --name NsgRuleName --nsg-name NsgName -g rg --direction Inbound --priority 101 --protocol TCP --destination-port-range 80 --access Allow
    --source-address-prefixes '*' --destination-address-prefixes '*'
az network nsg list -g rg
az network nsg show --name NsgName -g rg
```

## Service Endpoint
```
az login
az group create -n RG -l brazilsouth

az network nsg create -n nsg -g rg

az network vnet create -g rg -n vnetname --address-prefixes 10.0.0.0/16 --subnet-name backend --subnet-prefixes 10.0.1.0/24 --network-security-group nsg --subnet-name frontend --subnetprefixes 10.0.2.0/24 --network-security-group nsg

az network vnet subnet update --vnet-name vnetname -g rg -n backend --service-endpoints Microsoft.Storage

az network nsg rule create -g rg --nsg-name nsg -n LiberarStorage --priority 100 --direction Outbound --source-address-prefixes "VirtualNetwork" --source-port-ranges "*" --destination-address-prefixes "Storage" --destination-port-ranges "*" --access Allow --protocol "*"

az storage account create -g rg -n NomeStorage --sku Standard_LRS

key=$(az storage account keys list --g rg --account-name NomeStorage --query "[0].value" | tr -d '"')

az storage share create --account-name NomeStorage --account-key $key -n fileShare

az storage account update -g rg -n NomeStorage --default-action Deny

az storage account network-rule add -g rg --account-name NomeStorage --vnet-name vnetname --subnet backend
```

## Azure Load Balancer
```
az network lb create -g rg -n lbname --sku Standard --vnet-name vnetName --subnet subnetName --frontend-ip-name frontName --backend-pool-name backName
az network lb proble create -g rg -n healthName --lb-name lbname --protocol tcp --port 80

az network lb rule create -g rg -n HTTPRule --lb-name lbname --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name frontName --backend-pool-name backName --probe-name healthName --idle-timeout 15 --enable-tcp-reset true

az network nic ip-config address-pool add -g rg --lb-name lbname --address-pool backName --ip-config-name ipconfig1 --nic-name nicVm1
az network nic ip-config address-pool add -g rg --lb-name lbname --address-pool backName --ip-config-name ipconfig1 --nic-name nicVm2
```

## Azure NAT Gateway
```
az network public-ip create -g rg -n IPNGW --sku Standard --zone 1 2 3
az network nat gateway create -g rg -n NatGateway --public-ip-address IPNGW --idle-timeout 10
az network vnet subnet update -g rg -n subnetName --vnet-name VnetName --nat-gateway NatGateway
```

