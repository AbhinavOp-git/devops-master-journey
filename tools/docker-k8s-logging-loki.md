# Docker Centralized Logging with Loki

---

## 🎯 Goal

Get real-time, centralized log monitoring from Docker containers (like Flask and Jenkins) using **Grafana Loki** and **Promtail**, visualized inside Grafana — all running via Docker Compose.

---

## 🛠️ Setup: Initial Monitoring Stack (Before Loki)

We already had Prometheus, Grafana, and cAdvisor running in `docker-monitoring/`.

```yml
services:
  cadvisor:
  prometheus:
  grafana:
```

Everything was working great for metrics, but we had **no log visibility**. That’s what we’re solving now.

---

## 🐾 Step 1: Extending Docker Compose with Loki + Promtail

We edited `docker-compose.yml` and added these two new services:

```yaml
  loki:
    image: grafana/loki:2.9.3
    container_name: loki
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml
    restart: unless-stopped

  promtail:
    image: grafana/promtail:2.9.3
    container_name: promtail
    volumes:
      - /var/log:/var/log
      - ./promtail-config.yaml:/etc/promtail/promtail-config.yaml
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
    command: -config.file=/etc/promtail/promtail-config.yaml
    depends_on:
      - loki
    restart: unless-stopped
```

---

## 📄 Step 2: Creating Promtail Config File

Created `promtail-config.yaml` in the same folder:

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: docker
    static_configs:
      - targets:
          - localhost
        labels:
          job: docker
          __path__: /var/lib/docker/containers/*/*.log
```

📌 **Problem Faced**: Had to tweak volume paths to make sure logs from all containers (Jenkins, Flask) were readable.

✅ **Solution**: Made sure `/var/lib/docker/containers` was mounted read-only in Promtail.

---

## 🚀 Step 3: Launch the Full Stack

```bash
docker-compose up -d
```

Checked:

```bash
docker ps
```

All 5 containers running: `grafana`, `prometheus`, `cadvisor`, `loki`, and `promtail` ✅

---

## 🖥️ Step 4: Add Loki to Grafana

1. Open Grafana at `http://localhost:3000`
2. Go to **⚙️ → Data Sources → Add Data Source**
3. Choose **Loki**
4. Set URL to:

   ```
   http://loki:3100
   ```
5. Click **Save & Test**

✅ Got green check: "Data source is working"

---

## 🔍 Step 5: Explore Live Logs (via Explore Tab)

Used these LogQL queries:

```logql
{job="docker"}                          # All logs
{container_name=~".*flask.*"}           # Flask app logs
{container_name=~".*jenkins.*"}         # Jenkins logs
```

📌 **Issue Faced**: At first we didn’t see logs
✅ **Fix**: Had to switch "Format" to **Logs** instead of default "Time Series"

---

## 📊 Step 6: Building a Custom Dashboard

1. Click **+ → Dashboard → Add Visualization**
2. Chose **Loki** as data source
3. Pasted the same queries and switched format to **Logs**
4. Named each panel:

   * Docker Logs
   * Flask Logs
   * Jenkins Logs

🧠 **Small gotcha**: Format dropdown was hidden — had to scroll down to change it to Logs, else it kept showing "No data"

---

## 💾 Step 7: Save the Dashboard

Clicked **Save dashboard** → Named it:

```
Loki Logs Dashboard
```

✅ Now have real-time logging fully integrated with our Docker setup.

---

## 🧠 Final Notes:

* Loki is like Prometheus but for logs
* Promtail is the shipper, like Fluentd or Filebeat
* This setup made debugging containers finally visible

🔗 All files pushed to:
`projects/docker-monitoring/` and `tools/docker-k8s-logging-loki.md`

DevOps observability level: unlocked 🔥
