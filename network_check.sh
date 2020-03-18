#!/bin/bash
# Author:
# twitter.com/pitto
#
# Please check README.md for install / usage instructions

# Checking if requirements (fping and ifupdown) are installed 
command -v fping >/dev/null 2>&1 || { echo >&2 "Sorry but fping is not installed. Aborting.";  exit 1; }
`command -v /sbin/ifup >/dev/null 2>&1 || command -v ifup >/dev/null 2>&1` || { echo >&2 "Sorry but fping is not installed. Aborting.";  exit 1; }

clear

###
# Configuration variables, customize if needed
###

# Set gateway_ip to the gateway that you want to check to declare network working or not
gateway_ip='www.google.com'
# Set nic to your Network card name, as seen in ifconfig output
nic='wlan0'
# Set network_check_threshold to the maximum number of failed checks
network_check_threshold=5
# Set reboot_server to true if you want to reboot as a last
# option to fix wifi if ifdown / ifup failed
reboot_server=false

###
# Script logic
###

# Initializing the network check counter to zero
network_check_tries=0

function restart_wlan {
    # Trying wlan restart using ifdown / ifup
    echo "Wifi Network was not working for the previous $network_check_tries checks."
    echo "Restarting $nic"
    /sbin/ifdown "$nic"
    sleep 5
    /sbin/ifup --force "$nic"
    sleep 60
    
    # If network is still down and reboot_server is set to true reboot
    host_status=$(fping $gateway_ip)
    if [[ $host_status != *"alive"* ]]; then
        if [ "$reboot_server" = true ] ; then
            echo "Wifi Network is still not working, rebooting."
            reboot
        fi
    fi
}

# This loop will run for network_check_tries times, in case there are
# network_check_threshold failures the network will be declared as
# not functional and the restart_wlan function will be triggered
while [ $network_check_tries -lt $network_check_threshold ]; do
    # Checking if ping to gateway is working using fping
    host_status=$(fping $gateway_ip)
    # Increasing network_check_tries by 1
    network_check_tries=$[$network_check_tries+1]
    
    if [[ $host_status == *"alive"* ]]; then
        # Network is up
        echo "Wifi Network is working correctly" && exit 0
    else
        # Network is down
        echo "Wifi Network is down, failed check number $network_check_tries of $network_check_threshold"
    fi
    
    # Once the network_check_threshold is reached call restart_wlan
    if [ $network_check_tries -ge $network_check_threshold ]; then
        restart_wlan
    fi
    sleep 5
done
