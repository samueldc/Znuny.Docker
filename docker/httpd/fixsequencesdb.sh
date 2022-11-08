#!/bin/sh
# Run database script to fix sequences
echo "Running fix sequences script"
PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -f /opt/otrs/docker/httpd/fixsequences.sql