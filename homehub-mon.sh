#!/bin/bash

CARBON_HOST="localhost"
CARBON_PORT="2003"
METRIC_NAME="homehub"
TIMESTAMP=`date +%s`

metric="InternetConnectionStatus"
_status=$(~/bin/homehub-cli $metric)
echo "$TIMESTAMP $metric $_status" >> ~/Documents/home_hub.log
_status_count=$(echo $_status | grep -c UP)
RES=$(printf "%.1f\n" $_status_count)

SEND="${METRIC_NAME}.${metric,,} ${RES} ${TIMESTAMP}"
echo $SEND| nc ${CARBON_HOST} ${CARBON_PORT}

DATA_POINTS="DataReceived DataSent DownstreamSyncSpeed UpstreamSyncSpeed"
for data_point in $DATA_POINTS ;do
    RES=$(~/bin/homehub-cli $data_point |sed 's///');
    echo "$TIMESTAMP $data_point $RES" >> ~/Documents/home_hub.log
    SEND="${METRIC_NAME}.${data_point,,} $(printf "%.1f\n" $RES) ${TIMESTAMP}"
    echo $SEND | nc ${CARBON_HOST} ${CARBON_PORT}
done
