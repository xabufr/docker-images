export DEBIAN_FRONTEND=noninteractive

apt-get update 
apt-get install -y wget
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget -qO - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -

#Install POSTGRES and dependencies
apt-get update
apt-get install -y \
    postgresql-$VERSION \
    postgresql-contrib-$VERSION \
    postgresql-server-dev-$VERSION \
    postgresql-plpython-$VERSION \
    postgresql-$VERSION-plv8 \
    ruby \
    libxml2-dev \
    libxslt1-dev \
    python-dev \
    python-pip \
    daemontools \
    libevent-dev \
    lzop \
    pv \
    libffi-dev \
    libssl-dev &&\
    pip install virtualenv && \
    gem install tiller

# Install WAL-E
virtualenv /var/lib/postgresql/wal-e 
. /var/lib/postgresql/wal-e/bin/activate
pip install wal-e &&\
ln -s /var/lib/postgresql/wal-e/bin/wal-e /usr/local/bin/wal-e

apt-get remove --purge -y wget
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
