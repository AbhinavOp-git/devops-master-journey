# 📘 Kubernetes Deployment Using Minikube (WSL2) — Solved Errors and Deployed Successfully

This document captures everything I did to set up a Kubernetes cluster locally using Minikube on WSL2, deploy a Dockerized Flask app, face multiple real-world errors, and solve them one by one like a real DevOps engineer.

---

## 🧱 Installing Kubernetes Tools on WSL2 (With Fixes)

### 1. Installing `kubectl` — Faced Version Fetch Error and Solved It

Initially tried:

```bash
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

❌ Error:

```
curl: Failed to extract a sensible file name from the URL to use for storage
```

✅ Solution:

```bash
KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client
```

Worked fine after that. Output showed the correct version.

### 2. Installing `minikube`

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version
```

✅ Installed successfully.

### 3. Starting Minikube with Docker Driver

```bash
minikube start --driver=docker
kubectl get nodes
```

✅ Output showed node as Ready.

---

## 📂 Setting Up Project Structure

```bash
cd ~/devops-master-journey
mkdir -p projects/kubernetes-flask-deploy
cd projects/kubernetes-flask-deploy
```

---

## 🐍 Flask App — Created and Ready

```python
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "🚀 Hello from Kubernetes!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

Saved as `app.py`

---

## 🐳 Dockerfile — Image Built Successfully

```Dockerfile
FROM python:3
RUN pip install flask
COPY app.py /app.py
CMD ["python", "/app.py"]
```

Ran:

```bash
eval $(minikube docker-env)
docker build -t flask-k8s-app .
```

✅ Image built inside Minikube Docker context.

---

## 📄 Kubernetes Manifests — Created and Applied

### deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
      - name: flask-container
        image: flask-k8s-app
        imagePullPolicy: Never
        ports:
        - containerPort: 5000
```

### service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: flask-service
spec:
  type: NodePort
  selector:
    app: flask-app
  ports:
    - port: 5000
      targetPort: 5000
      nodePort: 30007
```

Applied:

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

✅ Pods and service were created successfully.

---

## ❌ Faced Issue — Site Not Opening in Browser

Tried:

```
http://192.168.49.2:30007
```

❌ Browser returned: `Connection Timed Out`

Checked everything — pod was running, logs were clean, service showed NodePort.

---

## 🧠 Root Cause — WSL2 Network Isolation

WSL2 and Windows use different networks. Minikube’s NodePort traffic can’t reach the browser directly in WSL2.

---

## ✅ Fix — Port Forwarding (Worked Instantly)

Ran:

```bash
kubectl get pods
kubectl port-forward pod/<your-pod-name> 5000:5000
```

Then opened:

```
http://localhost:5000
```

✅ It worked! Flask app showed "Hello from Kubernetes!"

---

## 📌 Final Tips

* Don’t rely on NodePort inside WSL2
* Use `kubectl port-forward` for local dev
* Use LoadBalancer or Ingress in real cloud environments

---

## 📁 Final File Tree

```
projects/kubernetes-flask-deploy/
├── app.py
├── Dockerfile
├── deployment.yaml
├── service.yaml
```

✅ I installed everything, solved version errors, handled networking issues, and successfully deployed a containerized Flask app on Kubernetes with full understanding.

DevOps is not about knowing it all upfront — it’s about debugging, solving, and documenting the journey. Mission accomplished 💯
