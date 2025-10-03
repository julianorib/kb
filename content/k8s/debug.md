# Kubectl debug

O kubectl debug cria um pod de depuração ou adiciona um container auxiliar (ephemeral container) dentro do pod problemático.\
Isso é útil porque o container original pode não ter ferramentas como sh, ps, top, strace, etc.

## Ref:
<https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/>

## Comando
```
kubectl debug -it <podname> --target=<containername>  --image=ubuntu --share-processes --profile=sysadmin
```

