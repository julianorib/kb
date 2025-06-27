# Kustomize

Uma forma de reaproveitar manifestos entre diferentes ambientes.\
Particularmente, prefiro o helm.

## Ref:
<https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/>\
<https://devopscube.com/kustomize-tutorial/>\
<https://kustomize.io/>


## Como usar

Mostra as modificações em tela, sem aplicar:
```
kubectl kustomize .
```

Aplica as modificações:
```
kubectl apply -k .
kubectl apply -k prod/
```

### Customizar

Necessário ter um arquivo `kustomization.yaml` na mesma pasta dos manifestos de sua aplicação.\
A melhor forma é utilizar `Overlays`.

Crie uma estrutura de pastas e arquivos conforme exemplo:
```
webapp
├── base
│   ├── deploy.yaml
│   ├── kustomization.yaml
│   └── service.yaml
├── dev
│   ├── kustomization.yaml
│   └── patch.yaml
└── prod
    ├── kustomization.yaml
    └── patch.yaml
```

#### Base

Deverá conter os manifestos originais da aplicação.
- deploy
- service
- configmap
- secrets
- etc

Criar um arquivo `kustomization.yaml` referenciando todos estes arquivos:
```
resources:
  - deploy.yaml
  - service.yaml
```

#### Dev

Deverá conter outro arquivo `kustomization.yaml` e os arquivos de modificações.\
No exemplo haverá `kustomization.yaml`:
```
resources:
  - ../base
patches:
  - path: patch.yaml
images:
  - name: nginx
    newTag: 1.27.5
```

E `patch.yaml`:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nginx
spec:
  replicas: 3
```

Basicamente, a customização irá buscar os arquivos originais no `base` e aplicar as mudanças do `patch.yaml.`\
Também tem algumas opções extras que se pode declarar direto no `kustomization.yaml` como:
- images
- commonLabels
- namePrefix
- ... entre outros

#### Prod
Deverá conter outro arquivo `kustomization.yaml` e os arquivos de modificações.\
No exemplo haverá `kustomization.yaml`:
```
resources:
  - ../base
patches:
  - path: patch.yaml
images:
  - name: nginx
    newTag: 1.27.0
```

E `patch.yaml`:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nginx
spec:
  replicas: 6
```


### Outra forma de Patch
`kustomization.yaml`
```
patches:
  - target:
      kind: Deployment
      name: nginx

    patch: |-
      - op: replace
        path: /metadata/name
        value: webapp
```

`kustomization.yaml`
```
patches:
  - target:
      kind: Deployment
      name: nginx

    patch: |-
      - op: replace
        path: /spec/replicas
        value: 5
```
