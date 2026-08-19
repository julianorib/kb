# Mandar mensagem para o Teams.

Para criar um Webhook de Chat/Canal, \
clique nos 3[...] do Chat, \
opção Fluxos de Trabalho, \
Escolha: Enviar alertas de Webhook para um chat.\
Defina o Chat e Clique em Salvar.

Depois acesse: https://make.powerautomate.com/\
No lado esquerdo, acesse "My Flows ou Fluxos".\
Clique no Fluxo e edite-o,\
Na última opção do Fluxo "Attachments is null", clique para visualizar mais (seta para baixo).

Clique em + e Informe os dados:\
Post message in a chat or channel.\
Post as: Flow bot\
Post in: Chat em Grupo\
Chat em Grupo: Escolha o Chat\
Mensagem: \
Aperte / no campo da mensagem e escolha Insert Expression: \
Coloque: triggerBody()?['text'] e clique em Add.\

Remova o Post Card in a chat or channel 1.\



Como testar:

Defina o webhook em uma variável, como exemplo:\
export TEAMS_WORKFLOW_URL=endereco_do_webhook

Defina uma mensagem em uma variável, como exemplo:\
MENSAGEM="Ola a todos!"

Execute um Curl:\
curl -s -w "%{http_code}" -X POST -H "Content-Type: application/json" -d "{\"text\": \"$MENSAGEM\"}" "$TEAMS_WORKFLOW_URL"
