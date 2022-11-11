FROM postgres:13.6
  RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
  ENV LANG en_US.utf8
  COPY ./docker/postgres/initdb.sh /docker-entrypoint-initdb.d/
  COPY ./znuny/scripts/database/*postgresql* /docker-entrypoint-initdb.d/
  RUN ["/bin/bash", "-c", "mv /docker-entrypoint-initdb.d/{,01}otrs-schema.postgresql.sql"]
  RUN ["/bin/bash", "-c", "mv /docker-entrypoint-initdb.d/{,02}otrs-initial_insert.postgresql.sql"]
  RUN ["/bin/bash", "-c", "mv /docker-entrypoint-initdb.d/{,03}otrs-schema-post.postgresql.sql"]
  # COPY ./docker/httpd/otrs.backup /docker-entrypoint-initdb.d/
  # CMD [ "gosu", "postgres", "/usr/lib/postgresql/13/bin/pg_resetwal", "-f", "/var/lib/postgresql/data" ]