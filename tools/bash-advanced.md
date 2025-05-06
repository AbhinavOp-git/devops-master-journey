# ⚙️ Bash Scripting Mastery II — Real-World Tools

Built real-world, production-ready Bash scripts that help manage and monitor systems like a true DevOps engineer. No tutorials — just pure automation.

---

## 📁 Folder: `scripts/`

All scripts are saved inside:

```
~/devops-master-journey/scripts/
```

---

## 📜 1. `menu.sh` — Interactive DevOps CLI Menu

A terminal dashboard to perform routine checks easily.

### 🔧 Features:

* Shows disk usage
* Lists running Docker containers
* Displays active system services
* Easy CLI navigation

```bash
./menu.sh
```

---

## 🧹 2. `log-cleaner.sh` — Old Log Deletion Script

This script deletes `.log` files older than a specified number of days. Helps save disk space on servers.

### 💡 Features:

* Takes directory input
* Takes day limit input
* Finds and deletes old logs
* Use `sudo` if needed for system log paths

```bash
./log-cleaner.sh
```

---

## 🔫 3. `port-killer.sh` — Kill Process on a Port

Sometimes ports like 3000 or 8080 are busy — this tool kills the process running on a selected port.

### 💡 Features:

* Prompts for a port
* Finds the PID
* Confirms before killing
* Useful when services don’t shut cleanly

```bash
./port-killer.sh
```

---

## 📊 4. `monitor.sh` — Live System Resource Dashboard

Displays live stats of CPU, memory, and disk every 5 seconds. Use it to monitor your system like `htop`, but with your own script.

### 💡 Features:

* CPU usage with `top`
* Memory usage with `free -h`
* Disk usage with `df -h`
* Auto-refresh every 5s

```bash
./monitor.sh
```

---

## ✅ Final Thoughts

These scripts are now part of the DevOps toolkit:

* Can be reused on EC2, WSL, or real servers
* Automate daily tasks without remembering commands
* Show hands-on scripting skills that matter in interviews

🧠 Bash isn’t just terminal commands — it’s how you control the system. And this proves it.

---
