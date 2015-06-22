FROM phusion/baseimage:0.9.16

ADD install.sh install.sh
RUN chmod +x install.sh && ./install.sh && rm install.sh
ADD beanstalkd.sh /etc/service/beanstalkd/run

EXPOSE 11300
VOLUME ["/data"]
CMD ["/sbin/my_init"]