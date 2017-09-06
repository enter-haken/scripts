#!/bin/bash

capacty_level=$(cat /sys/class/power_supply/BAT0/capacity_level);
capacity=$(cat /sys/class/power_supply/BAT0/capacity);
status=$(cat /sys/class/power_supply/BAT0/status);

if [ capacty_level == 'Full' ]; then
    echo "AC mode | Capacity $capacity";
    exit 1;
fi

echo "Battery $status | Capacity $capacity %";
