FROM redis:3.2.3

RUN apt-get update && apt-get install supervisor cron s3cmd -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/log/supervisor

ADD redis.conf.sh /etc/
ADD cron.sh /usr/local/bin/
ADD backup.sh /usr/local/bin/
ADD log-cron.sh /usr/local/bin/
ADD redis.sh /usr/local/bin/
COPY supervisor.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT ["sh", "-c"]
CMD ["supervisord -c /etc/supervisor/conf.d/supervisord.conf"]
