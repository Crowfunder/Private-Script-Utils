# Custom definitions and executions on boot
alias pihole='docker exec -it pihole /bin/bash'
if [ $UID -ne 0 ]; then
    alias reboot='sudo reboot'
fi
neofetch
