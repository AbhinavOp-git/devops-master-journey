# Jenkins Setup (WSL + Docker + GitHub Integration) 🛠️

## ✅ Step 1: Install Git (Version Control)
```bash
sudo apt update
sudo apt install -y git
```

### Set Git Global Config
```bash
git config --global user.name "AbhinavOp-git"
git config --global user.email "rajabhinav1001@gmail.com"
git config --global credential.helper store
```

---

## ✅ Step 2: Install Docker (Container Engine)
```bash
sudo apt update
sudo apt install -y docker.io
sudo usermod -aG docker $USER
```

### Apply Docker Group Change
```bash
newgrp docker
```

### Verify Docker Installation
```bash
docker --version
```

---

## ✅ Step 3: Run Jenkins in Docker with Access to Host Docker
```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -u 0 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

---

## ✅ Step 4: Unlock Jenkins and Initial Setup
### Open Jenkins UI
```bash
http://localhost:8080
```

### Retrieve Admin Password
```bash
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### Continue in UI:
- Paste the password
- Install Suggested Plugins
- Create Jenkins Admin User

---

## ✅ Step 5: Create a Freestyle Project in Jenkins
- Jenkins Dashboard → New Item
- Name: `flask-ci-job`
- Select: **Freestyle Project**

### Under Source Code Management (Git)
```bash
Repository URL: https://github.com/AbhinavOp-git/jenkins-hello.git
Branch: */main
```

---

## ✅ Step 6: Add Shell Script in Build Step
```bash
echo "🚀 Running Flask CI Job..."

# Remove existing folder if present
rm -rf jenkins-hello

# Clone fresh copy of repo
git clone https://github.com/AbhinavOp-git/jenkins-hello.git
cd jenkins-hello

# Build Docker image
docker build -t flask-jenkins-demo .

# Remove any previous container with same name
docker rm -f flask-app || true

# Run new container
docker run -d --name flask-app -p 8000:8000 flask-jenkins-demo
```

---

## ✅ Step 7: Test the Pipeline
```bash
# In Jenkins:
# 1. Go to 'flask-ci-job'
# 2. Click 'Build Now'
# 3. Open Console Output
# 4. Check browser: http://localhost:8000
```

---

## 🛠️ Common Errors & Fixes

### ❌ Error: `docker: not found`
```bash
# Fix: Install Docker CLI inside Jenkins container
docker exec -u 0 -it jenkins bash
apt-get update && apt-get install -y docker.io
exit
```

### ❌ Error: `permission denied while accessing /var/run/docker.sock`
```bash
# Fix: Ensure Jenkins container was run with Docker socket mounted and as root (-u 0)
```

### ❌ Error: `fatal: not a git repository`
```bash
# Fix: Make sure Jenkins job is cloning repo or do it manually in the script:
rm -rf jenkins-hello
git clone https://github.com/AbhinavOp-git/jenkins-hello.git
cd jenkins-hello
```

### ❌ Error: `Port already in use` or `Container name conflict`
```bash
# Fix: Remove old container before starting new

docker rm -f flask-app || true
```

---

✅ **ALL SET!** 🎯
You now have a fully working Jenkins CI/CD pipeline:
- Code hosted on GitHub
- Jenkins pulls + builds it
- Docker image gets created
- Flask app runs live on port 8000

You're building like a real DevOps Engineer 💪🚀

