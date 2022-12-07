#!/bin/bash

USER=$(whoami)
CRONTAB=$(command -v crontab)

if [ -z "$CRONTAB" ]; then
  echo -e "\e[00;31;1mcrontab not found\e[m"
  exit 1
fi

($CRONTAB -u "$USER" -l || echo '') | sudo tee ./crontab_tmp >/dev/null

echo "
# NOTIFICATION BATTERY
NOTIFY_PERCENT_CRITICAL=30
NOTIFY_PERCENT_LOW=90

*/1 * * * * DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus /home/marcio/battery-notify/battery-notify.sh" |
  sudo tee -a ./crontab_tmp >/dev/null

crontab -u "$USER" ./crontab_tmp
sudo rm crontab_tmp

echo -e "\e[00;32;1mSuccess!\e[m"
