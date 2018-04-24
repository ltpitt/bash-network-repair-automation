# Raspberry Pi (and Linux) Wifi Repair Automation
> This bash script checks for wireless internet connection and, if it is failing, tries to fix it.   

## Prerequisites

- Download and install requirements:  
`sudo apt-get install ifupdown fping -y`

## How to use

- Clone (or download) this repo locally:  
`git clone https://github.com/ltpitt/bash-network-repair-automation.git`
- Edit your root user's crontab:  
`sudo crontab -e` 
- This line will execute the check every minute. Please customize the script path according to the folder where you cloned the repo:  
`* * * * * /yourpath/network_check.sh`
- If you also want to reboot in case wifi is not working after the fix uncomment the required lines in the code (you'll find a detailed explanation in the script comments):  
`nano network_check.sh`  
- If you want to perform automatic repair fsck in case of reboot (this is the last possible recovery action) remember to uncomment *fsck autorepair* editing rcS with the following command:  
`sudo nano /etc/default/rcS`

## Release History

* 0.0.2
    * Refactored in order to remove tmp files and preserve Raspberry's SD card
* 0.0.1
    * First working version using tmp files

## Meta

Davide Nastri – [@pitto](https://twitter.com/pitto) – d.nastri@gmail.com

Distributed under the GPL license. See ``LICENSE`` for more information.

[Bash Wifi Network Repair Script](https://github.com/ltpitt/bash-network-repair-automation)

## Contributing

1. Fork it (<https://github.com/ltpitt/bash-network-repair-automation/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

<!-- Markdown link & img dfn's -->
[npm-image]: https://img.shields.io/npm/v/datadog-metrics.svg?style=flat-square
[npm-url]: https://npmjs.org/package/datadog-metrics
[npm-downloads]: https://img.shields.io/npm/dm/datadog-metrics.svg?style=flat-square
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[wiki]: https://github.com/yourname/yourproject/wiki
