FROM phusion/baseimage:latest
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN echo "root:contrail" | chpasswd

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install \
        bzr \
        g++ \
        ganglia-monitor \
        gfortran \
        git \
        gmetad \
        less \
        libatlas-base-dev \
        libatlas3gf-base \
        libffi-dev \
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
        python-pip \
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

RUN easy_install -U bzr+lp:~remyroy/pyopenssl/shutdown-fix#egg=pyopenssl

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

EXPOSE 80 443
