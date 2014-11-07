#!/bin/bash
source /usr/local/bin/setmaxorch.sh
/usr/local/bin/conpaas-ec2
exec /usr/sbin/runsvdir-start
