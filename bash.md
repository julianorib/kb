# Bash exemplos

<https://devhints.io/bash>

## Loops
```
#!/bin/bash
for i in {1..25}; do
        echo $i
done
```

```
for server in $(cat servers.txt); do
    echo $server
done
```

```
#!/bin/bash

i=1

while [[ $i -le 20 ]]; do
        echo $i
        (( i += 1))
done
```

## Condicionais
```
#!/bin/bash

read -p "informe um numero" num

if [[ $num < 10 ]]; then
        echo $num is maior que 10
else
        echo $num é menor que 10
fi
```

```
#!/bin/bash

if [[ -e /tmp/teste.txt ]]; then
        echo "Arquivo existe"
fi
```
