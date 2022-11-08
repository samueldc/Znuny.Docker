#!/bin/sh
# Replaces current data with data from previous backup
if [[ -f "/opt/otrs/docker/httpd/otrs.backup" ]]; then
  echo "Renaming public schema to public_prd"
  PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "ALTER SCHEMA public RENAME TO public_backup;" >> /dev/null
  echo "Creating new blank public schema"
  PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "CREATE SCHEMA public;" >> /dev/null
  echo "Restoring backup to public schema"
  PGPASSFILE=/.pgpass pg_restore -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -F custom -n public --verbose -w -d otrs /opt/otrs/docker/httpd/otrs.backup >> /dev/null
else
  echo "Error: Backup file not found at /opt/otrs/docker/httpd/otrs.backup"
  return 1
fi
