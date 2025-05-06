#!/bin/bash

echo "🧹 Log Cleaner — Remove old logs"

# Ask for the directory
read -p "Enter log directory (e.g., /var/log or ./logs): " LOG_DIR

# Ask how old logs should be (in days)
read -p "Delete logs older than how many days? " DAYS

echo "Scanning $LOG_DIR for files older than $DAYS days..."

# Find and delete
find "$LOG_DIR" -type f -mtime +"$DAYS" -name "*.log" -exec rm -fv {} \;

echo "✅ Cleanup complete."
