FROM      ubuntu:trusty
MAINTAINER Gabriel Figueiredo <gabriel.figueiredo@imperial.ac.uk>

# General
RUN mkdir -p /harness-scripts
ADD ./start.sh /harness-scripts/start.sh
RUN echo "cd /harness-scripts && source start.sh" >> /etc/bash.bashrc

# MaxelerOS 
RUN apt-get update && apt-get install -y infiniband-diags libmlx4-1 libgomp1 net-tools iptables wget nano
ADD ./setmaxorch.sh /harness-scripts/setmaxorch.sh

#XtreemFS
#RUN echo "deb http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.04 ./" >> /etc/apt/sources.list
#RUN wget -q http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.04/Release.key -O - | sudo apt-key add -
#RUN apt-get -qy install xtreemfs-client

#ConPaaS
RUN apt-get -q -y install ntp curl openssh-server wget \
                python python-pycurl python-openssl python-m2crypto \
                ganglia-monitor gmetad rrdtool logtail \
                python-cheetah python-netaddr libxslt1-dev yaws subversion unzip less

RUN apt-get clean

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

WORKDIR /harness-scripts
RUN chmod +x *.sh 

VOLUME /mnt/data/cccad3/jgfc
VOLUME /opt/maxeler

CMD ["/bin/bash"]












