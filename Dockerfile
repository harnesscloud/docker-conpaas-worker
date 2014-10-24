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
RUN echo "deb http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.04 ./" >> /etc/apt/sources.list
RUN wget -q http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.04/Release.key -O - | sudo apt-key add -
RUN apt-get -qy update
RUN apt-get -qy install xtreemfs-client

WORKDIR /harness-scripts
ADD ./configure-conpaas.sh /harness-scripts/configure-conpaas.sh
RUN chmod +x *.sh 
RUN ./configure-conpaas.sh

VOLUME /mnt/data/cccad3/jgfc
VOLUME /opt/maxeler

CMD ["/bin/bash"]












