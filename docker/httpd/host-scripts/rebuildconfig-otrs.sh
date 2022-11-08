#!/bin/sh
docker exec -i ${PWD##*/}_httpd_1 su otrs -c '/opt/otrs/bin/otrs.Console.pl Maint::Config::Rebuild'