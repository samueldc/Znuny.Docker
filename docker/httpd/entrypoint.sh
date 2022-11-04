#!/bin/bash
set -e

# Update file permissions
chown -R 5051:33 /opt/otrs
chmod -R g+rwx /opt/otrs

# Export environment variables to other users
export POSTGRES_DB=$POSTGRES_DB
export POSTGRES_USER=$POSTGRES_USER
export POSTGRES_PASSWORD=$POSTGRES_PASSWORD
export POSTGRES_HOST=$POSTGRES_HOST
export POSTGRES_PORT=$POSTGRES_PORT
export OTRS_FQDN=$OTRS_FQDN
export OTRS_HTTPTYPE=$OTRS_HTTPTYPE
export OTRS_NODEID=$OTRS_NODEID
export OTRS_ADMINEMAIL=$OTRS_ADMINEMAIL
printf "export POSTGRES_DB=$POSTGRES_DB\n" >> /etc/profile
printf "export POSTGRES_USER=$POSTGRES_USER\n" >> /etc/profile
printf "export POSTGRES_PASSWORD=$POSTGRES_PASSWORD\n" >> /etc/profile
printf "export POSTGRES_HOST=$POSTGRES_HOST\n" >> /etc/profile
printf "export POSTGRES_PORT=$POSTGRES_PORT\n" >> /etc/profile
printf "export OTRS_FQDN=$OTRS_FQDN\n" >> /etc/profile
printf "export OTRS_HTTPTYPE=$OTRS_HTTPTYPE\n" >> /etc/profile
printf "export OTRS_NODEID=$OTRS_NODEID\n" >> /etc/profile
printf "export OTRS_ADMINEMAIL=$OTRS_ADMINEMAIL\n" >> /etc/profile
#. /etc/profile

# Grants execution permission to merge database script
chmod u+x /opt/otrs/docker/postgres/mergedb.sh

# Creates postgres password file based on env variables
echo "$POSTGRES_HOST:$POSTGRES_PORT:$POSTGRES_DB:$POSTGRES_USER:$POSTGRES_PASSWORD" > /.pgpass
chmod 0600 /.pgpass

# Waits for postgres service to run up
while nc -z -w 1 $POSTGRES_HOST $POSTGRES_PORT 2> /dev/null; [[ $? -ne 0 ]]; do
  echo "Waiting postgres service";
  sleep 5;
done

# Waits for database to start up
while pg_isready -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB -q 2> /dev/null; [[ $? -ne 0 ]]; do
  echo "Waiting database startup";
  sleep 5;
done

# Runs erge database script
mergedb() {
  /opt/otrs/docker/postgres/mergedb.sh
}

# Runs migration script in case of upgrade
runmigration() {
  # Upgrade to 6.3.4: https://doc.znuny.org/manual/releases/installupdate/update/update-6.3.html
  su otrs -c '/opt/otrs/scripts/MigrateToZnuny6_3.pl'
  su otrs -c '/opt/otrs/bin/otrs.Console.pl Admin::Package::ReinstallAll'
  su otrs -c '/opt/otrs/scripts/MigrateToZnuny6_3.pl'
}

# Runs erge database script
overwritedb() {
  /opt/otrs/docker/postgres/overwritedb.sh
}

# Check if environment is local
OTRS_ENVIRONMENT=''
while getopts 'lmo' OPTION; do
  case "$OPTION" in
    l)
      OTRS_ENVIRONMENT='local'
      echo "Local OTRS environment => Will not merge database" # Used to prevent you from losing your local database changes
      ;;
    m)
      echo "Running migration scripts..."
      runmigration;
      ;;
    o)
      echo "Overwrites db with backup"
      overwritedb;
      ;;
    ?)
      # Do nothing else
      ;;
  esac
done

# If environment is not local...
if [[ $OTRS_ENVIRONMENT != 'local' ]]; then
  mergedb;
fi

# DBD::Oracle environment needed for DynamicFieldRemoteDB and Oracle databases
export ORACLE_HOME=/opt/oracle/instantclient_19_16
export PATH=$PATH:$ORACLE_HOME
export TNS_ADMIN=$ORACLE_HOME/network/admin
export LD_LIBRARY_PATH=$ORACLE_HOME
export NLS_LANG=American_America.UTF8
printf "export ORACLE_HOME=/opt/oracle/instantclient_19_16\n" >> /etc/profile
printf "export PATH=$PATH\n" >> /etc/profile
printf "export TNS_ADMIN=$ORACLE_HOME/network/admin\n" >> /etc/profile
printf "export LD_LIBRARY_PATH=$ORACLE_HOME\n" >> /etc/profile
printf "export NLS_LANG=American_America.UTF8\n" >> /etc/profile
ln -s /opt/otrs/.tnsnames.ora $TNS_ADMIN/tnsnames.ora
ln -s /opt/otrs/.sqlnet.ora $TNS_ADMIN/sqlnet.ora

# Rebuilds config
su otrs -c '/opt/otrs/bin/otrs.Console.pl Maint::Config::Sync'
su otrs -c '/opt/otrs/bin/otrs.Console.pl Maint::Config::Rebuild'

# Deletes cache
su otrs -c '/opt/otrs/bin/otrs.Console.pl Maint::Cache::Delete' # Not necessary for now

# Starts Cron
cron

# Starts Daemon through Cron
su otrs -c '/opt/otrs/bin/Cron.sh start'
#su otrs -c '/opt/otrs/bin/otrs.Daemon.pl start' # Removing this way because it doesn't recover from crashes

# Runs httpd
httpd-foreground