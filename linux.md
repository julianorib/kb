# Linux Cheat Sheet

| Comando | Descrição |
|---------|-----------|
| ls -dl .*/ | Listar somente pastas ocultas |
| find . -printf '%T@ %c %p\n' | sort -k 1 -n | cut -d' ' -f2- | teste |