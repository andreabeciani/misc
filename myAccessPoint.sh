#!/bin/bash

GATEWAY=192.168.1.1
INTIP=192.168.1.100
EXTIP=192.168.3.9
case $1 in

start)
echo "start"
/etc/init.d/network-manager stop
#/etc/init.d/dnsmasq stop

ifconfig eth0 down
ifconfig wlan0 down

ifconfig eth0 0.0.0.0 up
#ifconfig wlan0 $EXTIP netmask 255.255.255.0
#ifconfig wlan0 up

echo 1 > /proc/sys/net/ipv4/ip_forward
brctl addbr br0
brctl addif br0 eth0
brctl setfd br0 0

ifconfig br0 $INTIP up

route add default gw $GATEWAY

#hostapd -dd /etc/hostapd/hostapd.conf
hostapd -B /etc/hostapd/hostapd.conf

#dnsmasq -C /root/my-dnsmasq.conf

#notify-send -t 9000 -i /usr/share/icons/gnome-colors-common/32x32/devices/network-wireless.png "AP Activado"
;;

stop)
echo "stop"
#killall dnsmasq 
#/etc/init.d/dnsmasq start
#killall dhcpd

killall hostapd

brctl delif br0 wlan0
brctl delif br0 eth0
ifconfig br0 down 
brctl delbr br0 

/etc/init.d/network-manager start

#notify-send -t 9000 -i /usr/share/icons/gnome-colors-common/32x32/devices/network-wireless.png "AP Deactivado"

;;

*)
echo "usage with start/stop command"
;;

esac
