#!/bin/sh
docker exec -i -e PGPASSFILE=/.pgpass ${PWD##*/}_httpd_1 bash -c "pg_dump --host \$POSTGRES_HOST --port \$POSTGRES_PORT --username otrs --format custom --verbose --file /opt/otrs/docker/postgres/otrs.backup otrs"
