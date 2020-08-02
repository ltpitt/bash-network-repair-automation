# Raspberry Pi GNU / Linux Wifi Repair Automation
> This bash script checks the health status for wireless internet connection and, if it is failing, tries to fix it.   

## Prerequisites

- Download and install requirements:  
`sudo apt-get install ifupdown fping -y`

## How to use

- Clone (or download) this repo locally:  
`git clone https://github.com/ltpitt/bash-network-repair-automation.git`
- Edit your root user's crontab using:  
`sudo crontab -e` 
- Add to your crontab the following line, it will execute the check every minute. Please customize the script path according to the folder where you cloned the repo:  
`* * * * * /yourpath/network_check.sh`
- If you also want to reboot in case wifi is not working after the fix customize the reboot_server variable accordigly editing the script:  
`nano network_check.sh`  

## Optional - Automatic repair with fsck in case of reboot

As a last thing, if you want to perform automatic repair with fsck in case of reboot (even if it slows down the boot a bit I think it is quite a good idea to do it) remember to enable the functionality on your system.  
How to enable this funcionality changes according to your OS and its version, here's a possible way to configure it on Debian Buster (Raspberry Pi):
- Edit `/boot/cmdline.txt`
- Be sure that you have in it the following lines:  
`fsck.mode=force`  
`fsck.repair=yes`

You'll probably notice fsck.repair=yes is already there; these two properties are not exactly the same thing. From man systemd-fsck (these are actually parameters that are passed on by the kernel to init, i.e., systemd):

`fsck.mode=`

One of "auto", "force", "skip". Controls the mode of operation. The default is "auto", and ensures that file system checks are done when the file system checker deems them necessary. "force" unconditionally results in full file system checks. "skip" skips any file system checks.

`fsck.repair=`

One of "preen", "yes", "no". Controls the mode of operation. The default is "preen", and will automatically repair problems that can be safely fixed. "yes " will answer yes to all questions by fsck and "no" will answer no to all questions.

## Bonus - Push notifications / Email

If you want to add push or email notifications when your network is restored please check my other repo, [Simple Notifications](https://github.com/ltpitt/python-simple-notifications)

## Release History

* 0.0.2
    * Refactored in order to remove tmp files and preserve Raspberry's SD card
* 0.0.1
    * First working version using tmp files to keep count of the network check retries

## Meta

Davide Nastri – d.nastri@gmail.com

Distributed under the GPL license. See ``LICENSE`` for more information.

[Bash Wifi Network Repair Script](https://github.com/ltpitt/bash-network-repair-automation)

## Contributing

1. Fork it (<https://github.com/ltpitt/bash-network-repair-automation/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

## Contributors (thanks, you are awesome! :) )

1. [czerwony03](https://github.com/czerwony03)
2. [pattyland](https://github.com/pattyland)
3. [deltabravozulu](https://github.com/deltabravozulu)

<!-- Markdown link & img dfn's -->
[npm-image]: https://img.shields.io/npm/v/datadog-metrics.svg?style=flat-square
[npm-url]: https://npmjs.org/package/datadog-metrics
[npm-downloads]: https://img.shields.io/npm/dm/datadog-metrics.svg?style=flat-square
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[wiki]: https://github.com/yourname/yourproject/wiki
