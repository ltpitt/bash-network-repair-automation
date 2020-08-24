#!/bin/bash
# Author:
# https://github.com/ltpitt
#
# Please check README.md for install / usage instructions

# Checking if requirements (fping and ifupdown) are installed 
`command -v /sbin/fping >/dev/null 2>&1 || command -v fping >/dev/null 2>&1` || { echo >&2 "Sorry but fping is not installed. Aborting.";  exit 1; }

command -v /sbin/ifdown >/dev/null 2>&1 || command -v ifup >/dev/null 2>&1
USE_IFUPDOWN=$?

###
# Configuration variables, customize if needed
###

# Set gateway_ip to the gateway that you want to check to declare network working or not
gateway_ip='1.1.1.1'
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

function date_log {
    echo "$(date +'%Y-%m-%d %T') $1"
}

function restart_wlan {
    # Trying wlan restart using ifdown / ifup
    date_log "Network was not working for the previous $network_check_tries checks."
    date_log "Restarting $nic"
    if [[ $USE_IFUPDOWN = 0 ]]; then
        /sbin/ifdown "$nic"
        sleep 5
        /sbin/ifup --force "$nic"
        sleep 60
    else
        /sbin/ifconfig "$nic" down
        sleep 5
        /sbin/ifconfig "$nic" up
        sleep 60
    fi

    # If network is still down and reboot_server is set to true reboot
    host_status=$(fping $gateway_ip)
    if [[ $host_status != *"alive"* ]]; then
        if [ "$reboot_server" = true ] ; then
            date_log "Network is still not working, rebooting"
            /sbin/reboot
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
        date_log "Network is working correctly" && exit 0
    else
        # Network is down
        echo "Network is down, failed check number $network_check_tries of $network_check_threshold"
    fi
    
    # Once the network_check_threshold is reached call restart_wlan
    if [ $network_check_tries -ge $network_check_threshold ]; then
        restart_wlan
    fi
    sleep 5
done
