# 🛠️ tools/linux-bash-automation.md

## 🧱 Goal
Build confidence in the terminal using real Bash scripting and Linux automation — not just hello world scripts, but scripts that actually do stuff. This is where my DevOps muscle memory began.

---

## 📁 Folder Structure
I kept everything neat and modular:
```
├── tools/
│   └── bash-cheatsheet.md     # Linux + Bash essentials
├── scripts/                   # Automation scripts I use daily
│   ├── hello.sh               # Fun starter script
│   ├── deploy.sh              # Auto-deploy Flask via Docker
│   └── cleanup.sh             # Clean all Docker clutter safely
```

---

## 🧠 What I Practiced
- Navigating Linux: `cd`, `ls`, `mkdir`, `rm`, `pwd`
- Permissions: `chmod`, `chown`, file safety
- Writing proper Bash scripts: `#!/bin/bash`, variables, `echo -e`, color-coded outputs
- Reading user input and printing formatted info
- Adding Docker automation inside Bash
- Creating scripts that are actually *reusable* in DevOps

---

## 📜 The Scripts I Wrote

### 🔸 hello.sh — Bash Scripting Warm-Up
```bash
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
```
🔍 *This script was like my terminal ice-breaker. I started using variables, user input, and terminal color codes — it was my first "hey this feels real" moment.*

---

### 🔸 deploy.sh — Dockerize and Launch Flask App
```bash
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
```
🔍 *The moment this worked, I felt like I deployed my first microservice — in seconds. Total DevOps buzz.*

---

### 🔸 cleanup.sh — Wipe Docker Without Fear
```bash
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

# Optional: Uncomment for full volume reset
# echo -e "${red}⚠️ Removing unused volumes...${reset}"
# docker volume prune -f

echo -e "${green}✅ Docker environment cleaned.${reset}"
```
🔍 *This one's my reset button. Anytime Docker gets messy — boom, it's clean again. Zero fear of leftover containers.*

---

## 📄 Reference Material
- `tools/bash-cheatsheet.md`: My single-file Linux & Bash quick-ref — lifesaver during scripting.

---

## ✅ My Takeaway
This was where I stopped copy-pasting and started scripting with purpose.

I *built* tools.
I *debugged* errors.
I *ran* them over and over and got results.

And now, scripting isn’t scary — it’s my daily tool.

📌 **Linux + Bash + Docker = 🔥 DevOps power combo.**
