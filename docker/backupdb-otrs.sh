#!/bin/sh
docker exec -i ${PWD##*/}_httpd_1 su otrs -c '/opt/otrs/scripts/backup.pl -d /opt/otrs/backup -t dbonly'
