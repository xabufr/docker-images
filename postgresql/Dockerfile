FROM phusion/baseimage:0.9.18

ENV VERSION 9.4

ENV PGDATA /var/lib/postgresql/data/data
ADD install.sh /install.sh
RUN /install.sh
COPY tiller-conf/ /etc/tiller/
COPY init/ /init/
COPY init/ /etc/service/postgres/
ADD wal-e-wrapper.sh /wal-e-wrapper.sh

VOLUME "/var/lib/postgresql/data"
CMD ["/sbin/my_init"]
EXPOSE 5432
