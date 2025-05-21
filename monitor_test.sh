#!/bin/bash

PROCESS="test"                  
URL="https://test.com/monitoring/test/api" 
LOG="/var/log/monitoring.log"   
PID_FILE="/tmp/${PROCESS}.pid"  
CURL_TIMEOUT=10                 


current_pid=$(pgrep -x "$PROCESS") || exit 0


if [ -f "$PID_FILE" ]; then
    old_pid=$(cat "$PID_FILE")
    if [ "$current_pid" != "$old_pid" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Process $PROCESS restarted (old PID: $old_pid, new PID: $current_pid)" >> "$LOG"
    fi
fi


echo "$current_pid" > "$PID_FILE"
if ! curl --max-time $CURL_TIMEOUT -s -I "$URL" >/dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Monitoring server unavailable" >> "$LOG"
fi