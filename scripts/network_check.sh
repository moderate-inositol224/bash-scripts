#!/bin/bash

# This script checks the network connectivity to a predefined list of hosts.

HOSTS=("8.8.8.8" "google.com" "itsfoss.gitlab.io" "localhost") # Add your critical hosts here
LOG_FILE="/var/log/network_health.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$DATE] Starting network health check..." | tee -a "$LOG_FILE"

for HOST in "${HOSTS[@]}"; do
    echo -n "[$DATE] Checking $HOST... " | tee -a "$LOG_FILE"
    if ping -c 4 "$HOST" > /dev/null 2>&1; then
        echo "UP" | tee -a "$LOG_FILE"
    else
        echo "DOWN" | tee -a "$LOG_FILE"
        # Optionally send an alert or email here
    fi
done

echo "[$DATE] Network health check finished." | tee -a "$LOG_FILE"
echo "--------------------------------------------------" | tee -a "$LOG_FILE"

exit 0
