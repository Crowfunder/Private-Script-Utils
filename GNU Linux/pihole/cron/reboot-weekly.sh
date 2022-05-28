#!/bin/bash

if [ ! -e /var/run/reboot-required ]; then
    sudo touch /var/run/reboot-required
fi
