# 🔁 DevOps Day 3 – Jenkins Webhook + CI/CD Pipeline Setup (Step-by-Step)

This log documents the exact steps taken on Day 3 of the DevOps 20-Day Mastery Plan — including ngrok setup, Jenkins container setup, GitHub webhook integration, writing a Jenkinsfile, resolving real errors, and confirming successful pipeline execution.

---

## 📁 Repository Structure

- `jenkins-hello` → main repo to test GitHub → Jenkins integration  
- `devops-master-journey` → contains all tools, logs, and CI/CD setups

---

## ✅ Step 1: Install ngrok on WSL

```bash
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/local/bin
```

---

## ✅ Step 2: Add ngrok Authtoken

```bash
ngrok config add-authtoken <your-token>
```

---

## ✅ Step 3: Start ngrok for Jenkins

```bash
ngrok http 8080
```

Got forwarding URL like:
```
https://1b43-106-201-20-210.ngrok-free.app
```

---

## ✅ Step 4: Open a new WSL terminal (since ngrok blocks the current one)

---

## ✅ Step 5: Navigate to Jenkins Repo

```bash
cd ~/devops-journey/workspace/devops-master-journey/jenkins-hello
```

---

## ✅ Step 6: Create Jenkinsfile

```bash
nano Jenkinsfile
```

Paste:

```groovy
pipeline {
    agent any
    stages {
        stage('Clone') {
            steps {
                echo 'Cloning the repo...'
            }
        }
        stage('Build') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t jenkins-hello .'
            }
        }
        stage('Run') {
            steps {
                echo 'Running hello.sh'
                sh 'chmod +x hello.sh && ./hello.sh'
            }
        }
    }
}
```

Then:
- `Ctrl + O` to save
- `Enter` to confirm
- `Ctrl + X` to exit

---

## ✅ Step 7: Push Jenkinsfile to GitHub

```bash
git add Jenkinsfile
git commit -m "Add Jenkinsfile for Jenkins pipeline"
git push origin main
```

---

## ✅ Step 8: Add Webhook in GitHub

In `https://github.com/AbhinavOp-git/jenkins-hello` →  
Go to `Settings > Webhooks > Add Webhook`

- Payload URL: `https://1b43-106-201-20-210.ngrok-free.app/github-webhook/`
- Content type: `application/json`
- Event: Just **push**

Webhook showed ✅ (200 OK) in GitHub → but job didn’t trigger...

---

## ❌ Issue 1: Jenkins Job Not Triggering from Webhook

### ✅ Fix:

In Jenkins → `jenkins-hello-pipeline` → **Configure**

- Tick: `[x] GitHub hook trigger for GITScm polling`
- Save

---

## ❌ Issue 2: Pipeline Fails with `docker: not found`

Console output:
```
docker: not found
script returned exit code 127
```

### ✅ Fix:

```bash
docker ps
```

Container name was not `jenkins` but:

```
jenkins-devops
```

Then:

```bash
docker exec -u 0 -it jenkins-devops bash
apt update
apt install docker.io -y
exit
```

---

## ✅ Step 9: Push Again to Trigger Webhook

```bash
echo "Triggering Jenkins webhook again" >> README.md
git add .
git commit -m "Re-push to trigger Jenkins webhook"
git push
```

---

## ✅ Step 10: Job Triggered Successfully

- Webhook received ✅  
- Jenkins job started ✅  
- Jenkinsfile executed ✅  
- Docker image built ✅  
- `hello.sh` ran inside container ✅  
- **Pipeline: SUCCESS**

---

## 📝 Files Created Today

- `Jenkinsfile` in `jenkins-hello` repo  
- `jenkins-webhook-pipeline.md` (this doc)  
- README updated to test webhook

---

✅ Completed  
🗂 Saved under: `tools/jenkins-webhook-pipeline.md`  
📘 Logged in: `devops-master-journey` repo
