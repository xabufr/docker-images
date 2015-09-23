FROM nginx

RUN apt-get update && apt-get install -y ruby && gem install tiller && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY tiller-conf/ /etc/tiller/
CMD ["/usr/local/bin/tiller", "-e", "prod"]
