FROM debian:bullseye-slim

RUN dpkg --add-architecture arm64 && \
    apt-get update && apt-get install -y apt-utils aptitude && \
    apt-get install -y build-essential crossbuild-essential-arm64 debhelper git && \
    echo 'deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main' > /etc/apt/sources.list.d/pgdg.list && \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && apt-get update && \
    aptitude install -y postgresql-client-10:arm64 postgresql-common:arm64 postgresql-server-dev-10:arm64 && \
    mv /usr/lib/postgresql/10/bin/pg_config /usr/lib/postgresql/10/bin/pg_config.alien && \
    apt-get download postgresql-server-dev-all:arm64 && \
    dpkg-deb -R postgresql-server-dev-all* psda/ && \
    grep -v '^Depends: .*' psda/DEBIAN/control > psda/DEBIAN/control_new && \
    mv psda/DEBIAN/control_new psda/DEBIAN/control && \
    dpkg-deb -b psda/ && \
    dpkg -i psda.deb

COPY pg_config.minimal /usr/lib/postgresql/10/bin/pg_config

WORKDIR "/mnt/build"
