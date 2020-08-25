#!/bin/bash
# Author:
# https://github.com/ltpitt
#
# Please check README.md for install / usage instructions

###
# Configuration variables, customize if needed
###

# Set gateway_ip to the gateway that you want to check to declare network working or not
gateway_ip='1.1.1.1'
# Set nic to your Network card name, as seen in ip output
nic='wlan0'
# Set network_check_threshold to the maximum number of failed checks
network_check_threshold=5
# Set reboot_server to true if you want to reboot the system as a last
# option to fix wifi in case the normal restore procedure fails
reboot_server=false
# Set reboot_server to the desired amount of minutes, it is used to
# prevent reboot loops in case network is down for long time and reboot_server
# is enabled
reboot_cycle=60
# Last boot file file location, also used to prevent reboot loop
last_bootfile=/tmp/.last_net_autoboot

###
# Script logic
###

# Initializing the network check counter to zero
network_check_tries=0

# This function is a simple logger, just adding datetime to messages
function date_log {
    echo "$(date +'%Y-%m-%d %T') $1"
}

function restart_wlan {
    # Trying wlan restart using ip
    date_log "Network was not working for the previous $network_check_tries checks."
    date_log "Restarting $nic"
    /sbin/ip link set "$nic" down
    sleep 5
    /sbin/ip link set "$nic" up
    sleep 60

    # If network is still down and reboot_server is set to true reboot
    ping -c 1 $gateway_ip > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        if [ "$reboot_server" = true ]; then
            # if there's no last boot file or it's older than reboot_cycle
            if [[ ! -f $last_bootfile || $(find $last_bootfile -mtime +$reboot_cycle -print) ]]; then
                touch $last_bootfile
                date_log "Network is still not working, rebooting"
                /sbin/reboot
            else
                date_log "Last auto reboot was less than $reboot_cycle minutes old"
            fi
        fi
    fi
}

# This loop will run for network_check_tries times, in case there are
# network_check_threshold failures the network will be declared as
# not functional and the restart_wlan function will be triggered
while [ $network_check_tries -lt $network_check_threshold ]; do
    # Increasing network_check_tries by 1
    network_check_tries=$[$network_check_tries+1]
    
    ping -c 1 $gateway_ip > /dev/null 2>&1
    if [[ $? = 0 ]]; then
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
