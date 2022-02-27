#!/bin/sh
kubectl exec -it $1 -- mkdir /var/lib/postgresql/backup
kubectl cp ../data/latest.dump $1:/var/lib/postgresql/backup 
kubectl exec -it $1 -- bash -c "pg_restore -U postgres -d finances -a -O -v /var/lib/postgresql/backup/latest.dump"
