# 🛠️ Jenkins + Flask CI/CD Using Docker Compose 

This hands-on project sets up a complete CI/CD pipeline using Jenkins, Docker Compose, and a Flask web app — following real-world DevOps practices. It's designed to showcase practical DevOps skills like infrastructure setup, pipeline automation, and containerized deployment in a clear, developer-friendly way.

---

## 📁 Recommended Project Folder Structure
**Location:** `~/devops-journey/workspace/devops-master-journey`

```
├── docker-compose.yml                # The main orchestration file for Docker services
├── jenkins-hello/                    # Your Flask application (cloned from GitHub)
├── tools/                            # Setup and documentation files (like this one)
├── scripts/, notes/                  # Supporting files for practice/reference
└── README.md                         # Project summary and daily status updates
```

---

## 🔧 Step 1: Write a Docker Compose File
Create a `docker-compose.yml` in your root project folder. This sets up two services:

1. **Jenkins** — our CI/CD server
2. **Flask App** — a sample web app that we'll build and deploy

```yaml
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins-devops
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    user: root

  flask-app:
    build:
      context: ./jenkins-hello
      dockerfile: Dockerfile
    container_name: flask-app
    ports:
      - "8000:8000"
    depends_on:
      - jenkins

volumes:
  jenkins_home:
```

### 💡 Why this setup matters:
- We expose **8080** for the Jenkins dashboard and **8000** for Flask web access.
- `/var/run/docker.sock` lets Jenkins run Docker commands from inside its container.
- Using `user: root` ensures Jenkins can install packages and run privileged commands.
- Named volume `jenkins_home` ensures Jenkins keeps data even after the container is removed.

---

## 🧪 Step 2: Start and Manage the Services
Navigate to your project directory:
```bash
cd ~/devops-journey/workspace/devops-master-journey
```
To bring up Jenkins and Flask together:
```bash
docker compose up -d
```
To stop the services cleanly:
```bash
docker compose down
```
To completely reset (including volume/data):
```bash
docker compose down -v
```

---

## 🔐 Step 3: Unlock Jenkins and Set Up Admin
After running the container, Jenkins will ask for an unlock password. Get it via:
```bash
docker exec -it jenkins-devops cat /var/jenkins_home/secrets/initialAdminPassword
```
Then go to:
```
http://localhost:8080
```
- Paste the unlock password
- Install **Suggested Plugins**
- Create your **admin username and password**

Now you're inside Jenkins!

---

## 🧱 Step 4: Create a Jenkins Freestyle Job

In Jenkins dashboard:
- Click **“New Item” → Freestyle Project → Name: flask-ci-pipeline → OK**

Under "Build Steps" → Add "Execute shell" and paste:
```bash
echo "🚀 Starting Flask CI Pipeline"

rm -rf jenkins-hello

git clone https://github.com/AbhinavOp-git/jenkins-hello.git
cd jenkins-hello

docker build -t flask-jenkins-demo .

docker rm -f flask-ci || true
docker run -d --name flask-ci -p 8000:8000 flask-jenkins-demo

curl --fail http://localhost:8000 || echo "App failed to respond"

echo "✅ CI Pipeline complete"
```

### 🧠 What this script does:
- Removes old clone (if exists)
- Clones your latest GitHub repo
- Builds Docker image `flask-jenkins-demo`
- Removes any container with name `flask-ci`
- Runs the Flask app inside Docker and maps it to port 8000
- Tests the app with `curl`

✅ Save the job and click **“Build Now”**

---

## ❌ Troubleshooting — Real Errors and Fixes

### 🐳 Docker CLI not found in Jenkins container:
```bash
docker exec -it jenkins-devops bash
apt update && apt install -y docker.io
```

### ⚠️ Port 8000 already in use:
```bash
docker ps -a | grep 8000
docker rm -f flask-app
```

### 🔐 Jenkins asks for password every time:
Ensure you used a named volume:
```yaml
volumes:
  - jenkins_home:/var/jenkins_home
```

### 🔑 Invalid login or user folder issue:
```bash
docker exec -it jenkins-devops bash
rm -rf /var/jenkins_home/users/*
exit
docker restart jenkins-devops
```

### ❓ Setup wizard doesn't appear / no password:
```bash
docker compose down -v
docker compose up -d
```
This resets Jenkins to first-time setup.

---

## 🧪 How to Check If Flask App Is Working

### 1. Browser (Recommended):
Open: [http://localhost:8000](http://localhost:8000)

### 2. Docker logs:
```bash
docker logs flask-app
```

### 3. Curl test:
```bash
curl http://localhost:8000
```
You should see:
```text
Hello from Flask inside Docker + Jenkins 🚀
```

---

## ✅ Final Service Checklist
| Component    | Status       | Port | Notes                         |
|--------------|--------------|------|-------------------------------|
| Jenkins      | ✅ Running    | 8080 | Persistent volume used        |
| Flask App    | ✅ Deployed   | 8000 | From GitHub + Docker build    |
| Jenkins Job  | ✅ Successful |  —   | Pull → Build → Deploy → Test |

---

## 🧾 What You Learned
- Docker Compose orchestration for multiple containers
- Jenkins basic setup and job creation
- Volume management for persistent Jenkins configuration
- Running Docker commands from inside Jenkins
- Troubleshooting real-world CI/CD issues

---

## 🧹 End-of-Day Cleanup
Stop all containers:
```bash
docker compose down
```
To start fresh next time:
```bash
docker compose up -d
```

---

## 🔜 What's Next
- Integrate **GitHub webhooks** to trigger jobs on every push
- Add **Prometheus + Grafana** for container monitoring
- Move from freestyle to **Jenkinsfile (pipeline as code)**
- Learn to export and reuse Jenkins jobs for different projects

Stay curious. Stay consistent. And you'll not only learn DevOps — you'll **live it like a pro**. 💪

