# 🚀 Flask App Deployment on AWS (Terraform + Ansible + Docker)

This wasn’t just theory — this was full-on DevOps in action. I deployed a Flask app on an AWS EC2 instance using Terraform for infra provisioning, Ansible for configuration, and Docker for running the app. Here’s exactly how it went down:

---

## 📁 Project Structure

```
flask-aws-deploy/
├── terraform/       # EC2 infra setup
├── ansible/         # Configuration automation
│   ├── files/
│   │   └── app.py   # Flask app
│   ├── inventory.ini
│   └── playbook.yml
└── README.md
```

---

## ✅ Step 1: EC2 Instance Using Terraform

I launched a t2.micro EC2 instance using Terraform. Everything went smoothly — until I forgot to add the output block 😅

### 🔧 Fix:

Added this in `outputs.tf`:

```hcl
output "instance_public_ip" {
  value = aws_instance.devops_server.public_ip
}
```

Then ran:

```bash
terraform apply -auto-approve
terraform output instance_public_ip
```

---

## ✅ Step 2: SSH Access

Connected to the EC2 instance using my `.pem` key:

```bash
chmod 400 ~/.ssh/devops-key.pem
ssh -i ~/.ssh/devops-key.pem ec2-user@<public-ip>
```

SSH worked fine after I used the correct username (`ec2-user`) and permission (`chmod 400`).

---

## ✅ Step 3: Ansible Setup

Inside the `ansible/` folder:

### 🔹 `inventory.ini`

```ini
[web]
<public-ip> ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/devops-key.pem
```

### 🔹 `playbook.yml`

Installed Docker, copied the Flask app, and launched it in a container.

```yaml
- name: Setup Flask App on EC2 using Docker
  hosts: web
  become: yes
  tasks:
    - name: Install Docker
      apt:
        name: docker.io
        state: present

    - name: Start Docker
      service:
        name: docker
        state: started
        enabled: true

    - name: Copy Flask App
      copy:
        src: files/app.py
        dest: /home/ec2-user/app.py

    - name: Run Flask App in Docker
      shell: docker run -d -p 5000:5000 -v /home/ec2-user/app.py:/app.py python:3 bash -c "pip install flask && python /app.py"
```

---

## ✅ Step 4: Flask App Creation

Created `app.py` inside `ansible/files/` and later on EC2 too:

```python
from flask import Flask
app = Flask(__name__)
@app.route('/')
def home():
    return "🚀 Flask is live on AWS EC2 with Docker!"
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
```

Ran this from EC2:

```bash
sudo docker run -d -p 5000:5000 -v $PWD/app.py:/app.py python:3 bash -c "pip install flask && python /app.py"
```

---

## 😵‍💫 Problem Faced: App Not Loading in Browser

* `curl localhost:5000` worked
* But browser showed timeout ❌

### ✅ Fix:

I forgot to open port `5000` in the EC2 security group. Went to AWS Console → EC2 → Security Group → Inbound Rules:

**Added this rule:**

```
Type: Custom TCP | Port: 5000 | Source: 0.0.0.0/0
```

Then it worked 🎉

---

## ✅ Final Test

👉 Visited: [http://65.0.127.99:5000](http://65.0.127.99:5000)
💥 Output: "🚀 Flask is live on AWS EC2 with Docker!"

---

## ✅ Cleanup

To avoid billing, I destroyed the EC2:

```bash
cd terraform
target destroy -auto-approve
```

And exited SSH.

---

## 🎯 Outcome

This wasn’t copy-paste. I hit real errors. I fixed them. I deployed something real. This is DevOps. This is progress 💪
