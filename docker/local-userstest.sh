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
if [ $(getent group otrs) ]; then
  echo "group otrs exists."
else
  groupadd -g 5051 otrs
fi
if [ $(getent group www-data) ]; then
  echo "group www-data exists."
else
  groupadd -g 33 www-data
fi
if [ $(getent group pgadmin) ]; then
  echo "group pgadmin exists."
else
 groupadd -g 5050 pgadmin
fi
echo "Creating user www-data"
if [ $(getent passwd www-data) ]; then
  echo "user www-data exists."
else
 useradd -g 33 -G 5051 -u 33 -M www-data
fi
echo "Creating user otrs"
if [ $(getent passwd otrs) ]; then
  echo "user otrs exists."
else
 useradd -g 5051 -G 33 -u 5051 -M otrs
fi
echo "Creating user postgres"
if [ $(getent passwd postgres) ]; then
  echo "user postgres exists."
else
 useradd -g 999 -u 999 postgres
fi
echo "Creating user pgadmin"
if [ $(getent passwd pgadmin) ]; then
  echo "user pgadmin exists."
else
 useradd -g 5050 -u 5050 -M pgadmin
fi
echo "Set group permissions to $1"
usermod -aG otrs,www-data,pgadmin $1