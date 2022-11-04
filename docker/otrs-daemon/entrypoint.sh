#!/bin/bash
set -e
chown -R 5051:33 /opt/otrs
chmod -R g+rwx /opt/otrs
/usr/bin/supervisord