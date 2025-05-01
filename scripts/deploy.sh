#!/bin/bash

green='\033[0;32m'
red='\033[0;31m'
reset='\033[0m'

echo -e "${green}🚀 Starting Flask App Deployment...${reset}"

cd ../docker-monitoring/flask || { echo -e "${red}❌ Flask folder not found!${reset}"; exit 1; }

echo -e "${green}📦 Building Docker image...${reset}"
docker build -t flask-monitoring-app .

if [ "$(docker ps -q -f name=flask-app-script)" ]; then
  echo -e "${green}🛑 Stopping existing container...${reset}"
  docker stop flask-app-script
  docker rm flask-app-script
fi

echo -e "${green}🏃 Running new Flask container...${reset}"
docker run -d --name flask-app-script -p 5000:5000 flask-monitoring-app

sleep 2

if docker ps | grep flask-app-script > /dev/null; then
  echo -e "${green}✅ Flask App is live at http://localhost:5000${reset}"
else
  echo -e "${red}❌ Failed to start Flask App${reset}"
fi
