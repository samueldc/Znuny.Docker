#!/usr/bin/bash
exec 3>&1 4>&2 >>/dev/null 2>&1
kubectl port-forward --address localhost,127.0.0.1,172.17.0.1 svc/postgres -n satus-prisma-otrs-tes 5432:5432 &
echo $!
docker-compose up -d
exec 1>&3 2>&4
while true; do
  nc -z -w 1 172.17.0.1 5432;
  sleep 5;
done