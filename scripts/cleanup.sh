#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
reset='\033[0m'

echo -e "${green}🧹 Starting Docker cleanup...${reset}"

echo -e "${green}🛑 Stopping running containers...${reset}"
docker stop $(docker ps -q)

echo -e "${green}🗑️ Removing containers...${reset}"
docker rm $(docker ps -aq)

echo -e "${green}🧼 Removing dangling images...${reset}"
docker rmi $(docker images -f "dangling=true" -q)

# Optional volume cleanup
# echo -e "${red}⚠️ Removing unused volumes...${reset}"
# docker volume prune -f

echo -e "${green}✅ Docker environment cleaned.${reset}"

