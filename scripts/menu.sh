#!/bin/bash

while true; do
  echo "========= DevOps Menu ========="
  echo "1. Show disk usage"
  echo "2. Show running Docker containers"
  echo "3. Show active services"
  echo "4. Exit"
  echo "==============================="

  read -p "Choose an option [1-4]: " choice

  case $choice in
    1) df -h ;;
    2) docker ps ;;
    3) systemctl list-units --type=service --state=running ;;
    4) echo "Exiting..."; break ;;
    *) echo "Invalid choice. Try again." ;;
  esac

  echo
done
