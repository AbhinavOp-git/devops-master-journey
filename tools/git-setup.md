# Git Setup (WSL) 🛠️

---

## ✅ Step 1: Configure Git identity

These commands set your Git username and email globally:

```bash
git config --global user.name "AbhinavOp-git"
git config --global user.email "rajabhinav1001@gmail.com"

You can verify the configuration with:

git config --global --list


## ✅ Step 2: Setup Personal Access Token (PAT)

To avoid entering your GitHub username and password every time:

```bash
git config --global credential.helper store
```

Then:

- Go to: https://github.com/settings/tokens  
- Click **"Generate new token (classic)"**  
- Set **repo** permission ✅  
- Set expiration as needed  
- **Copy the token immediately**

When pushing for the first time:

- **Username** → your GitHub username  
- **Password** → paste the PAT (Personal Access Token)

The token will be saved in:

```bash
~/.git-credentials
```



## ✅ Step 3: Create Folder Structure

Use the following command to create your DevOps learning folders:

```bash
mkdir -p ~/devops-journey/{projects,scripts,terraform,ansible,monitoring,tools}
cd ~/devops-journey

This becomes your base workspace for:

DevOps tools
Notes
Projects
Scripts
AWS preparation


## ✅ Step 4: Clone GitHub Repository

```bash
cd ~/devops-journey/projects

# Clone your main DevOps repo
git clone https://github.com/AbhinavOp-git/devops-master-journey.git

# (Optional) Clone test repo
git clone https://github.com/AbhinavOp-git/devops-test-repo.git

# Go into your project folder
cd devops-master-journey


---

✅ Git setup is now complete. You're fully connected to GitHub and ready to start your DevOps journey! 🚀

🧑‍💻 Author: Abhinav Raj (@AbhinavOp-git)  
📅 Last Updated: 19 April 2025
