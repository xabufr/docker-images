FROM nginx

RUN apt-get update && apt-get install -y wget git cron jq && \
wget https://github.com/Yelp/dumb-init/releases/download/v1.0.1/dumb-init_1.0.1_amd64.deb && \
dpkg -i dumb-init_*.deb && \
rm dumb-init_*.deb && \
wget https://storage.googleapis.com/kubernetes-release/release/v1.2.2/bin/linux/amd64/kubectl && \
chmod +x kubectl && \
mv kubectl /usr/bin/kubectl && \
git clone https://github.com/letsencrypt/letsencrypt && \
cd letsencrypt && \
./letsencrypt-auto --help && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD default.conf /etc/nginx/conf.d/
ADD start.sh /
ADD letsencrypt.ini.sh /
ADD reverse-proxy-deployment.yml.sh /
ADD renew.sh /
ENV WEBROOT /tmp/letsencrypt-auto

RUN mkdir -p $WEBROOT

ENTRYPOINT ["dumb-init"]
CMD ["/start.sh"]
