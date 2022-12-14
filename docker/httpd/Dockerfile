FROM debian:11 AS download
  RUN apt-get update \ 
      && apt-get install -y --no-install-recommends wget unzip \
      && apt-get clean
  ADD https://download.oracle.com/otn_software/linux/instantclient/1916000/instantclient-basic-linux.x64-19.16.0.0.0dbru.zip /opt/oracle/
  ADD https://download.oracle.com/otn_software/linux/instantclient/1916000/instantclient-sdk-linux.x64-19.16.0.0.0dbru.zip /opt/oracle/
  ADD https://download.oracle.com/otn_software/linux/instantclient/1916000/instantclient-sqlplus-linux.x64-19.16.0.0.0dbru.zip /opt/oracle/
  ADD https://download.oracle.com/otn_software/linux/instantclient/1916000/instantclient-odbc-linux.x64-19.16.0.0.0dbru.zip /opt/oracle/
  RUN unzip /opt/oracle/instantclient-basic-linux.x64-19.16.0.0.0dbru.zip -d /opt/oracle/
  RUN unzip /opt/oracle/instantclient-sdk-linux.x64-19.16.0.0.0dbru.zip -d /opt/oracle/
  RUN unzip /opt/oracle/instantclient-sqlplus-linux.x64-19.16.0.0.0dbru.zip -d /opt/oracle/
  RUN unzip /opt/oracle/instantclient-odbc-linux.x64-19.16.0.0.0dbru.zip -d /opt/oracle/
FROM httpd:2.4
  RUN ln -s /usr/local/apache2 /usr/lib/apache2
  RUN apt-get update \ 
      && apt-get install -y --no-install-recommends locales \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* \
      && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
  ENV LANG=en_US.utf8
  RUN apt-get update \ 
      && apt-get install -y --no-install-recommends perl libapache2-mod-perl2 \
      libdbd-mysql-perl libtimedate-perl libnet-dns-perl \
      libnet-ldap-perl libio-socket-ssl-perl libpdf-api2-perl libdbd-mysql-perl \
      libsoap-lite-perl libtext-csv-xs-perl libjson-xs-perl libapache-dbi-perl \
      libxml-libxml-perl libxml-libxslt-perl libyaml-perl libarchive-zip-perl \
      libcrypt-eksblowfish-perl libencode-hanextra-perl libmail-imapclient-perl \
      libtemplate-perl libdatetime-perl libmoo-perl libdbd-pg-perl \ 
      libhash-merge-perl libexcel-writer-xlsx-perl libauthen-sasl-perl \
      libcss-minifier-xs-perl libdbd-odbc-perl libjavascript-minifier-xs-perl \
      libauthen-ntlm-perl libspreadsheet-xlsx-perl libyaml-libyaml-perl \
      htop bash-completion postgresql-client netcat cron vim \
      odbcinst1debian2 libodbc1 odbcinst unixodbc \
      cpanminus build-essential libtest-nowarnings-perl \
      libaio1 libaio-dev \
      && apt-get clean
  RUN echo 'debconf freetds/addtoodbc select true' | debconf-set-selections
  RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends tdsodbc
  COPY --from=download /opt/oracle/instantclient_19_16 /opt/oracle/instantclient_19_16
  RUN ln -s /opt/oracle/instantclient_19_16/libclntshcore.so.19.1 /opt/oracle/instantclient_19_16/libclntshcore.so
  RUN ln -s /opt/oracle/instantclient_19_16/libsqora.so.19.1 /opt/oracle/instantclient_19_16/libsqora.so
  RUN ORACLE_HOME=/opt/oracle/instantclient_19_16 PATH=$PATH:/opt/oracle/instantclient_19_16 TNS_ADMIN=/opt/oracle/instantclient_19_16/network/admin LD_LIBRARY_PATH=/opt/oracle/instantclient_19_16 NLS_LANG=American_America.UTF8 cpanm DBD::Oracle
  RUN mkdir /opt/oracle/instantclient_19_16/log
  ARG OTRS_USER=otrs
  ARG OTRS_GROUP=www-data
  ENV OTRS_USER=${OTRS_USER}
  ENV OTRS_GROUP=${OTRS_GROUP}
  RUN groupadd -g 5051 ${OTRS_USER}
  RUN useradd -d /opt/otrs -u 5051 -g 5051 -G 33 -s /bin/bash ${OTRS_USER}
  RUN usermod -aG 5051 ${OTRS_GROUP}
  COPY --chown=${OTRS_USER}:${OTRS_GROUP} ./znuny /opt/otrs
  COPY ./docker/httpd/mergedb.sh /opt/docker/httpd/
  COPY ./docker/httpd/mergeschemas.sql /opt/docker/httpd/
  COPY ./docker/httpd/overwritedb.sh /opt/docker/httpd/
  COPY ./docker/httpd/fixsequencesdb.sh /opt/docker/httpd/
  COPY ./docker/httpd/fixsequences.sql /opt/docker/httpd/
  COPY ./docker/httpd/Config.pm /opt/otrs/Kernel/
  COPY ./docker/httpd/apache2-httpd.include.conf /opt/otrs/scripts/
  RUN ["/bin/bash", "-c", "for foo in /opt/otrs/var/cron/*.dist; do mv $foo /opt/otrs/var/cron/$(basename $foo .dist); done"]
  RUN ["/bin/bash", "-c", "sed -i -e 's/\\(\\$HOME\\/bin\\/otrs\\.Daemon\\.pl start >> \\/dev\\/null\\)/bash -l -c \"\\1\"/g' /opt/otrs/var/cron/otrs_daemon"]
  RUN mkdir -p /opt/otrs/var/tmp
  VOLUME /opt/otrs
  VOLUME /opt/otrs/var/tmp
  VOLUME /opt/otrs/var/article
  VOLUME /opt/docker/httpd
  COPY ./docker/httpd/my-httpd.conf /usr/local/apache2/conf/httpd.conf
  COPY ./docker/httpd/entrypoint.sh /usr/local/bin/
  RUN chmod +x /usr/local/bin/entrypoint.sh
  WORKDIR /opt/otrs
  ENTRYPOINT ["entrypoint.sh"]