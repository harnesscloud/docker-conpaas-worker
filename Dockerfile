FROM debian:squeeze
MAINTAINER Mark Stillwell <mark@stillwell.me>

ENV DEBIAN_FRONTEND noninteractive

# this repeats debian-cloudimage because we need to use squeeze...
RUN sed -i 's/main/main contrib non-free/' /etc/apt/sources.list
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        curl \
        openssh-server \
        runit && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN mkdir -p /etc/service/sshd && \
    echo '#!/bin/sh\nmkdir -p /var/run/sshd\nexec /usr/sbin/sshd -D' \
        > /etc/service/sshd/run && \
    chmod 0755 /etc/service/sshd/run

# init script to get ssh key from metadata service
ADD get-ssh-key.sh /etc/my_init.d/05-get-ssh-key
RUN chmod 0755 /etc/my_init.d/05-get-ssh-key

# add my_init.sh
ADD my_init.sh /sbin/my_init
RUN chmod 0755 /sbin/my_init

EXPOSE 22

CMD [ "/sbin/my_init" ]

# start of conpaas-worker specific stuff
RUN echo "root:contrail" | chpasswd

RUN apt-get update && \
    apt-get -y install \
        g++ \
        ganglia-monitor \
        gfortran \
        git \
        gmetad \
        less \
        libatlas-base-dev \
        libatlas3gf-base \
        libxslt1-dev \
        logtail \
        memcached \
        nginx \
        python \
        python-dev \
        python-cheetah \
        python-m2crypto \
        python-netaddr \
        python-openssl \
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
RUN chmod 0755 //etc/my_init.d/10-conpaas-worker

EXPOSE 80 443

# MaxelerOS 
#RUN apt-get update && \
#    apt-get -y install \
#        infiniband-diags \
#        iptables \
#        libgomp1 \
#        libmlx4-1 \
#        nano \
#        net-tools \
#        wget && \
#    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#VOLUME [ "/mnt/data/cccad3/jgfc", "/opt/maxeler" ]

#XtreemFS
#RUN wget -q http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.04/Release.key -O - | sudo apt-key add -
#RUN apt-add-repository "deb http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.04 ./"
#RUN apt-get update && \
#    apt-get -y install xtreemfs-client && \
#    rm -rf /var/lib/apt/lists/* /var/cache/apt/*


# StartUp
#ADD ./setmaxorch.sh /usr/local/bin/setmaxorch.sh
#RUN chmod 0755 /usr/local/bin/setmaxorch.sh
#RUN >> /etc/bash.bashrc echo '\
#export LD_LIBRARY_PATH=/opt/maxeler/maxeleros/lib:$LD_LIBRARY_PATH\n\
#export SLIC_CONF="default_engine_resource=192.168.0.10 disable_pcc=true"\n\
#export PATH=/opt/maxeler/maxeleros/utils:$PATH\n'
