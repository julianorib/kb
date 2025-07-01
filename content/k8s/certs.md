# Kubeadm certs

https://kubernetes.io/pt-br/docs/reference/setup-tools/kubeadm/kubeadm-certs/

O kubeadm certs fornece os utilitários para gerenciar os certificados.

Este comando verifica a expiração dos certificados na PKI local gerenciada pelo kubeadm.
```
kubeadm certs check-expiration
```

# Secret TLS

```
kubectl create secret tls domain-secret --cert=certificado.crt --key=certificado-key.pem
```