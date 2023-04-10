#!/usr/bin/env bash

# I don't want slack to auto-open on weekends, but i do on weekdays.
dow=$(date +%u)
if [[ $dow -lt 6 ]]; then
    if pgrep -x "slack" >/dev/null
    then
        echo "Slack already exists"
    else
       echo "Weekday, starting slack"
       slack
    fi
fi
