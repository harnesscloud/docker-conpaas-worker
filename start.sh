#!/bin/bash
source /usr/local/bin/setmaxorch.sh
sleep 5
/usr/local/bin/conpaas-ec2
exec /usr/sbin/runsvdir-start
