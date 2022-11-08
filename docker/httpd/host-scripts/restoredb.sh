#!/bin/sh
# Merge config tables data with data from previus backup
# Almost same behavior as mergedb.sh script, but to run on demand from the host
docker exec -i -e PGPASSFILE=/.pgpass ${PWD##*/}_httpd_1 bash -c "psql -h \$POSTGRES_HOST -p \$POSTGRES_PORT -U otrs -d otrs -c \"ALTER SCHEMA public RENAME TO public_prd; CREATE SCHEMA public; DROP SCHEMA public_dev CASCADE;\""
docker exec -i -e PGPASSFILE=/.pgpass ${PWD##*/}_httpd_1 bash -c "pg_restore -h \$POSTGRES_HOST -p \$POSTGRES_PORT -U otrs -F custom -n public --verbose -O -c --if-exists -d otrs /opt/otrs/docker/httpd/otrs.backup"
docker exec -i -e PGPASSFILE=/.pgpass ${PWD##*/}_httpd_1 bash -c "psql -h \$POSTGRES_HOST -p \$POSTGRES_PORT -U otrs -d otrs -c \"ALTER SCHEMA public RENAME TO public_dev; ALTER SCHEMA public_prd RENAME TO public;\""
docker exec -i -e PGPASSFILE=/.pgpass ${PWD##*/}_httpd_1 bash -c "psql -h \$POSTGRES_HOST -p \$POSTGRES_PORT -U otrs -d otrs -f /opt/otrs/docker/httpd/mergeschemas.sql"