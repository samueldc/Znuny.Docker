#!/bin/sh
# Use only when binding project directory with /opt/otrs
docker exec -i -e PGPASSFILE=/.pgpass ${PWD##*/}_httpd_1 bash -c "pg_dump --host \$POSTGRES_HOST --port \$POSTGRES_PORT --username otrs --format custom --verbose --file /opt/otrs/docker/httpd/otrs.backup otrs"
