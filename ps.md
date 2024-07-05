# Powershell Cheat Sheet

Ajuda:
```
Get-help 
Get-Help command
Get-Command
```

## Comuns
| Comando | Sinonimo | 
|---------|----------|
| findstr | grep |
| Set-Location | cd |
| Get-Content | cat |
| Get-Children | ls |
| Copy-Item | cp |
| Move-Item | mv |
| Remove-Item | rm |
| Start-Sleep | sleep |
| Invoke-WebRequest | curl |
| Set-Variable | set |
| Read-Host -Prompt | read |
| Write-Host | echo |
| Write-Host -ForegroundColor | Colorir texto |
| Write-Host -BackgroundColor | Colorir linha |
| Write-Error | halt |
| Write-Error "Erro" -ErrorAction Stop |  |
| Clear-Host | clear |
| Get-Location | pwd |
| Get-Credential | |

## Operadores

| Operador | Sinonimo |
|---------|----------|
| -eq | igual |
| -ne | não igual |
| -lt | menor que |
| -le | menor igual |
| -gt | maior que |
| -ge | maior igual |
| -like | como |
| -notlike | não como |
| -match | Coincide |
| -notmatch | não Coincide |
| -contains | contém |
| -notcontains | não Contém |
| =,+=,-=,++,-- | Atribuição |

## Variáveis
```
$string = "string"
```
```
$int = 10
```
```
[int]$var = 5
```
```
$text = @"
Serviço:
Criticidade:
Responsavel:
"@
```
```
$text2 = @"
Serviço: ${string}
Criticidade: ${string}
Valor: ${int}
"@
```
```
$temp = 10
$temp.tostring("D4")
0010
```
```
$ip = "10.1.1.0"
$ip -replace ".{1}$"
10.1.1.
```


## Formatação / Exportação

| Opção | Alias | Descrição | Exemplos |
|-------|-------|-----------|----------|
| Out-Null | | Ocultar mensagens | | 
| Select-Object | select | Exibir uma propriedade | select name, id |
| Format-Table | ft |  Formato Tabela | ft -HideTableHeaders -Wrap -Autosize |
| Format-List | fl | Formato lista | |
| Export-CSV | | Exportar para CSV | Export-CSV -Path example.csv -Delimiter ";" |
| Sort-Object | sort | Ordenar | | 
| Measure-Object | measure | Contar resultados | 

## Condicionais
```
Get-Service | Where-Object { $_.Status -eq "Stopped" }
Get-Service | Where-Object Status -EQ "Stopped"
Get-ADUser -Filter * | Where-Object {$_.name -like "Juliano*" -and $_.Enabled -eq $False}
```

## Fluxo

| Opção | Exemplo |
|-------|---------|
| if | if (condicao) { write-host OK } else { write-host NOT-OK } |
| for | for ($i = 0; $i -lt 10; $i++) { Write-Host Example $i }
| foreach | foreach ($x in (cat ips.txt)) { Write-Host $x } |
| "A","B" | foreach {$_} |
| 1..10 | foreach {$_} |
| while | while ($k -eq $null) { $k = Get-ADUser fulano } |
