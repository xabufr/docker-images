FROM nginx

RUN apt-get update && apt-get install -y ruby && gem install tiller

COPY tiller-conf/ /etc/tiller/
CMD ["/usr/local/bin/tiller", "-e", "prod"]
