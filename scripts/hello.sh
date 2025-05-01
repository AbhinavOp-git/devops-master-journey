#!/bin/bash

green='\033[0;32m'
reset='\033[0m'

echo -e "${green}👋 Welcome to DevOps Bash Scripting!${reset}"

name="Abhinav"
echo "👤 Your name is: $name"

echo "🕒 Current date and time: $(date)"
echo "📂 You are in: $(pwd)"

read -p "💬 What's your favorite DevOps tool? " tool
echo "✅ Nice! You like $tool 😎"
