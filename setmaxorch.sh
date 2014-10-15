echo 1 > /proc/sys/net/ipv4/ip_forward
ip link add ib0 type dummy
ip address add 192.168.0.0/24 broadcast 192.168.0.255 dev ib0
ip link set ib0 up
route add 192.168.0.10 gw 172.17.42.1
route add 192.168.0.1 gw 172.17.42.1
iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
export LD_LIBRARY_PATH=/opt/maxeler/maxeleros/lib:$LD_LIBRARY_PATH
export SLIC_CONF="default_engine_resource=192.168.0.10 disable_pcc=true"
export PATH=/opt/maxeler/maxeleros/utils:$PATH

