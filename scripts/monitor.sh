#!/bin/bash

while true
do
  clear
  echo "==============================="
  echo "   🧠 System Resource Monitor"
  echo "==============================="
  echo
  echo "📊 CPU Usage:"
  top -bn1 | grep "Cpu(s)" | awk '{print "CPU Load: " $2 + $4 "%"}'
  
  echo
  echo "💾 Memory Usage:"
  free -h

  echo
  echo "🗄️ Disk Usage:"
  df -h | grep "^/dev"

  echo
  echo "Press [CTRL+C] to stop monitoring"
  sleep 5
done
