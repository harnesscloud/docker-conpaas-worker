HARNESS CONTAINER IMAGE
=======================

[![DOI](https://zenodo.org/badge/7696/harnesscloud/docker-conpaas-worker.svg)](https://zenodo.org/badge/latestdoi/7696/harnesscloud/docker-conpaas-worker)

### BUILD

    docker build -t harness-container .

The start.sh script (in /harness-scripts) will be automatically invoked each time
the container is executed. 

### CREATE A CONTAINER

    docker run --rm 
           -v /dev/infiniband/:/dev/infiniband 
           -v /opt/maxeler:/opt/maxeler           
           -v /mnt/data/cccad3/jgfc:/mnt/data/cccad3/jgfc 
           --privileged=true -i -t harness-container
           

In order to use infiniband, the container must be run with privileged access.


