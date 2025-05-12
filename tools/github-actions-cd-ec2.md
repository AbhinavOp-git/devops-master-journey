# 📘 GitHub Actions CI/CD to EC2 — Full Setup Guide

This document covers GitHub Actions CI and **pre-Kubernetes (GitHub Actions CD)** with complete step-by-step execution. You’ll deploy a Flask app via Docker on EC2 using GitHub Actions — no manual SSH needed.

---

## 🎯 Project Objectives

* Set up GitHub Actions CI pipeline
* Provision EC2 using Terraform
* Create and run Flask app via Docker inside EC2
* Automate deployment from GitHub using GitHub Actions + SSH

---

## 🗂️ Folder Structure

```
.devops-master-journey/
├── .github/workflows/deploy.yml       # CI/CD Workflow
├── projects/
│   ├── terraform-ec2/                 # Terraform EC2 infra
│
├── tools/
│   └── github-actions-cd-ec2.md      # This guide
```

---

## 🔧 Step-by-Step Setup with Issues & Fixes

### ✅ 1. Launch EC2 with Terraform

```bash
cd ~/devops-master-journey/projects/terraform-ec2
terraform apply -auto-approve
```

Then:

```bash
terraform output instance_public_ip
```

🔍 **Issue Faced:** Public key not injected properly → SSH failed
💡 **Fix:** Generated a new key pair using `ssh-keygen`, updated public key in Terraform

---

## 🗝️ SSH Key Setup (Expanded)

### ✅ 2. Generate New Key Pair

```bash
ssh-keygen -t rsa -b 4096 -C "github-actions-cicd"
```

Name it `id_rsa` when prompted and store in `~/.ssh/`

It will create:

* `~/.ssh/id_rsa` → Private Key
* `~/.ssh/id_rsa.pub` → Public Key

### ✅ 3. Add Key Pair to Terraform

In `main.tf`, add:

```hcl
resource "aws_key_pair" "dev_key" {
  key_name   = "devops-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
```

Then use it in your instance:

```hcl
key_name = aws_key_pair.dev_key.key_name
```

🔍 **Issue Faced:** Wrong key path or invalid key format
💡 **Fix:** Confirmed `id_rsa.pub` path and correct file content copied

---

### ✅ 4. SSH into EC2

```bash
ssh -i ~/.ssh/id_rsa ec2-user@<public-ip>
```

🔍 **Issue Faced:** `Permission denied (publickey)`
💡 **Fix:** Used correct `-i` flag and regenerated keys when necessary

---

### ✅ 5. Install Docker on EC2

```bash
sudo yum update -y
sudo amazon-linux-extras enable docker
sudo yum install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user
exit
```

Then re-login:

```bash
ssh -i ~/.ssh/id_rsa ec2-user@<public-ip>
```

🔍 **Issue Faced:** `docker: command not found`
💡 **Fix:** Enabled Amazon Linux Extras and reinstalled Docker

---

### ✅ 6. Create Flask App in EC2

```bash
mkdir -p ~/flask-docker-app
cd ~/flask-docker-app
nano app.py
```

Paste this code:

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "🚀 Flask is live on AWS EC2 with Docker!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

🔍 **Issue Faced:** Created a directory `app.py` instead of file
💡 **Fix:** Deleted folder, recreated using `nano app.py`

---

### ✅ 7. Run Flask with Docker (Manual Check)

```bash
sudo docker run -d -p 5000:5000 \
  -v $PWD/app.py:/app.py \
  python:3 bash -c "pip install flask && python /app.py"
```

```bash
curl localhost:5000
```

Browser:

```
http://<public-ip>:5000
```

🔍 **Issue Faced:** Not loading in browser
💡 **Fix:** Opened port 5000 in EC2 Security Group

---

### ✅ 8. GitHub Secrets for SSH Access

#### Copy Private Key

```bash
cat ~/.ssh/id_rsa
```

Then go to GitHub Repo → Settings → Secrets → Actions:

* Name: `EC2_SSH_KEY`
* Value: Paste private key

🔍 **Issue Faced:** Invalid key format
💡 **Fix:** Used PEM format, ensured no newline issues

---

### ✅ 9. Create `.github/workflows/deploy.yml`

```yaml
name: Flask CI/CD

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.10'

    - name: Install dependencies
      run: pip install -r requirements.txt

    - name: Run dummy test
      run: echo "✅ Flask app is ready for deployment"

    - name: Setup SSH Key
      run: |
        echo "${{ secrets.EC2_SSH_KEY }}" > key.pem
        chmod 400 key.pem

    - name: Deploy to EC2 via SSH
      run: |
        ssh -o StrictHostKeyChecking=no -i key.pem ec2-user@<EC2_PUBLIC_IP> << 'EOF'
          docker rm -f $(docker ps -aq) || true
          docker run -d -p 5000:5000 \
            -v ~/flask-docker-app/app.py:/app.py \
            python:3 bash -c "pip install flask && python /app.py"
        EOF
```

🔍 **Issue Faced:** Not triggering or failing mid-pipeline
💡 **Fix:** Fixed indentation and filename placement in `.github/workflows/`

---

### ✅ 10. Final Validation

* Visit: `http://<public-ip>:5000`
* EC2 terminal: `docker ps` → should show Flask container
* GitHub → Actions tab → ✅ Passed deployment badge

Badge:

```md
![GitHub Actions](https://github.com/AbhinavOp-git/devops-master-journey/actions/workflows/deploy.yml/badge.svg)
```

✅ You now have full CI/CD to EC2 via GitHub Actions.
