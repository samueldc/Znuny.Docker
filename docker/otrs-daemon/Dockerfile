FROM dockerhub.camara.leg.br/dockerhub/library/debian:11
RUN apt-get update \ 
    && apt-get install -y --no-install-recommends locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8
RUN apt-get update \
    && apt-get install -y --no-install-recommends perl \
    libdbd-mysql-perl libtimedate-perl libnet-dns-perl \
    libnet-ldap-perl libio-socket-ssl-perl libpdf-api2-perl libdbd-mysql-perl \
    libsoap-lite-perl libtext-csv-xs-perl libjson-xs-perl libapache-dbi-perl \
    libxml-libxml-perl libxml-libxslt-perl libyaml-perl libarchive-zip-perl \
    libcrypt-eksblowfish-perl libencode-hanextra-perl libmail-imapclient-perl \
    libtemplate-perl libdatetime-perl libmoo-perl libdbd-pg-perl \ 
    libhash-merge-perl libexcel-writer-xlsx-perl libauthen-sasl-perl \
    libcss-minifier-xs-perl libdbd-odbc-perl libjavascript-minifier-xs-perl \
    libauthen-ntlm-perl libspreadsheet-xlsx-perl libyaml-libyaml-perl \
    htop bash-completion \
    supervisor \
    && apt-get clean
RUN groupadd -g 5051 otrs
RUN useradd -d /opt/otrs -u 5051 -g 5051 -G 33 -s /bin/bash otrs
VOLUME /opt/otrs
VOLUME /opt/otrs/var/tmp
ARG OTRS_USER=otrs
ARG OTRS_GROUP=www-data
ENV OTRS_USER=${OTRS_USER}
ENV OTRS_GROUP=${OTRS_GROUP}
WORKDIR /opt/otrs
COPY ./entrypoint.sh /usr/local/bin/
COPY ./supervisor.conf /etc/supervisor/conf.d/supervisor.conf
VOLUME /opt/otrs/var/article
RUN chmod +x /usr/local/bin/entrypoint.sh
CMD ["entrypoint.sh"]