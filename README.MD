HARNESS CONTAINER IMAGE
=======================

BUILD
-----
docker build -t harness-container .

The start.sh script (in /harness-scripts) will be automatically invoked each time
the container is executed. 

CREATE A CONTAINER
------------------

docker run --rm 
           -v /dev/infiniband/:/dev/infiniband 
           -v /opt/maxeler:/opt/maxeler           
           -v /mnt/data/cccad3/jgfc:/mnt/data/cccad3/jgfc 
           --privileged=true -i -t harness-container
           


