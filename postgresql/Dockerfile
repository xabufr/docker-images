FROM phusion/baseimage:0.9.17

ENV VERSION 9.4

ENV PGDATA /var/lib/postgresql/data
ADD install.sh /install.sh
RUN /install.sh
COPY tiller-conf/ /etc/tiller/
COPY init/ /init/
ADD wal-e-wrapper.sh /wal-e-wrapper.sh

VOLUME "/var/lib/postgresql/data"
CMD ["/init/start.sh"]
EXPOSE 5432
