#!/bin/bash

sudo /usr/sbin/ipsec auto --down L2TP-PSK
/bin/echo "d vpn-connection" | sudo tee -a /var/run/xl2tpd/l2tp-control
sudo /etc/rc.d/xl2tpd stop
sudo /etc/rc.d/openswan stop

sudo route del 65.49.73.162 gw 192.168.1.1 wlan0
sudo route add default gw 192.168.1.1
