FROM debian:squeeze
MAINTAINER Mark Stillwell <mark@stillwell.me>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "root:contrail" | chpasswd
RUN sed --in-place 's/main/main contrib non-free/' /etc/apt/sources.list

# pre-accept sun java6 licence
RUN echo "debconf shared/accepted-sun-dlj-v1-1 boolean true" | \
    debconf-set-selections

# ipop repository
RUN echo "deb http://www.grid-appliance.org/files/packages/deb/ stable contrib"\
        >> /etc/apt/sources.list
RUN wget -O - http://www.grid-appliance.org/files/packages/deb/repo.key | \
        apt-key add -

# add dotdeb repo for php fpm
RUN echo "deb http://packages.dotdeb.org $DEBIAN_DIST all" \
    >> /etc/apt/sources.list
RUN wget -O - http://www.dotdeb.org/dotdeb.gpg 2>/dev/null | apt-key add -

#ConPaaS
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        curl \
        g++ \
        ganglia-monitor \
        gfortran \
        git \
        gmetad \
        ipop \
        less \
        libatlas-base-dev \
        libatlas3gf-base \
        libxslt1-dev \
        logtail \
        memcached \
        nginx \
        ntp \
        openssh-server \
        php5-adodb \
        php5-curl \
        php5-fpm \
        php5-gd \
        php5-mcrypt \
        php5-memcache \
        php5-mysql \
        php5-odbc \
        php5-pgsql \
        php5-sqlite \
        php5-sybase \
        php5-xmlrpc \
        php5-xsl \
        python \
        python-dev \
        python-cheetah \
        python-m2crypto \
        python-netaddr 
        python-openssl \
        python-pycurl \
        python-scipy \
        python-setuptools \
        python-simplejson \
        rrdtool \
        subversion \
        tomcat6-user \
        unzip \
        wget \
        yaws && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN easy_install numpy && \
    easy_install -U numpy && \
    easy_install pandas && \
    easy_install patsy && \
    easy_install statsmodels

# MaxelerOS 
RUN apt-get update && \
    apt-get -y install \
        infiniband-diags \
        iptables \
        libgomp1 \
        libmlx4-1 \
        nano \
        net-tools \
        wget && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#XtreemFS
#RUN wget -q http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.04/Release.key -O - | sudo apt-key add -
#RUN apt-add-repository "deb http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.04 ./"
#RUN apt-get update && \
#    apt-get -y install xtreemfs-client && \
#    rm -rf /var/lib/apt/lists/* /var/cache/apt/*


# StartUp
ADD ./setmaxorch.sh /etc/my_init.d/10-setmaxorch
RUN chmod 0755 /etc/my_init.d/10-setmaxorch
RUN >> /etc/bash.bashrc echo '\
export LD_LIBRARY_PATH=/opt/maxeler/maxeleros/lib:$LD_LIBRARY_PATH\n\
export SLIC_CONF="default_engine_resource=192.168.0.10 disable_pcc=true"\n\
export PATH=/opt/maxeler/maxeleros/utils:$PATH\n'

# create directory structure
RUN echo > /var/log/cpsagent.log
RUN mkdir -p /etc/cpsagent/
RUN mkdir -p /var/tmp/cpsagent/
RUN mkdir -p /var/run/cpsagent/
RUN mkdir -p /var/cache/cpsagent/
RUN echo > /var/log/cpsmanager.log
RUN mkdir -p /etc/cpsmanager/
RUN mkdir -p /var/tmp/cpsmanager/
RUN mkdir -p /var/run/cpsmanager/
RUN mkdir -p /var/cache/cpsmanager/

ADD 998-ec2 /etc/my_init.d/20-conpaas-ec2
RUN chmod 755 /etc/my_init.d/20-conpaas-ec2

VOLUME [ "/mnt/data/cccad3/jgfc", "/opt/maxeler" ]

