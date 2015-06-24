FROM xabufr/phantomjs:v2.0.1-dev-2015-06-02

RUN add-apt-repository ppa:openjdk-r/ppa -y; \
apt-get update; \
apt-get install -y openjdk-8-jre-headless; \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
/var/lib/dpkg/info/ca-certificates-java.postinst configure;
