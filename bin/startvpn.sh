#!/bin/bash
sudo /etc/rc.d/openswan start
sleep 2
sudo /etc/rc.d/xl2tpd start
sudo /usr/sbin/ipsec auto --up L2TP-PSK
/bin/echo "c vpn-connection" | sudo tee -a /var/run/xl2tpd/l2tp-control
sleep 15
PPP_GW_ADD=`getip.sh ppp0`
sudo route add 65.49.73.162 gw 192.168.1.1 wlan0
sudo route add default gw $PPP_GW_ADD
sudo route del default gw 192.168.1.1
