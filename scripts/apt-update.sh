#!/bin/bash

# This script automates the process of updating and upgrading packages on Debian-based systems.

LOG_FILE="/var/log/system_update.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$DATE] Starting system update process..." | tee -a "$LOG_FILE"

# Update the package list
echo "[$DATE] Running apt update..." | tee -a "$LOG_FILE"
if apt update >> "$LOG_FILE" 2>&1; then
    echo "[$DATE] Package list updated successfully." | tee -a "$LOG_FILE"
else
    echo "[$DATE] ERROR: Failed to update package list." | tee -a "$LOG_FILE"
    exit 1
fi

# Upgrade installed packages
echo "[$DATE] Running apt upgrade..." | tee -a "$LOG_FILE"
if apt upgrade -y >> "$LOG_FILE" 2>&1; then
    echo "[$DATE] Packages upgraded successfully." | tee -a "$LOG_FILE"
else
    echo "[$DATE] WARNING: Some packages may not have been upgraded successfully. Check log for details." | tee -a "$LOG_FILE"
fi

# Perform distribution upgrade (handles dependency changes and new packages)
echo "[$DATE] Running apt dist-upgrade..." | tee -a "$LOG_FILE"
if apt dist-upgrade -y >> "$LOG_FILE" 2>&1; then
    echo "[$DATE] Distribution upgrade completed successfully." | tee -a "$LOG_FILE"
else
    echo "[$DATE] WARNING: Some distribution upgrade tasks may have failed. Check log for details." | tee -a "$LOG_FILE"
fi

# Autoremove unused packages
echo "[$DATE] Running apt autoremove..." | tee -a "$LOG_FILE"
if apt autoremove -y >> "$LOG_FILE" 2>&1; then
    echo "[$DATE] Unused packages removed successfully." | tee -a "$LOG_FILE"
else
    echo "[$DATE] WARNING: Some unused packages may not have been removed successfully. Check log for details." | tee -a "$LOG_FILE"
fi

# Clean up downloaded package files
echo "[$DATE] Running apt clean..." | tee -a "$LOG_FILE"
if apt clean >> "$LOG_FILE" 2>&1; then
    echo "[$DATE] Package cache cleaned successfully." | tee -a "$LOG_FILE"
else
    echo "[$DATE] WARNING: Failed to clean package cache." | tee -a "$LOG_FILE"
fi

echo "[$DATE] System update process finished." | tee -a "$LOG_FILE"
echo "--------------------------------------------------" | tee -a "$LOG_FILE"

exit 0
