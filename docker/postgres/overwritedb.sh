#!/bin/sh
echo "Renaming public schema to public_prd"
PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "ALTER SCHEMA public RENAME TO public_backup;" >> /dev/null
echo "Creating new blank public schema"
PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "CREATE SCHEMA public;" >> /dev/null
echo "Restoring backup to public schema"
PGPASSFILE=/.pgpass pg_restore -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -F custom -n public --verbose -w -d otrs /opt/otrs/docker/postgres/otrs.backup >> /dev/null
