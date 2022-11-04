#!/bin/sh
echo "Renaming public schema to public_prd"
PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "ALTER SCHEMA public RENAME TO public_prd;" >> /dev/null
echo "Creating new blank public schema"
PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "CREATE SCHEMA public;" >> /dev/null
echo "Restoring backup to public schema"
PGPASSFILE=/.pgpass pg_restore -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -F custom -n public --verbose -w -d otrs /opt/otrs/docker/postgres/otrs.backup >> /dev/null
echo "Renaming public schema to public_dev"
PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "ALTER SCHEMA public RENAME TO public_dev;" >> /dev/null
echo "Renaming public_prd schema to public"
PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "ALTER SCHEMA public_prd RENAME TO public;" >> /dev/null
echo "Running merge script 1st time"
PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -f /opt/otrs/docker/postgres/mergeschemas.sql
echo "Running merge script 2nd time"
PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -f /opt/otrs/docker/postgres/mergeschemas.sql
echo "Running merge script 3nd time"
PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -f /opt/otrs/docker/postgres/mergeschemas.sql
echo "Droping public_dev"
PGPASSFILE=/.pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U otrs -d otrs -c "DROP SCHEMA public_dev CASCADE;" >> /dev/null