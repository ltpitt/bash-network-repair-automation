#!/bin/bash
# Author:
# twitter.com/pitto
#
# HOW TO INSTALL:
#
# 1) Install ifupdown and fping with the following command:
# sudo apt-get install ifupdown fping
#
# 2) Then install this script into a folder and add to your crontab -e this row:
# */5 * * * * /yourhome/yourname/network_check.sh
#
# Note:
# If you want to perform automatic repair fsck at reboot
# remember to uncomment fsck autorepair here: nano /etc/default/rcS

# Let's clear the screen
clear

# Write here the gateway you want to check to declare network working or not
gateway_ip='asdasdwww.google.com'

# Here we specify the path of temporary file that counts network failures
network_check_tries=0

# Here we specify the maximum number of failed checks
network_check_threshold=5

# This function will be called when network_check_tries is equal or greather than network_check_threshold
function restart_wlan0 {
    # If network test failed more than $network_check_threshold
    echo "Network was not working for the previous $network_check_tries checks."
    # We restart wlan0
    echo "Restarting wlan0"
    /sbin/ifdown 'wlan0'
    sleep 5
    /sbin/ifup --force 'wlan0'
    sleep 60
    # If you also want a reboot in case of network not recovery uncomment the following lines
    #host_status=$(fping $gateway_ip)
    #if [[ $host_status != *"alive"* ]]; then
    #    reboot
    #fi
}

# This loop will run 5 times and if we have 5 failures we declare network as not working and we restart wlan0
while [ $network_check_tries -lt $network_check_threshold ]; do
    # We check if ping to gateway if working and perform the ok / ko actions
    host_status=$(fping $gateway_ip)
    # Increase network_check_tries by 1 unit
    network_check_tries=$[$network_check_tries+1]
    # If network is working
    if [[ $host_status == *"alive"* ]]; then
        # We reset network_check_tries to 0
        echo "Network is working correctly, network_check_tries to 0" && network_check_tries=0
    else
        # If not we go for another check
        echo "Network is down, failed check number $network_check_tries of $network_check_threshold"
    fi
    # If we hit the threshold we restart wlan0
    if [ $network_check_tries -ge $network_check_threshold ]; then
        restart_wlan0
    fi
    # Let's wait a bit between every check
    sleep 5
done
