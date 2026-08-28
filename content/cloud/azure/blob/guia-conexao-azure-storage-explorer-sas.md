# Guia — Conectar no Azure Storage Explorer usando SAS Token

> Guia rápido para conectar em um container de Azure Blob Storage usando uma **Shared Access Signature (SAS)** de container, via Azure Storage Explorer.
>
> ⚠️ **Todos os valores abaixo são fictícios.** Substitua pelos dados reais do seu ambiente antes de usar.

---

## 1. O que é uma SAS Token de container

Uma URL de SAS de container tem este formato:

```
https://<storage-account>.blob.core.windows.net/<container>?<parametros-sas>
```

Exemplo fictício:

```
https://stgexemploprd.blob.core.windows.net/meucontainer?sp=racwdl&st=2025-01-01T00:00:00Z&se=2025-12-31T23:59:59Z&spr=https&sv=2024-11-04&sr=c&sig=AAAAbbbbCCCCddddEEEEffff1234567890abcdEF%3D
```

### Parâmetros principais

| Parâmetro | Exemplo | Significado |
|---|---|---|
| `sp` | `racwdl` | Permissões: **r**ead, **a**dd, **c**reate, **w**rite, **d**elete, **l**ist |
| `st` | `2025-01-01T00:00:00Z` | Início da validade (UTC) |
| `se` | `2025-12-31T23:59:59Z` | Expiração da validade (UTC) |
| `spr` | `https` | Protocolo exigido (somente HTTPS) |
| `sv` | `2024-11-04` | Versão da API de Storage usada na assinatura |
| `sr` | `c` | Escopo do recurso: **c**ontainer |
| `sig` | `AAAAbbbb...%3D` | Assinatura HMAC-SHA256 (não editável, gerada com a chave da conta) |

> Se `sr=c`, é uma **SAS de container**. Se em vez disso aparecerem os parâmetros `ss=` (serviços) e `srt=` (tipos de recurso), é uma **Account SAS** — o fluxo de conexão no Storage Explorer é diferente (veja seção 4).

---

## 2. Montando a URL corretamente


Estrutura genérica:

```
https://<storage-account>.blob.core.windows.net/<container>?<query-string-da-sas-completa>
```

---

## 3. Passo a passo no Azure Storage Explorer

1. Abra o **Azure Storage Explorer**.
2. No painel esquerdo, clique com o botão direito em **Storage Accounts** → **Connect to Azure Storage...**
3. Na tela **"Select Resource"**, escolha **`Blob container`** (não `Storage account or service`).
4. Na tela **"Select Connection Method"**, escolha **`Shared access signature (SAS)`** → **`Blob container SAS URL`**.
5. Cole a **URL completa** (domínio + container + query string da SAS), por exemplo:
   ```
   https://stgexemploprd.blob.core.windows.net/meucontainer?sp=racwdl&st=2025-01-01T00:00:00Z&se=2025-12-31T23:59:59Z&spr=https&sv=2024-11-04&sr=c&sig=AAAAbbbbCCCCddddEEEEffff1234567890abcdEF%3D
   ```
6. Dê um nome de exibição para a conexão (ex.: `meucontainer-prd`).
7. Clique em **Next** → revise o resumo → **Connect**.
8. O container deve aparecer em: **Local & Attached → Storage Accounts → (Attached Containers) → Blob Containers → meucontainer**.

---

## 4. Erro comum: "O SAS não é um SAS de conta válido"

Mensagem completa:

> *O SAS não é um SAS de conta válido. Uma conta SAS com parâmetros de serviço ('ss') e tipo de recurso ('srt') é necessária.*

**Causa:** você selecionou o tipo de recurso **`Storage account or service`** na tela "Select Resource", mas a SAS que você tem é uma **SAS de container** (`sr=c`), não uma **Account SAS** (que teria `ss=` e `srt=`).

**Correção:** volte à etapa 3 do passo a passo acima e selecione **`Blob container`** como tipo de recurso, não `Storage account or service`.

| Tipo de SAS | Parâmetros característicos | Opção correta no Storage Explorer |
|---|---|---|
| SAS de container | `sr=c` | `Blob container` → `Blob container SAS URL` |
| SAS de blob | `sr=b` | `Blob container` (aponte para o container pai) ou conexão direta ao blob, se suportado |
| Account SAS | `ss=`, `srt=` | `Storage account or service` → `Shared access signature (SAS)` |

---

## 5. Cuidados operacionais

- **Permissões amplas** (`racwdl`) equivalem a controle total sobre o container: leitura, upload, sobrescrita e exclusão. Trate a URL completa como segredo.
- **Validade longa** (`se` muito no futuro) é risco de segurança — prefira SAS de curta duração, renovadas via automação, ou **User Delegation SAS** (assinada com Azure AD, revogável).
- Antes de qualquer operação de escrita/exclusão pelo Storage Explorer, confirme o ambiente (`prd` vs `hlg`) e o container correto.
- Se a SAS vazar (log, código, repositório), rotacione a chave da storage account que a assinou ou revogue via Stored Access Policy associada, e gere uma nova.
