FROM harnesscloud/baseimage-cloud:latest
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN echo "root:contrail" | chpasswd

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install \
        bzr \
        curl \
        g++ \
        ganglia-monitor \
        gfortran \
        git \
        gmetad \
        infiniband-diags \
        less \
        libatlas-base-dev \
        libatlas3gf-base \
        libffi-dev \
        libgomp1
        libmlx4-1 \
        libssl-dev \
        libxslt1-dev \
        logtail \
        memcached \
        nginx \
        python \
        python-dev \
        python-cheetah \
        python-httplib2 \
        python-m2crypto \
        python-netaddr \
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

# install xtreemfs client
RUN echo "deb http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.04 ./" >> /etc/apt/sources.list
RUN wget -q http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.04/Release.key -O - | sudo apt-key add -
RUN apt-get update && \
    apt-get -y install xtreemfs-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN easy_install numpy && \
    easy_install -U numpy && \
    easy_install pandas && \
    easy_install patsy && \
    easy_install statsmodels

RUN curl -s https://bootstrap.pypa.io/get-pip.py | python -
RUN pip install git+https://github.com/harnesscloud/remyroy-pyopenssl-shutdown-fix#egg=pyopenssl

# create directory structure
RUN mkdir -p \
    /etc/cpsagent \
    /var/tmp/cpsagent \
    /var/run/cpsagent \
    /var/cache/cpsagent \
    /etc/cpsmanager \
    /var/tmp/cpsmanager \
    /var/run/cpsmanager \
    /var/cache/cpsmanager 

ADD conpaas-worker.sh /etc/my_init.d/10-conpaas-worker
RUN chmod 0755 /etc/my_init.d/10-conpaas-worker

ADD hinst /usr/local/bin/hinst
RUN chmod 0755 /usr/local/bin/hinst

EXPOSE 80 443
