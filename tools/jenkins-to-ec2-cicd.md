# 🚀 CI/CD Flask App Deployment to AWS EC2 using Jenkins (SSH + Docker)

This document captures the exact, real-world process of automating a Flask app deployment from Jenkins to AWS EC2 using SSH and Docker. Every step, every mistake, every fix — no fluff.

---

## 📁 Final Project Folder Structure

```
devops-master-journey/
├── README.md
├── certifications/
├── docker-monitoring/
├── notes/
├── projects/
│   ├── ansible-ec2-setup/
│   ├── flask-aws-deploy/
│   │   ├── Jenkinsfile
│   │   └── ansible/
│   │       ├── files/
│   │       ├── inventory.ini
│   │       └── playbook.yml
│   ├── terraform-ec2/
│   └── terraform.tfstate
├── scripts/
├── test.txt
└── tools/
```

---

## ✅ Step-by-Step Execution (With Context + Clarity)

### 1. Launch EC2 Instance via Terraform

Navigate to your Terraform EC2 project and launch an instance:

```bash
cd projects/terraform-ec2
terraform apply
```

Get the public IP:

```bash
terraform output instance_public_ip
```

This IP is needed for both SSH access and Jenkins deployment.

---

### 2. Generate SSH Key Pair for Jenkins

In WSL (local system):

```bash
ssh-keygen -t rsa -b 4096 -C "jenkins-deploy"
```

Name it: `jenkins-ec2-key` → This creates:

* `~/.ssh/jenkins-ec2-key` (private key)
* `~/.ssh/jenkins-ec2-key.pub` (public key)

---

### 3. Copy Public Key to EC2's authorized\_keys

SSH into EC2 using your own PEM key:

```bash
ssh -i devops-key.pem ec2-user@<ec2-ip>
```

Inside EC2:

```bash
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
```

Paste contents of `jenkins-ec2-key.pub` here and save. Then:

```bash
chmod 600 ~/.ssh/authorized_keys
```

✅ EC2 is now ready to accept SSH connections from Jenkins.

---

### 4. Add Private Key to Jenkins Docker Container

Ensure Jenkins is running locally in Docker:

```bash
docker ps
```

Then:

```bash
docker exec -it jenkins mkdir -p /var/jenkins_home/.ssh
```

Copy your key:

```bash
docker cp ~/.ssh/jenkins-ec2-key <jenkins-container-id>:/var/jenkins_home/.ssh/id_rsa
```

Fix permissions:

```bash
docker exec -it <jenkins-container-id> chmod 600 /var/jenkins_home/.ssh/id_rsa
```

Now Jenkins can SSH into EC2.

---

### 5. Install Docker on EC2

SSH into your EC2 instance:

```bash
ssh -i ~/.ssh/jenkins-ec2-key ec2-user@<ec2-ip>
```

Install Docker:

```bash
sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
```

Logout and log back in so the group update applies.

---

### 6. Create Flask App on EC2

On EC2:

```bash
nano ~/app.py
```

Paste:

```python
from flask import Flask
app = Flask(__name__)
@app.route('/')
def home():
    return "🚀 Flask is live on AWS EC2 with Docker!"
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
```

---

### 7. Jenkinsfile for CI/CD

Location: `projects/flask-aws-deploy/Jenkinsfile`

```groovy
pipeline {
  agent any
  stages {
    stage('Deploy to EC2') {
      steps {
        sh '''
          ssh -o StrictHostKeyChecking=no ec2-user@<ec2-ip> '
          docker run -d -p 5000:5000 -v ~/app.py:/app.py python:3 bash -c "pip install flask && python /app.py"
          '
        '''
      }
    }
  }
}
```

Replace `<ec2-ip>` with your instance’s public IP.

---

### 8. Jenkins Pipeline Configuration

* Open Jenkins → New Item → Pipeline
* Configure:

  * GitHub URL: `https://github.com/AbhinavOp-git/devops-master-journey.git`
  * Script path: `projects/flask-aws-deploy/Jenkinsfile`
  * Branch: `*/main`
* Save → Build Now

---

## 🐞 Real Errors Faced & Resolved

### ❌ `.ssh` folder not found in Jenkins container

✅ Created manually using:

```bash
docker exec -it jenkins mkdir -p /var/jenkins_home/.ssh
```

### ❌ `docker: command not found` on EC2

✅ Installed Docker manually and started the service.

### ❌ Git clone failure in Jenkins (wrong branch)

✅ Fixed by setting branch to `*/main` in pipeline config.

### ❌ Jenkinsfile was trying to re-clone repo

✅ Removed internal `git` block from Jenkinsfile.

### ❌ Flask app failed: `app.py` was a directory

✅ Deleted it and created a proper Python file:

```bash
rm -rf ~/app.py
nano ~/app.py
```

### ❌ Docker port 5000 already in use

✅ Stopped existing containers:

```bash
docker rm -f $(docker ps -q)
```

---

## ✅ Final Output Test

On EC2:

```bash
curl localhost:5000
```

Expected Output:

```
🚀 Flask is live on AWS EC2 with Docker!
```

Browser:

```
http://<ec2-ip>:5000
```

---

## 🧹 Clean Shutdown

### EC2:

```bash
docker ps -q | xargs -r docker stop
docker ps -aq | xargs -r docker rm
```

### Jenkins:

```bash
docker stop jenkins
# Optional full cleanup:
docker rm jenkins && docker volume rm jenkins_home
```

---

## 🎯 What I Actually Learned

* SSH key generation, usage, and injection into Jenkins
* Deploying via Docker using volume mounts
* Automating EC2 deployment from Jenkins using pipeline scripts
* Fixing real errors like SSH issues, Docker exits, Git pipeline failures

This was real DevOps. Not just commands — but actual problem solving 💪
