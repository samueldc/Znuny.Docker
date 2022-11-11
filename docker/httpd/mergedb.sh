#!/bin/sh
# Merge config tables data with data from previus backup
if [[ -f "/opt/otrs/docker/httpd/otrs.backup" ]]; then
  echo "Renaming public schema to public_prd"
  PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "ALTER SCHEMA public RENAME TO public_prd;" >> /dev/null
  echo "Creating new blank public schema"
  PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "CREATE SCHEMA public;" >> /dev/null
  echo "Restoring backup to public schema"
  PGPASSFILE=/.pgpass pg_restore -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -F custom -n public --verbose -w -d otrs /opt/docker/httpd/otrs.backup >> /dev/null
  echo "Renaming public schema to public_dev"
  PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "ALTER SCHEMA public RENAME TO public_dev;" >> /dev/null
  echo "Renaming public_prd schema to public"
  PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "ALTER SCHEMA public_prd RENAME TO public;" >> /dev/null
  echo "Running merge script 1st time"
  PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -f /opt/docker/httpd/mergeschemas.sql
  echo "Running merge script 2nd time"
  PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -f /opt/docker/httpd/mergeschemas.sql
  echo "Running merge script 3nd time"
  PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -f /opt/docker/httpd/mergeschemas.sql
  echo "Droping public_dev"
  PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "DROP SCHEMA public_dev CASCADE;" >> /dev/null
else
  echo "Error: Backup file not found at /opt/otrs/docker/httpd/otrs.backup"
  return 1
fi