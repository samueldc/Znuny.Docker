#!/bin/bash
set -e
# Script example
#psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
#  CREATE USER docker;
#  CREATE DATABASE docker;
#  GRANT ALL PRIVILEGES ON DATABASE docker TO docker;
#EOSQL
# OTRS database restore (uses only UNIX socket; do not define host and port)
if [[ -f "/docker-entrypoint-initdb.d/otrs.backup" ]]; then
  pg_restore -U "$POSTGRES_USER" -F custom -n public --verbose -O -cC --if-exists -d postgres /docker-entrypoint-initdb.d/otrs.backup
else
  echo "Warning: Backup file not found at /opt/otrs/docker/httpd/otrs.backup"
fi