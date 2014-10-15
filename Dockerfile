FROM      debian:wheezy
MAINTAINER Gabriel Figueiredo <gabriel.figueiredo@imperial.ac.uk>

RUN apt-get update && apt-get install -y  infiniband-diags libmlx4-1 libgomp1 net-tools iptables
RUN mkdir -p /harness-scripts
ADD ./configure-conpaas.sh /harness-scripts/configure-conpaas.sh
ADD ./setmaxorch.sh /harness-scripts/setmaxorch.sh
ADD ./start.sh /harness-scripts/start.sh
RUN echo "cd /harness-scripts && source start.sh" >> /etc/bash.bashrc
WORKDIR /harness-scripts
RUN chmod +x *.sh 
#RUN ./create-img-conpaas.sh
VOLUME /mnt/data/cccad3/jgfc
VOLUME /opt/maxeler

CMD ["/bin/bash"]












