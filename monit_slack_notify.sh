#!/bin/sh

URL=https://hooks.slack.com/services/_CHANGE_ME_TO_YOUR_UNIQ_URL

/usr/bin/curl \
    -X POST \
    -s \
    --data-urlencode "payload={ \
        \"channel\": \"#monit\", \
        \"username\": \"Monit\", \
        \"pretext\": \"`hostname` | $MONIT_DATE\", \
        \"color\": \"danger\", \
        \"icon_emoji\": \":ghost:\", \
        \"text\": \"$MONIT_SERVICE - $MONIT_DESCRIPTION\" \
    }" \
    $URL
