#!/bin/bash -l
#   - - - - - - - - - - - - - -
# |                            |
# |  Verify status of battery  |
# |                            |
#  - - - - - - - - - - - - - -

# Sets default values ​​for variables
PERCENT_CRITICAL_DEFAULT=30
PERCENT_FULL_DEFAULT=100
NOTIFY_PATH_LOG="/tmp/battery_notify.conf"

# Get battery information
NOTIFY_LANGUAGE=$(locale | grep -Eo '^LANGUAGE=\w{5}' | cut -d '=' -f 2)
NOTIFY_PERCENT=$(cat /sys/class/power_supply/BAT0/capacity)
NOTIFY_STATUS=$(cat /sys/class/power_supply/BAT0/status)

NOTIFICATION=$(cat $NOTIFY_PATH_LOG || echo 'listen')

if [ "$NOTIFY_PERCENT" -gt "${NOTIFY_PERCENT_CRITICAL:-$PERCENT_CRITICAL_DEFAULT}" ] &&
    [ "$NOTIFY_PERCENT" -lt "${NOTIFY_PERCENT_LOW:-$PERCENT_FULL_DEFAULT}" ]; then

    echo "listen" >$NOTIFY_PATH_LOG
fi

if [ "$NOTIFY_PERCENT" -le "${NOTIFY_PERCENT_CRITICAL:-$PERCENT_CRITICAL_DEFAULT}" ] &&
    [ "$NOTIFY_STATUS" = "Discharging" ] && [ "$NOTIFICATION" = "listen" ]; then
    if [ "$NOTIFY_LANGUAGE" == "pt_BR" ]; then
        notify-send -u critical -t 50000 -i battery-caution "Bateria em $NOTIFY_PERCENT%" "É recomendado recarregar a bateria"
    else
        notify-send -u critical -t 50000 -i battery-caution "$NOTIFY_PERCENT% battery" "It is recommended to recharge the battery"
    fi

    echo "not-listen" >$NOTIFY_PATH_LOG
fi

if [ "$NOTIFY_PERCENT" -ge "${NOTIFY_PERCENT_LOW:-$PERCENT_FULL_DEFAULT}" ] &&
    [ "$NOTIFY_STATUS" = "Charging" ] && [ "$NOTIFICATION" = "listen" ]; then

    if [ "$NOTIFY_LANGUAGE" == "pt_BR" ]; then
        notify-send -u low -t 50000 -i battery-full 'Bateria cheia'
    else
        notify-send -u low -t 50000 -i battery-full 'Battery full'
    fi

    echo "not-listen" >$NOTIFY_PATH_LOG
fi
