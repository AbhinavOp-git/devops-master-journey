#!/bin/bash

echo "🧨 Port Killer — Kill process running on a specific port"

read -p "Enter the port number: " PORT

PID=$(lsof -t -i:$PORT)

if [ -z "$PID" ]; then
  echo "✅ No process is running on port $PORT"
else
  echo "⚠️ Process $PID is running on port $PORT"
  read -p "Do you want to kill it? (y/n): " CONFIRM
  if [[ "$CONFIRM" == "y" ]]; then
    kill -9 $PID
    echo "✅ Killed process $PID"
  else
    echo "❌ Kill cancelled."
  fi
fi
