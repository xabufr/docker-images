FROM nginx

RUN apt-get update && apt-get install -y ruby git wget && gem install tiller && \
wget https://github.com/Yelp/dumb-init/releases/download/v1.0.1/dumb-init_1.0.1_amd64.deb && \
dpkg -i dumb-init_*.deb && \
rm dumb-init_*.deb && \
git clone https://github.com/letsencrypt/letsencrypt && \
cd letsencrypt && \
./letsencrypt-auto --help && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /tmp/letsencrypt-auto

COPY tiller-conf/ /etc/tiller/
ENTRYPOINT ["dumb-init"]
CMD ["/usr/local/bin/tiller", "-e", "init"]
