# 📘 SSH into EC2 Instance — A Real-World Journey (Tools Section)

This isn't just a guide — this is exactly what we did, with all the wins, mistakes, and lessons learned, like real engineers. No robotic language here, just a genuine DevOps experience 🚀.

---

# 🚀 Why SSH Access Matters So Much in DevOps
- SSH is your **bridge to the cloud**.
- It's how you control, manage, and breathe life into your cloud servers.
- Whether setting up Docker, Git, or Jenkins — SSH is your first handshake with the machine.

In short? No SSH = No DevOps.

---

# 🛠️ Here's How Our Journey Went (With Full Honesty)


## 1. Creating a New Key Pair (The Right Way)
- Jumped into AWS Console → EC2 → **Key Pairs** → **Create Key Pair**.
- Picked **RSA** and `.pem` format.
- Named it something cool like `devops-key`.
- Downloaded it immediately — because AWS gives you only one shot!

> ❗ First Mistake: Tried using an old `.pem` from another EC2. Spoiler: it didn't work. Learned that each instance must have a matching key.


## 2. Moving the Key into WSL (Windows + Linux Confusion)
- Opened WSL and ran:

```bash
mkdir -p ~/.ssh
cp /mnt/c/Users/<your-windows-username>/Downloads/devops-key.pem ~/.ssh/
```

✅ Replaced `<your-windows-username>` carefully.

> ❗ Struggled for a minute: Forgot that Windows drives show up in WSL as `/mnt/c/`. Rookie moment.


## 3. Fixing Key Permissions (Or Facing SSH's Wrath)

```bash
chmod 400 ~/.ssh/devops-key.pem
```

✅ Because if the key is too "open", SSH straight up refuses to connect.

> ❗ Forgot `chmod 400` the first time. Got a scary error: "UNPROTECTED PRIVATE KEY FILE". Fixed it, moved on.


## 4. Updating Terraform to Attach the Key

Inside `main.tf`, updated the EC2 resource:

```hcl
resource "aws_instance" "devops_server" {
  ami           = "ami-02bb7d8191b50f4bb"
  instance_type = var.instance_type
  key_name      = "devops-key"  # 👈 Critical!

  tags = {
    Name = var.instance_name
  }
}
```

✅ Told Terraform: "Hey, use this key for SSH!"


## 5. Launching the EC2 Instance (Finally!)

```bash
terraform init
terraform plan
terraform apply
```

✅ Got a shiny new Public IP on success.

> ❗ Initial EC2 launched without a key because we forgot `key_name`. Terminated it. Started fresh. DevOps is about iteration.


## 6. Connecting via SSH (The Big Moment)

```bash
ssh -i ~/.ssh/devops-key.pem ec2-user@<your-public-ip>
```

✅ For Amazon Linux, the username is `ec2-user`.
✅ For Ubuntu images, it would have been `ubuntu`.

> ❗ First connection attempt failed: Used wrong username! Lesson learned forever.


# 🌟 Problems We Hit (And Crushed)

| Problem | Real Reason | How We Fixed It |
|:---|:---|:---|
| Permission Denied (publickey) | Wrong `.pem` permissions or wrong username | Ran `chmod 400`, double-checked username |
| Connection Timed Out | Port 22 not open in Security Group | Added inbound SSH rule (Port 22) to SG |
| PEM didn't match | Used wrong `.pem` for new instance | Created fresh Key Pair, updated Terraform |


# 📜 Quick SSH Checklist Before You Even Try to Connect

✅ `.pem` is sitting safely in `~/.ssh/`

✅ `chmod 400` is done

✅ `key_name` properly attached in Terraform

✅ EC2 Security Group allows **port 22** (SSH)

✅ You know your AMI and correct username

✅ You have the right Public IP


---

# 🫠 Pro Tip: How to Disconnect from SSH

Just type:

```bash
exit
```

✅ And you're back in your WSL/Linux terminal.


---

# 🚀 What We Really Achieved Today
✅ Built infrastructure (EC2) using Terraform.  
✅ Fixed key problems like pros.  
✅ Connected securely into a live cloud server.

✅ In short: You didn't just "learn SSH" — you completed a **full Cloud DevOps cycle**, start to finish. 🔥

---

Congratulations, Engineer! 🌟🚀  
This is how real-world DevOps gets done. Not perfect on the first try, but relentless until it’s working. 💪


---

# 📈 Terraform + GitHub Push Problems Faced (Reality Check)


## ❗ Terraform `.terraform/` Folder Nightmare
- Problem: Terraform downloaded heavy provider files (>600MB) exceeding GitHub’s 100MB file size limit.
- Solution: Deleted `.terraform/` locally. Added `.terraform/` into `.gitignore`. Fresh `terraform init` can always recreate it.


## ❗ tfstate & tfstate.backup Issue
- Problem: Terraform state files (`terraform.tfstate`, `terraform.tfstate.backup`) got committed.
- Solution: Added them into `.gitignore`. They are critical sensitive files (contain secrets!). Best practice: store tfstate remotely (S3 backend).


## ❗ Re-pushing Project
- Had to re-clone clean repo.
- Moved Terraform EC2 files properly into `projects/terraform-ec2/` directory.
- Deleted heavy unwanted files.
- Committed and pushed only the clean code.


# 🌟 Final Real-World Lesson

> **Always commit only code — never commit Terraform local state, .terraform provider binaries, or secrets.**

This is how professionals manage GitHub in DevOps and Cloud projects.


---

# 🌟 Next Target:
Ready to move towards provisioning more infrastructure and mastering IaC (Infrastructure as Code) professionally! ✨
