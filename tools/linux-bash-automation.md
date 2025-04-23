# 🛠️ `tools/linux-bash-automation.md`

## 🧱 Goal:
To get comfortable with Linux commands and Bash scripting in a real-world DevOps setup — building useful tools, automating workflows, and learning by doing everything from scratch.

---

## 📂 Folder Structure:
```
workspace/
├── tools/
│   └── bash-cheatsheet.md
├── scripts/
│   ├── hello.sh
│   ├── deploy.sh
│   └── cleanup.sh
```

---

## 🧠 What I Practiced:
- Navigating Linux file systems using essential commands (`cd`, `ls`, `mkdir`, `rm`, etc.)
- Understanding file permissions and how to use `chmod`, `chown`, and `umask`
- Writing and executing Bash scripts with `#!/bin/bash`
- Using variables, input prompts, and echo formatting (colors!)
- Handling logic with conditions and loops
- Creating reusable Bash functions
- Automating Docker workflows (building, running, and cleaning containers)

---

## 📜 Scripts I Built (with Explanations):

### 🔸 `scripts/hello.sh` — Your First Interactive Bash Script
```bash
#!/bin/bash

# Define colors for output
green='\033[0;32m'
reset='\033[0m'

# Print colored welcome text
echo -e "${green}Welcome to DevOps Bash Scripting!${reset}"

# Use a variable
name="Abhinav"
echo "Your name is: $name"

# Print system date and current directory
echo "Current date and time: $(date)"
echo "You are in: $(pwd)"

# Prompt user input
read -p "What's your favorite DevOps tool? " tool
echo "Nice! You like $tool 😎"
```
🔍 This script gave me confidence in using variables, reading user input, and controlling output styling. It's a mini-interactive intro to Bash scripting.

---

### 🔸 `scripts/deploy.sh` — Automate Flask App Deployment with Docker
```bash
#!/bin/bash

green='\033[0;32m'
red='\033[0;31m'
reset='\033[0m'

echo -e "${green}🚀 Starting Flask App Deployment...${reset}"

# Go to project directory
cd ../docker-monitoring/flask || { echo -e "${red}❌ Flask folder not found!${reset}"; exit 1; }

# Build Docker image
echo -e "${green}📦 Building Docker image...${reset}"
docker build -t flask-monitoring-app .

# Stop existing container if it’s running
if [ "$(docker ps -q -f name=flask-app-script)" ]; then
  echo -e "${green}🛑 Stopping existing container...${reset}"
  docker stop flask-app-script
  docker rm flask-app-script
fi

# Run new container
echo -e "${green}🏃 Running Flask container...${reset}"
docker run -d --name flask-app-script -p 5000:5000 flask-monitoring-app

sleep 2

# Confirm it's running
if docker ps | grep flask-app-script > /dev/null; then
  echo -e "${green}✅ Flask App is running at http://localhost:5000${reset}"
else
  echo -e "${red}❌ Failed to start Flask App${reset}"
fi
```
🔍 This one gave me a true feel of DevOps scripting — packaging logic, docker build, container management, and clean output — all in one.

---

### 🔸 `scripts/cleanup.sh` — Clean Up Docker Environment Safely
```bash
#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
reset='\033[0m'

echo -e "${green}🧹 Starting Docker cleanup...${reset}"

# Stop all containers
echo -e "${green}🛑 Stopping all running containers...${reset}"
docker stop $(docker ps -q)

# Remove all containers
echo -e "${green}🗑️ Removing all containers...${reset}"
docker rm $(docker ps -aq)

# Remove dangling images
echo -e "${green}🧼 Removing dangling images...${reset}"
docker rmi $(docker images -f "dangling=true" -q)

# Optional: Remove all unused volumes (⚠️ Uncomment if needed)
# echo -e "${red}⚠️ Removing unused volumes...${reset}"
# docker volume prune -f

echo -e "${green}✅ Cleanup completed!${reset}"
```
🔍 I now have a go-to utility to reset my Docker environment anytime — without accidentally nuking volumes like Jenkins or Grafana.

---

## 📄 Supporting Doc:
- [`tools/bash-cheatsheet.md`](tools/bash-cheatsheet.md): My go-to Linux + Bash reference with commands, patterns, tips, and reminders.

---

## ✅ Final Thoughts:
Writing and running these scripts has made Linux feel like second nature. I’m no longer intimidated by the terminal. These scripts may be basic, but they’re **practical**, **reusable**, and **already saving time**.

> 📌 This phase was all about comfort and control — scripting your way through the terminal is the foundation of DevOps automation ⚙️
