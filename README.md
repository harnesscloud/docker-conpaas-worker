HARNESS CONTAINER IMAGE
=======================

### BUILD

    docker build -t harnesscloud/conpaas-worker .

The start.sh script (in /harness-scripts) will be automatically invoked each time
the container is executed. 

### CREATE A CONTAINER

    docker run --rm --privileged=true -i -t harnesscloud/conpaas-worker /bin/bash
           

In order to use infiniband, the container must be run with privileged access.


