#!/bin/bash
# Author: 
# twitter.com/pitto
#
# HOW TO INSTALL:
#
# 1) Install ifupdown and fping with the following command:
# sudo apt-get install ifupdown fping
#
# 2) Create a tmp file in any folder you like (remember to customize network_check_tries_file variable) with the following command:
# sudo touch /home/pi/scripts/network_check/network_check_tries.txt && sudo chmod 777 /home/pi/network_check//network_check_tries.txt
#
# 3) Then install this script into a folder and add to your crontab -e this row:
# */5 * * * * /yourhome/yourname/network_check.sh
#
# Note:
# If additionally you want to perform automatic repair fsck at reboot
# remember to uncomment fsck autorepair here: nano /etc/default/rcS


# Let's clear the screen
clear

# Write here the gateway / website you want to check to declare network working or not
gateway_ip='www.google.com'

# Here we specify the path of a txt file that counts network failures
network_check_tries_file='/home/pi/scripts/network_check/network_check_tries.txt'

# Time to put into a variable its content
network_check_tries=`cat $network_check_tries_file`

# Then we check if ping to the specified gateway is working
host_status=$(fping $gateway_ip)

#  If host is / is not alive we perform the ok / ko actions that simply involve increasing or resetting the failure counter
if [[ $host_status == *"alive"* ]]
then
    echo "Network is working correctly" && echo 0 > $network_check_tries_file 
else
    echo "Network is down..." && echo $(($network_check_tries + 1)) > $network_check_tries_file
fi

# If network test failed more than 5 times (you can change this value to whatever you prefer)
if [ $network_check_tries -gt 5 ]; then
echo "Network was not working for the previous $network_check_tries checks."
# Time to restart wlan0
    echo "Restarting wlan0"
    /sbin/ifdown 'wlan0'
    sleep 5
    /sbin/ifup --force 'wlan0'
    sleep 30
# Then we check again if restarting wlan0 fixed the issue, if not we reboot as last resort
    host_status=$(fping $gateway_ip)
    if [[ $host_status == *"alive"* ]]
    then
        echo "Network is working correctly" && echo 0 > $network_check_tries_file
    else
        echo "Network is down..." && echo 0 > $network_check_tries_file && reboot
    fi
fi
