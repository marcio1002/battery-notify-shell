#!/bin/bash

USER=$(whoami)
CURRENT_PATH=$(pwd)
CRONTAB=$(command -v crontab)

if [ -z "$CRONTAB" ]; then
  print -P "%F{red}crontab not found%f"
  exit 1
fi

($CRONTAB -u "$USER" -l || echo '') | sudo tee ./crontab_tmp >/dev/null

echo "
# NOTIFICATION BATTERY
NOTIFY_PERCENT_CRITICAL=30
NOTIFY_PERCENT_LOW=90

*/1 * * * * DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus $CURRENT_PATH/battery-notify.sh" |
  sudo tee -a ./crontab_tmp >/dev/null

crontab -u "$USER" ./crontab_tmp
sudo rm crontab_tmp

print -P "%F{green}Success\!%f"
