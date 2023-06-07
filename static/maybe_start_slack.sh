#!/usr/bin/env bash

# I don't want slack to auto-open on weekends, but i do on weekdays.
# I also usually take bank holidays as leave. because of this, i query the govuk
# bank holidays API and check if it's a bank holiday.
# If it is either a weekend, or a bank holiday, don't start slack.
# This also checks if slack is running or not already to prevent window dupe.

function check_if_bank_holiday()
{
    bankHolidays=$(curl 'https://www.gov.uk/bank-holidays.json' | jq -r '."england-and-wales".events | .[] | .date')
    i=1
    today=$(date +%F)
    for day in $bankHolidays; do
        echo "$i : $day"
        if [ "$today" == "$day" ]
        then
           true
           return
        else
           ((i+=1))
        fi
    done
    false
    return
}

function check_if_weekday() {
    dow=$(date +%u)
    if [[ $dow -lt 6 ]]; then
        true
        return
    else
       false
       return
    fi
}

function start_slack_if_not_running() {
    if pgrep -x "slack" >/dev/null
    then
        echo "Slack already exists"
    else
       echo "Weekday, starting slack"
       slack
    fi

}

if check_if_bank_holiday;
then
    echo "BH"
    exit 0
else
   echo "Not bh"
fi

echo "checking if weekeday"
if check_if_weekday;
then
    echo "WD"
else
   exit 0
fi

start_slack_if_not_running
