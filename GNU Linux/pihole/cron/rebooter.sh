#!/bin/bash

if [ -e /var/run/reboot-required ]; then
      echo -e '\033[0;31m'[!] NOTIFICATION: Reboot Required, Rebooting in 60 seconds [!]'\033[0m'
      sleep 60
      sudo reboot
fi
