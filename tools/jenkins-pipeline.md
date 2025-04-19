# Jenkins CI/CD Pipeline for Flask App (WSL + Docker + GitHub) 🛠️

---

## ✅ Step 1: Set Up a Jenkins Job

1. Open your Jenkins Dashboard
2. Click **New Item**
3. Name your job: `flask-ci-job`
4. Choose **Freestyle project**
5. Click **OK** to proceed

---

## ✅ Step 2: Connect Your GitHub Repo

### In the **Source Code Management** section:
- Select **Git**
- Enter your repository URL:
```bash
https://github.com/AbhinavOp-git/jenkins-hello.git
```
- Branch to build: `*/main`

---

## ✅ Step 3: Add Build Commands

### Under **Build** → choose **Execute Shell** and paste:
```bash
echo "🚀 Starting Flask CI pipeline..."

# Remove previous clone (if exists)
rm -rf jenkins-hello

# Clone the latest code
git clone https://github.com/AbhinavOp-git/jenkins-hello.git
cd jenkins-hello

# Build Docker image
docker build -t flask-jenkins-demo .

# Remove any existing container
docker rm -f flask-app || true

# Run Flask app
docker run -d --name flask-app -p 8000:8000 flask-jenkins-demo
```

---

## ✅ Step 4: Run Your Pipeline

From your Jenkins job dashboard:
- Click **Build Now**
- Monitor **Console Output**
- Once built, open your browser and go to: [http://localhost:8000](http://localhost:8000)

You should see your Flask app live!

---

## ⚠️ Common Issues & Quick Fixes

### ❌ `docker: not found`
Docker CLI is missing inside Jenkins container.
```bash
docker exec -u 0 -it jenkins bash
apt update && apt install -y docker.io
exit
```

### ❌ `permission denied` with `/var/run/docker.sock`
Make sure you started Jenkins with:
```bash
-u 0 \
-v /var/run/docker.sock:/var/run/docker.sock
```

### ❌ `fatal: not a git repository`
Ensure your workspace is clean and repo is cloned properly.
```bash
rm -rf jenkins-hello
git clone https://github.com/AbhinavOp-git/jenkins-hello.git
cd jenkins-hello
```

### ❌ `port already in use` or name conflict
Free up the port or remove previous container:
```bash
docker rm -f flask-app || true
```

---

## 🎉 What You’ve Achieved

With one click, Jenkins now:
- Clones your GitHub repo
- Builds your Docker image
- Deploys your Flask app in a container

This is your first working CI/CD pipeline – fully automated and real-world ready. 🔥

---

## 🚀 What's Coming Next

- Integrate GitHub Webhooks to trigger builds automatically
- Use Docker Compose for multi-container setups
- Add monitoring with Prometheus + Grafana
- Deploy to cloud with AWS EC2

---

## 🧠 Don’t Forget to Commit Your Progress
```bash
git add .
git commit -m "Documented Jenkins CI/CD pipeline for Flask"
git push origin main
```

You're doing amazing! This is how real DevOps pipelines come alive – keep learning, keep shipping, and let your skills speak louder than words. 🌟💪


