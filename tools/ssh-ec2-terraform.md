# 📘 Provision EC2 with Terraform + SSH Access — Complete Step-by-Step Setup

This guide is a complete walkthrough of provisioning an EC2 instance on AWS using Terraform and accessing it via SSH. It's broken down clearly into steps — from installation to GitHub hygiene — so you can replicate the setup confidently and learn practical DevOps skills.

---

## 🌍 What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool developed by HashiCorp. It allows you to define and provision infrastructure like servers and networks using configuration files. These files are executed to create infrastructure on platforms like AWS, Azure, or GCP automatically and repeatedly.

---

## 🔧 Step-by-Step: Install Terraform on WSL/Linux

### Step 1: Add the HashiCorp repo and install Terraform

```bash
sudo apt update && sudo apt install -y gnupg curl software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform
```

### Step 2: Confirm the installation

```bash
terraform -v
```

Output should show a version like `Terraform v1.11.3` or higher.

---

## 🔐 Step-by-Step: Create IAM User + Configure AWS CLI

### Step 1: Create a new IAM user

* Go to AWS Console → IAM → Users → Create User
* Enable **Programmatic Access**
* Attach **AmazonEC2FullAccess** permission
* Download and save **Access Key ID** and **Secret Access Key**

### Step 2: Configure AWS CLI with credentials

```bash
aws configure
```

Fill in:

* AWS Access Key ID
* AWS Secret Access Key
* Region (e.g., `ap-south-1`)
* Output format: `json`

---

## 🔑 Step-by-Step: Create and Setup SSH Key for EC2

### Step 1: Create Key Pair in AWS

* AWS Console → EC2 → Key Pairs → Create Key Pair
* Type: **RSA**, Format: **.pem**
* Name it `devops-key`
* Download `.pem` file immediately (you only get one chance)

### Step 2: Move PEM key to WSL and set permissions

```bash
mkdir -p ~/.ssh
cp /mnt/c/Users/<your-windows-username>/Downloads/devops-key.pem ~/.ssh/
chmod 400 ~/.ssh/devops-key.pem
```

Replace `<your-windows-username>` with your actual Windows username.

---

## 📁 Folder Structure for Terraform Project

```
projects/
└── terraform-ec2/
    ├── main.tf
    ├── provider.tf
    ├── variables.tf
    ├── outputs.tf
```

---

## 🧾 Create Terraform Configuration Files

### `provider.tf`

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

### `variables.tf`

```hcl
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for EC2 instance"
  type        = string
  default     = "DevOps-Terraform-Instance"
}
```

### `main.tf`

```hcl
resource "aws_instance" "devops_server" {
  ami           = "ami-02bb7d8191b50f4bb"
  instance_type = var.instance_type
  key_name      = "devops-key"

  tags = {
    Name = var.instance_name
  }
}
```

### `outputs.tf`

```hcl
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.devops_server.public_ip
}

output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.devops_server.id
}
```

---

## 🚀 Step-by-Step: Provision EC2 Using Terraform

### Step 1: Navigate to your Terraform project folder

```bash
cd ~/devops-master-journey/projects/terraform-ec2
```

### Step 2: Initialize Terraform

```bash
terraform init
```

### Step 3: Preview changes

```bash
terraform plan
```

### Step 4: Apply and create resources

```bash
terraform apply
```

Type `yes` when prompted. You will see the public IP printed at the end.

---

## 🔌 Step-by-Step: SSH into EC2 Instance

### Command to SSH into your instance:

```bash
ssh -i ~/.ssh/devops-key.pem ec2-user@<public-ip-address>
```

Replace `<public-ip-address>` with the IP shown after Terraform apply.

* Use `ec2-user` for Amazon Linux
* Use `ubuntu` for Ubuntu AMIs

---

## 🧯 Common Errors and Fixes

| Error                         | Likely Cause                | Solution                                                         |
| ----------------------------- | --------------------------- | ---------------------------------------------------------------- |
| Permission denied (publickey) | Wrong username or key perms | Use correct username and run `chmod 400` on the PEM file         |
| Connection timed out          | Port 22 not open            | Add SSH rule to EC2 security group for port 22 (inbound)         |
| PEM mismatch                  | Used wrong or old PEM file  | Create new key pair, update `key_name` in `main.tf`, apply again |

---

## ✅ Final SSH Checklist Before You Connect

* [x] `.pem` file stored in `~/.ssh/`
* [x] Permissions set with `chmod 400`
* [x] EC2 instance uses correct `key_name`
* [x] Port 22 open in EC2 Security Group
* [x] Username matches OS (ec2-user / ubuntu)

---

## 🗂️ Step-by-Step: GitHub Push Best Practices

### Problem: `.terraform/` directory is too large

* These are provider binaries that aren't needed in GitHub
* ✅ Fix: Add `.terraform/` to `.gitignore` before pushing

### Problem: `terraform.tfstate` and `.backup` committed by mistake

* These files can contain secrets
* ✅ Fix: Add both files to `.gitignore`

### Recommended Git Push Flow:

```bash
cd ~/devops-master-journey
nano .gitignore
# Add .terraform/, terraform.tfstate, terraform.tfstate.backup

git add .
git commit -m "Add Terraform EC2 provisioning setup"
git push origin main
```

---

## 🎯 Recap — What You’ve Achieved

✅ Installed Terraform on WSL
✅ Set up AWS IAM user and configured CLI
✅ Created EC2 provisioning config using `.tf` files
✅ Created Key Pair and successfully connected via SSH
✅ Understood and avoided common GitHub and Terraform mistakes

You now have a working EC2 infrastructure with SSH access — completely automated and production-ready.

📄 Save this file inside:

```bash
tools/ssh-ec2-terraform.md
```

And you're ready to move on to infrastructure automation using Ansible.
