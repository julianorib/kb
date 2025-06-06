# ETCD

## Backup e Restore

<https://medium.com/google-cloud/etcd-backup-and-restore-7a51cae4a689>

### Backup
```
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /opt/backup.db
```

### Restore
```
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot restore /opt/backup.db --data-dir="/var/lib/etcd-backup"
```

*Neste caso, foi alterado o data-dir. Portanto tem que alterar este valor no manifesto do ETCD.*
```
/etc/kubernetes/manifests/etcd.yaml
```

## Status Cluster

```
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key endpoint status -w table --cluster
```

## Limites

O tamanho máximo recomendado para o banco de dados etcd geralmente gira em torno de **8 a 10 GB**.



