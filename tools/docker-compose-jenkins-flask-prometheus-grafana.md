# 🛠️ `tools/docker-compose-jenkins-flask-prometheus-grafana.md`

## 🧱 Goal:
Set up a full CI/CD + monitoring stack using Docker Compose with:
- Jenkins (CI/CD engine)
- Flask App (demo application)
- Prometheus (scrapes metrics from Jenkins & Flask)
- Grafana (dashboards for observability)

---

## 📂 Project Structure:
```
docker-monitoring/
├── docker-compose.yml
├── prometheus.yml
├── flask/
│   ├── Dockerfile
│   └── app.py
```

---

## 📄 1. `docker-compose.yml`
```yaml
version: '3.8'

services:
  flask-app:
    build: ./flask
    ports:
      - "5000:5000"

  jenkins:
    image: jenkins/jenkins:lts
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home

  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"

volumes:
  jenkins_home:
```

---

## 📄 2. `prometheus.yml`
```yaml
global:
  scrape_interval: 5s

scrape_configs:
  - job_name: 'flask-app'
    static_configs:
      - targets: ['flask-app:5000']

  - job_name: 'jenkins'
    metrics_path: '/prometheus'
    static_configs:
      - targets: ['jenkins:8080']

  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

---

## 🐍 3. `flask/app.py`
```python
from flask import Flask
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app)

@app.route('/')
def home():
    return "Flask app running with monitoring!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

---

## 🐳 4. `flask/Dockerfile`
```dockerfile
FROM python:3.9
WORKDIR /app
COPY . .
RUN pip install flask prometheus-flask-exporter
CMD ["python", "app.py"]
```

---

## 🚀 5. Run the Full Stack
```bash
docker-compose up -d --build
```

This will start Flask, Jenkins, Prometheus, and Grafana in detached mode.

---

## 🧪 6. Verify All Services
| Tool       | URL                             | Expected Output |
|------------|----------------------------------|------------------|
| Flask      | http://localhost:5000            | Text response    |
| Flask /metrics | http://localhost:5000/metrics | Prometheus data |
| Jenkins    | http://localhost:8080            | Jenkins UI       |
| Prometheus | http://localhost:9090/targets    | Scrape targets   |
| Grafana    | http://localhost:3000            | Login screen     |

---

## ⚠️ Common Errors & How We Fixed Them

### ❌ `ModuleNotFoundError: No module named 'prometheus_flask_exporter'`
**Why:** This happened when `Dockerfile` was missing required dependency.

**Fix:** Ensure `Dockerfile` contains:
```dockerfile
RUN pip install flask prometheus-flask-exporter
```
Then rebuild Flask:
```bash
docker-compose up -d --build flask-app
```

---

### ❌ Prometheus showing `jenkins:8080` as DOWN (HTTP 404)
**Why:** Jenkins requires a plugin for exposing Prometheus metrics and authentication blocks unauthenticated scraping.

**Fix**:
- Go to Jenkins → Manage Jenkins → Plugin Manager → Install **Prometheus Metrics Plugin**
- Then navigate to **Manage Jenkins → Configure Global Security**
  - Disable CSRF or allow anonymous read for metrics (as needed)

Also ensure prometheus.yml:
```yaml
- job_name: 'jenkins'
  metrics_path: '/prometheus'
  static_configs:
    - targets: ['jenkins:8080']
```
Then restart:
```bash
docker-compose down && docker-compose up -d --build
```

---

### ❌ Jenkins dashboard in Grafana shows all 0s
**Why:** Prometheus plugin needs active Jenkins builds to show metrics.

**Fix:**
1. Go to Jenkins → Create **Freestyle Project**
2. Add a **Build Step** → "Execute shell"
3. Type:
```bash
echo "hello from Jenkins"
```
4. Save → Click **Build Now**
5. Refresh Grafana dashboard after ~15 seconds

---

## 📊 7. Add Prometheus as Grafana Data Source
1. Go to Grafana: http://localhost:3000 → Login (admin/admin)
2. Left sidebar → ⚙️ **Settings** → **Data Sources**
3. Click **Add data source** → Choose **Prometheus**
4. Set URL: `http://prometheus:9090`
5. Click **Save & Test** → ✅ Success message appears

---

## 📈 8. Import Jenkins Dashboard in Grafana
1. In Grafana: click ➕ → **Import**
2. Paste Dashboard ID: `9964`
3. Click **Load** → Select Prometheus as data source → Import
4. Jenkins metrics like executor usage, build rate, job queue will appear

---

## ✅ Final Functional Check
| Service     | Port | Verified Output                             |
|-------------|------|---------------------------------------------|
| Flask       | 5000 | Shows UI and metrics                        |
| Jenkins     | 8080 | UI running, builds trigger metrics          |
| Prometheus  | 9090 | Shows all 3 scrape targets as UP            |
| Grafana     | 3000 | Jenkins dashboard with real-time updates    |

---

## ✅ Summary
You now have a complete DevOps monitoring setup with:
- Jenkins (CI/CD)
- Flask App (test app)
- Prometheus (scrapes Jenkins + Flask metrics)
- Grafana (visual dashboards)

📌 All errors fixed, metrics connected, dashboards live.

