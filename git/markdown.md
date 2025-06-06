<br>

O Markdown é uma linguagem de marcação simples e fácil de usar que você pode usar para formatar praticamente qualquer documento.

Este guia mostra como formatar os itens mais utilizados.\
**Para isto, Edite este este guia e será exibido a esquerda o código(texto) com Markdown e a direita o código(texto) formatado.**

Referências:\
<https://www.markdownguide.org/>
<br>
<https://www.markdownguide.org/basic-syntax/>
___
### Títulos

# Título 1
## Título 2
### Título 3
#### Título 4
##### Título 5
___

### Bloco de Código

```
seu código aqui
```

```bash
#!/bin/bash
ps aux | grep bash
```

```powershell
Import-Module ActiveDirectory
$user = "fulano"
Get-ADUser $user -Properties *
```

```sql
use database xpto
select * from tabela;
```

___
### Formatação de Texto

Para quebrar uma linha utilize o \\ no final da linha.

Essa é a primeira Linha.\
e essa é a segunda linha.

**Texto em negrito aqui**.\
Seu texto **negrito** aqui.

*Texto em italico aqui*.\
Seu texto *italico* aqui.

***Texto negrito e italico***.\
Seu texto ***negrito e italico*** aqui.
___

### Caracter de Escape

Para cancelar a formatação de determinado item, coloque um \ antes do item.

\# Titulo 1

\`codigo`

___

### Links

[este é um link para o Google](https://google.com)

<https://google.com.br>

___

### Imagens

![Google](https://images.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png)

___

### Blocos destacados

> Aqui tem um bloco destacado.
___

### Palavras destacadas

Sua palavra `importante` aqui.
___

### Listas

- Item 1
- Item 2
- Item 3

<br>

- Item 1
  - Item 1.1
  - Item 1.2
- Item 2
  - Item 2.1
  - Item 2.2
- Item 3

___

### Sumários em mesma página

- [Item 1](#item1)
- [Item 2](#item2)
- [Item 4](#item3)

No titulo do item deve colocar uma tag entre chaves.

\# Item 1 {#item1}\
\# Item 2 {#item2}\
\# Item 3 {#item3}

___

### Sumários em páginas ou links externos.

- [Item 1](caminhoitem1.md)
- [Item 2](caminhoitem2.md)
- [Item 3](caminhoitem3.md)

___

### Tabelas

| Coluna 1   | Coluna 2   |
|------------|------------|
| Item 1.1   | Item 1.2   |
| Item 2.1   | Item 2.2   |

___
Se quiser contribuir, fique a vontade.