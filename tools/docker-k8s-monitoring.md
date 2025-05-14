# Docker + Kubernetes Monitoring Setup (Real-World Journey)

---

## 🎯 Objective

Set up full real-time monitoring of Docker containers and Kubernetes cluster using Prometheus, cAdvisor, and Grafana — with working dashboards for CPU, memory, network, and container info.

---

## 🐳 Step 1: Added cAdvisor to Docker Compose

### 🛠️ Bash Commands Used:

```bash
cd ~/devops-master-journey/projects
mkdir docker-monitoring
cd docker-monitoring
touch docker-compose.yml
```

### 🧱 Contents of `docker-compose.yml`:

```yaml
version: '3'
services:
  cadvisor:
    image: gcr.io/google-containers/cadvisor:latest
    container_name: cadvisor
    ports:
      - "8080:8080"
    volumes:
      - "/:/rootfs:ro"
      - "/var/run:/var/run:ro"
      - "/sys:/sys:ro"
      - "/var/lib/docker/:/var/lib/docker:ro"
```

### 🚀 Start the Service:

```bash
docker-compose up -d
```

### ❌ Issue Faced:

* cAdvisor loaded but metrics weren’t appearing in Prometheus.
* Forgot to mount required host paths.

### ✅ Fix:

* Re-added volume mounts for proper access.
* Restarted the service:

```bash
docker-compose down
docker-compose up -d
```

---

## 📊 Step 2: Set Up Prometheus

### 🛠️ File Structure:

```bash
mkdir prometheus
touch prometheus/prometheus.yml
```

### ✍️ prometheus.yml:

```yaml
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
```

### 🐋 Docker Compose Update:

```yaml
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
```

### ▶️ Start All:

```bash
docker-compose up -d
```

---

## 📡 Step 3: Verified Prometheus Target

### 📍 Go to:

```
http://localhost:9090
```

### ✅ Check:

* Go to **Status → Targets**
* It said: `UP` (Success)

---

## 📈 Step 4: Install and Configure Grafana

### 🛠️ Add Grafana Service in `docker-compose.yml`:

```yaml
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
```

### ⏳ Start:

```bash
docker-compose up -d
```

### 🧠 Issue Faced:

* On first login, default user/pass = `admin` / `admin`
* Prompted to change password

### ✅ Data Source Setup:

* Open `localhost:3000`
* Add Prometheus Data Source:

  * Name: Prometheus
  * URL: `http://prometheus:9090`

---

## 🧩 Step 5: Created Custom Dashboard (Manual)

### ➕ Add Dashboard:

* Grafana → “+” → **Dashboard** → “Add new panel”

### 📥 Query 1 (CPU Usage):

```
rate(container_cpu_usage_seconds_total[1m])
```

### 📥 Query 2 (RAM Usage):

```
container_memory_usage_bytes
```

### 📋 Filters:

* Label filter by `job="cadvisor"`

---

## 🐛 Problems Faced During Grafana:

1. **No Data Appearing:**

   * Misconfigured Data Source name.
   * Solved by deleting and re-adding Prometheus correctly.

2. **Dashboard not working:**

   * Tried importing a premade one that broke.
   * Fixed by manually creating fresh panels with working queries.

---

## 🧼 Bonus: Clean RAM Metric Panel

Added a third panel:

```
container_memory_working_set_bytes
```

Label: pod or container-specific metrics.

---

## 🔄 Commands Used Throughout:

```bash
docker-compose down
docker-compose up -d
curl localhost:8080
curl localhost:9090
```

---

## 🧠 Key Learnings

* Mount paths are **critical** for cAdvisor
* Prometheus `targets` must be exact and reachable
* Grafana dashboards may require manual setup when JSON imports fail
* Real-world debugging is part of DevOps. Break → Learn → Fix ✅

---

Project and this log pushed to `devops-master-journey/tools` folder.
