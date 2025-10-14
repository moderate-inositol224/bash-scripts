#!/bin/bash

# This script rotates and archives log files based on size or age.
# For more robust log rotation, consider using the 'logrotate' utility.

LOG_DIR="/var/log/custom_logs" # Directory containing logs to manage
MAX_SIZE="100M"               # Maximum size before rotation (e.g., 100M, 1G)
RETENTION_DAYS=7              # Number of days to keep old log files
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

echo "[$DATE] Starting custom log rotation process..."

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Find and process log files
find "$LOG_DIR" -type f -name "*.log" | while read -r logfile; do
    echo "Processing: $logfile"

    # Get current size of the log file
    current_size=$(du -b "$logfile" | cut -f1)
    max_size_bytes=$(echo "$MAX_SIZE" | sed 's/M/*1024*1024/g' | sed 's/G/*1024*1024*1024/g' | bc)

    # Rotate if file exceeds max size
    if [ "$current_size" -gt "$max_size_bytes" ]; then
        echo "Rotating '$logfile' (size: $current_size bytes, threshold: $max_size_bytes bytes)"
        mv "$logfile" "${logfile}.${DATE}.gz"
        gzip "${logfile}.${DATE}.gz"
        # Create a new empty log file
        touch "$logfile"
        echo "New log file created: $logfile"
    fi

    # Clean up old log files
    find "$LOG_DIR" -type f -name "*.log.*.gz" -mtime +"$RETENTION_DAYS" -delete
    echo "Cleaned up log files older than $RETENTION_DAYS days."

done

echo "Custom log rotation process finished."
echo "--------------------------------------------------"

exit 0
