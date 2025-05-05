# 🚀 EC2 Provisioning + Docker Setup with Ansible

Let’s walk through a simple but powerful DevOps setup: launching an EC2 instance using Terraform, and then configuring that instance with Docker using Ansible. This is one of those foundational workflows every DevOps engineer should master.

---

## 🧱 Step 1: Launching EC2 with Terraform

We started by jumping into our Terraform project folder:

```bash
cd ~/devops-master-journey/projects/terraform-ec2
```

Initialized Terraform:

```bash
terraform init
```

Then launched the EC2 instance:

```bash
terraform apply -auto-approve
```

Once the resources were up, we grabbed the public IP:

```bash
terraform output instance_ip
```

Kept this IP noted — it’s needed for both SSH and Ansible.

---

## 🔐 Step 2: SSH Access Setup

To securely connect to our EC2 instance, we moved and locked down the `.pem` key:

```bash
mv ~/Downloads/devops-key.pem ~/.ssh/
chmod 400 ~/.ssh/devops-key.pem
```

Then SSH’d into the instance:

```bash
ssh -i ~/.ssh/devops-key.pem ec2-user@<public-ip>
```

> Swap out `<public-ip>` with the one Terraform gave you.

---

## ⚙️ Step 3: Installing Ansible on WSL

Next, we set up Ansible in our WSL Ubuntu terminal:

```bash
sudo apt update
sudo apt install ansible -y
```

And confirmed it’s working:

```bash
ansible --version
```

---

## 📁 Step 4: Setting Up the Ansible Project

To keep things clean, we created a dedicated directory:

```bash
mkdir -p ~/devops-master-journey/projects/ansible-ec2-setup
cd ~/devops-master-journey/projects/ansible-ec2-setup
```

---

## 🗂 Step 5: Creating the Inventory File

We created `inventory.ini` with the following:

```ini
[web]
<public-ip> ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/devops-key.pem
```

> Again, replace `<public-ip>` with the real one.

---

## 🧪 Step 6: Testing the Ansible Connection

Let’s make sure Ansible can talk to our EC2 box:

```bash
ansible -i inventory.ini web -m ping
```

If it replies with `"ping": "pong"`, everything’s set 🎯

---

## 🧾 Step 7: Writing the Ansible Playbook

Now the fun part — automating the Docker setup. We created `playbook.yml`:

```yaml
---
- name: Configure EC2 Instance
  hosts: web
  become: true

  tasks:
    - name: Update all system packages
      yum:
        name: '*'
        state: latest

    - name: Install Docker
      yum:
        name: docker
        state: present

    - name: Start and enable Docker service
      systemd:
        name: docker
        state: started
        enabled: true
```

---

## ▶️ Step 8: Running the Playbook

Time to automate the config:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

Ansible SSH’d into the EC2 machine and took care of everything: package update, Docker install, service start — all in one go.

---

## 🔍 Step 9: Verifying the Setup on EC2

Jumped back into the EC2 instance:

```bash
ssh -i ~/.ssh/devops-key.pem ec2-user@<public-ip>
```

And verified Docker:

```bash
docker --version
sudo systemctl status docker
```

Docker was running ✅ No manual install, no missed steps.

---

## 🧾 Wrap-Up

* EC2 was launched using Terraform
* SSH access was secured
* Ansible was installed and configured
* Docker was fully set up through an automated playbook

This is how infrastructure should be: **automated, consistent, and repeatable** 🛠️🔥
