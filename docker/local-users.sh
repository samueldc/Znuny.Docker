#!/usr/bin/bash
set -e
pwd
if [ `whoami` != 'root' ]; then
  echo "Must run as root!"
  exit 1
fi
if test -z "$1"; then
  echo "Must enter a user name"
  exit 1
fi
echo "Creating groups"
groupadd -g 5051 otrs
groupadd -g 33 www-data
groupadd -g 5050 pgadmin
echo "Creating user www-data"
useradd -g 33 -G 5051 -u 33 -M www-data
echo "Creating user otrs"
useradd -g 5051 -G 33 -u 5051 -M otrs
echo "Creating user postgres"
useradd -g 999 -u 999 postgres
echo "Creating user pgadmin"
useradd -g 5050 -u 5050 -M pgadmin
echo "Set group permissions to $1"
usermod -aG otrs,www-data,pgadmin $1