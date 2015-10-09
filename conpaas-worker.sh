#!/bin/bash 

# Retrieve the instance user-data and run it if it looks like a script
user_data_url=http://169.254.169.254/openstack/2012-08-10/user_data
user_data_file=$(tempfile --prefix ec2 --suffix .user-data --mode 700)
attempts=12
while [ $attempts -gt 0 ]; do
  attempts=$((${attempts}-1))
  curl -m 10 -sf $user_data_url > $user_data_file 2>/dev/null
  if [ $? -eq 0 ]; then
    break
  fi
  sleep 1
done

if [ $(file -b --mime-type $user_data_file) = 'application/x-gzip' ]; then
	echo "Uncompressing gzip'd user-data"
	mv $user_data_file $user_data_file.gz
	gunzip $user_data_file.gz
fi

# set up environment for maxeler orchestrator
if [ -d /dev/infiniband ]; then
    echo 1 > /proc/sys/net/ipv4/ip_forward
    ip link add ib0 type dummy
    ip address add 192.168.0.0/24 dev ib0
    ip link set ib0 up
    ip route del 192.168.0.0/24 dev ib0
    ip route add 192.168.0.0/24 via 172.17.42.1 dev eth0
    iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
fi

if [ ! -s $user_data_file ]; then
	echo "No user-data available"
elif head -1 $user_data_file | egrep -v '^#!'; then
	echo "Skipping user-data as it does not begin with #!"
else
	echo "Running user-data"
	$user_data_file 2>&1 
	echo "user-data exit code: $?"
fi
rm -f $user_data_file
