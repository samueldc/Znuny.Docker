FROM debian:11 AS download
  RUN apt-get update \ 
      && apt-get install -y --no-install-recommends wget unzip git \
      && apt-get clean
  RUN mkdir -p /opt/otrs \
    && git config --global http.sslverify false \
    && git clone -b rel-6_4 https://github.com/znuny/Znuny.git /opt/otrs
  #ADD https://github.com/znuny/Znuny.git#rel-6_4 /opt/otrs/
FROM postgres:13.6
  RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
  ENV LANG en_US.utf8
  COPY ./initdb.sh /docker-entrypoint-initdb.d/
  COPY --from=download /opt/otrs/scripts/database/*postgresql* /docker-entrypoint-initdb.d/
  RUN ["/bin/bash", "-c", "mv /docker-entrypoint-initdb.d/{,01}otrs-schema.postgresql.sql"]
  RUN ["/bin/bash", "-c", "mv /docker-entrypoint-initdb.d/{,02}otrs-initial_insert.postgresql.sql"]
  RUN ["/bin/bash", "-c", "mv /docker-entrypoint-initdb.d/{,03}otrs-schema-post.postgresql.sql"]
  # COPY ./otrs.backup /docker-entrypoint-initdb.d/
  # CMD [ "gosu", "postgres", "/usr/lib/postgresql/13/bin/pg_resetwal", "-f", "/var/lib/postgresql/data" ]