# VSCode Copilot

## Documentação:
https://code.visualstudio.com/docs/agent-customization/overview
https://github.com/github/awesome-copilot

## Modos:
- Ask : Questões, entendimento, sem modificações.
- Plan : Planejamento, para iniciar algo novo.
- Agent : Execução, criação, modificação de arquivos.

## Atalhos:
Executa comandos ou prompts
```
/init
/create*
```
Utiliza as definições do AgenteX para realizar algo.
```
@AgenteX
```

## Pastas
```
.github/
.github/agents
.github/copilot
.github/prompts
.github/skills
.github/tasks
.vscode/mcp.json

copilot-instructions.md
```

## MCPs
Para conectar um MCP no VSCode Copilot, crie uma pasta/arquivo dentro de seu projeto .vscode/mcp.json.
Pode começar com um do Dynatrace de exemplo:

### MCP Dyna
```
{
  "servers": {
    "mcp-dynatrace": {
      "command": "npx",
      "args": ["-y", "@dynatrace-oss/dynatrace-mcp-server@latest"],
      "env": {
        "DT_ENVIRONMENT": "https://nyr48864.apps.dynatrace.com",
        "DT_PLATFORM_TOKEN": "seu token",
        "DT_MCP_DISABLE_TELEMETRY": "true"
      }
    }
}
}
```
#### Como obter um DT_PLATFORM_TOKEN

- Acesse https://myaccount.dynatrace.com/platformTokens e clique em Criar Token.
	- Informe o Token name.
	- Expire on ou Never expires
	- Selecione a account (GCB)
	- Selecione os escopos  (marque todos READ)
		<https://github.com/dynatrace-oss/dynatrace-mcp> 

### MCP Kubernetes
```
{
  "servers": {
    "mcp-kubernetes": {
      "command": "npx",
      "args": [
        "mcp-server-kubernetes"
      ],
      "env": {
        "ALLOW_ONLY_NON_DESTRUCTIVE_TOOLS": "true"
      },
      "description": "Kubernetes cluster management and operations"
    }
}
}
```
