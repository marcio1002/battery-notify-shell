#!/bin/bash
#   - - - - - - - - - - - - - -
# |                            |
# |  Verify status of battery  |
# |                            |
#  - - - - - - - - - - - - - - 

LANGUAGE=$(locale | grep -Eo '^LANGUAGE=\w{5}' | cut -d '=' -f 2)

PERCENT=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status)

NOTIFICATION=$(cat /tmp/battery_notify.conf || echo 'listen')

if [ "$STATUS" != "Discharging" ] && [ "$STATUS" != "Full" ]; then
    echo "listen" > /tmp/battery_notify.conf
fi

if [ "$PERCENT" -le "${NOTIFY_PERCENT_CRITICAL:-38}" ] && [ "$STATUS" == "Discharging" ] && [ "$NOTIFICATION" == "listen" ]; then
    if [ "$LANGUAGE" == "pt_BR" ]; then
        notify-send -u critical -t 50000 -i battery-caution "Bateria em $PERCENT%" "É recomendado recarregar a bateria"
    else
        notify-send -u critical -t 50000 -i battery-caution "$PERCENT% battery" "It is recommended to recharge the battery"
    fi

    echo "not-listen" > /tmp/battery_notify.conf
fi

if [ "$PERCENT" -eq "${NOTIFY_PERCENT_LOW:-100}" ] &&  [ "$STATUS" == "Full" ] && [ "$NOTIFICATION" == "listen" ]; then

    if [ "$LANGUAGE" == "pt_BR" ]; then
        notify-send -u normal -t 50000 -i  battery-full 'Bateria cheia'
    else
        notify-send -u normal -t 50000 -i battery-full 'Battery full'
    fi

    echo "not-listen" > /tmp/battery_notify.conf
fi