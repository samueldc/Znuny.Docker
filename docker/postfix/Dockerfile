FROM dockerhub.camara.leg.br/dockerhub/library/debian:11
    RUN ln -s /usr/local/apache2 /usr/lib/apache2
    RUN apt-get update \ 
        && apt-get install -y --no-install-recommends locales \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
    ENV LANG=en_US.utf8
    RUN echo 'debconf freetds/addtoodbc select true' | debconf-set-selections
    RUN apt-get update \ 
        && apt-get install -y --no-install-recommends postfix postfix-pcre \
        && apt-get clean
    RUN echo 'debconf freetds/addtoodbc select true' | debconf-set-selections
    COPY ./docker/postfix/main.cf /etc/postfix/main.cf
    VOLUME /opt/otrs
    CMD ["start-fg"]
    ENTRYPOINT ["/usr/sbin/postfix"]