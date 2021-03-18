# Creates a basic proxysql container that also contains mysql client

FROM ubuntu:focal

EXPOSE 6032/tcp 6033/tcp 6070/tcp

# set up mysql client to use /run/proxysql/proxysql.sock as Unix socket
COPY ./client.cnf /tmp/client.cnf

# set up proxysql to listen on /run/proxysql/proxysql.sock in addition to
# TCP port 6032
COPY ./proxysql.cnf /tmp/proxysql.cnf

# see https://proxysql.com/documentation/installing-proxysql/
RUN . /etc/os-release; \
    apt-get update && apt-get install -y \
        wget \
        gnupg \
        apt-transport-https \
        ca-certificates \
    && wget -q -O - 'https://repo.proxysql.com/ProxySQL/repo_pub_key' | apt-key add - \
    && echo deb https://repo.proxysql.com/ProxySQL/proxysql-2.1.x/${VERSION_CODENAME}/ ./ | tee /etc/apt/sources.list.d/proxysql.list \
    && apt-get update && apt-get install -y \
        proxysql \
        mysql-client \
    && apt-get purge -y \
        wget \
        gnupg \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && mv /etc/proxysql.cnf /etc/proxysql.defaults.cnf \
    && mv /tmp/proxysql.cnf /etc/proxysql.cnf \
    && mv /tmp/client.cnf /etc/mysql/conf.d/client.cnf \
    && chgrp proxysql \
        /etc/proxysql.cnf \
        /etc/proxysql.defaults.cnf \
        /etc/mysql/conf.d/client.cnf \
    && chmod 640 \
        /etc/proxysql.cnf \
        /etc/proxysql.defaults.cnf \
        /etc/mysql/conf.d/client.cnf \
    && mkdir -p /run/proxysql \
    && chown proxysql:proxysql /run/proxysql \
    && chmod 770 /run/proxysql

VOLUME ["/var/lib/proxysql"]

USER proxysql

CMD ["proxysql", "-f", "-D", "/var/lib/proxysql"]
