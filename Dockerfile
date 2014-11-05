FROM phusion/baseimage:latest
MAINTAINER Gabriel Figueiredo <gabriel.figueiredo@imperial.ac.uk> and Mark Stillwell <mark@stillwell.me>

ENV DEBIAN_FRONTEND noninteractive

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

#ConPaaS
RUN apt-get update && \
    apt-get -y install \
        curl \
        ganglia-monitor \
        gmetad \
        less \
        libxslt1-dev \
        logtail \
        ntp \
        openssh-server \
        python \
        python-cheetah \
        python-m2crypto \
        python-netaddr \
        python-openssl \
        python-pycurl \
        python-simplejson \
        rrdtool \
        subversion \
        unzip \
        wget \
        yaws && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

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

