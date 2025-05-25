# 🚀 Docker Monitoring Stack with Grafana + Loki + Promtail + Prometheus + cAdvisor

> This is a **complete real-world setup** with all steps, problems, debugging, YAMLs, and fixes documented like a true engineer's journey. No copy-paste magic — everything I did, failed, fixed, and finally made work.

---

## 🔧 Tools Used

* **Grafana**: For dashboards & visualization
* **Loki**: Log aggregation backend
* **Promtail**: Collects and ships logs to Loki
* **Prometheus**: Scrapes metrics
* **cAdvisor**: Exposes container metrics

---

## 🗂️ Final Folder Structure

```bash
├── docker-compose.yml
├── loki-config/
│   └── loki-config.yaml
├── loki-data/
│   ├── index/
│   ├── chunks/
│   ├── cache/
│   └── wal/
├── prometheus.yml
├── promtail-config.yaml
```

---

## 🏗 Step-by-Step Setup

### ✅ Step 1: Folder Creation

```bash
mkdir -p loki-config loki-data/index loki-data/chunks loki-data/cache loki-data/wal
```

We must create these ahead of time or Loki throws file-not-found or permission errors.

---

### 📝 Step 2: Config Files

#### `loki-config/loki-config.yaml`

```yaml
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9095

ingester:
  lifecycler:
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
  wal:
    enabled: true
    dir: /loki/wal

schema_config:
  configs:
    - from: 2023-01-01
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb_shipper:
    active_index_directory: /loki/index
    cache_location: /loki/cache
    shared_store: filesystem

  filesystem:
    directory: /loki/chunks

compactor:
  working_directory: /loki/compactor

limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h

chunk_store_config:
  max_look_back_period: 168h

table_manager:
  retention_deletes_enabled: true
  retention_period: 168h

```

✅ Removed fields like `final_sleep` and `compactor` that caused version errors.

---

#### `promtail-config.yaml`

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
          __path__: /var/log/*log
```

---

#### `prometheus.yml`

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
```

---

### 🐳 Step 3: Docker Compose

```yaml
version: '3.8'
services:
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    restart: unless-stopped

  prometheus:
    image: prom/prometheus
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    restart: unless-stopped

  grafana:
    image: grafana/grafana
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana-storage:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - loki
    restart: unless-stopped

  loki:
    image: grafana/loki:2.9.3
    container_name: loki
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/loki-config.yaml
    volumes:
      - ./loki-config/loki-config.yaml:/etc/loki/loki-config.yaml
      - ./loki-data:/loki
    user: 10001:10001
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

volumes:
  grafana-storage:
```

---

## 🧨 Real Problems & Fixes

### ❌ Loki Config Was a Directory

**Fix**: Mount the file directly, not the folder.

### ❌ WAL/Index Permission Errors

**Fix**: Either

```bash
sudo chown -R 10001:10001 loki-data/
```

Or remove the `user` line in the compose.

### ❌ YAML Parsing Errors (like `final_sleep`, `compactor`)

**Fix**: These keys are deprecated. Remove them.

### ❌ Ingester not ready

```bash
curl http://localhost:3100/ready
```

Wait \~20s. Then it shows:

```
ready
```

---

## 📈 Final Test: Grafana Logs View

Go to: [http://localhost:3000](http://localhost:3000)

### Steps:

1. Login: `admin` / `admin`
2. Go to **Explore**
3. Choose **Loki** as source
4. Query:

```logql
{job="docker"}
```

5. 🎉 See live logs

---

## 🧠 Final Notes

* **Don't blindly follow old tutorials**. Loki config format has changed.
* Always check `docker logs loki`
* Mount specific config files, not folders
* Pre-create WAL & index folders to avoid errors
* Permissions errors? Try without UID first

---

## 🎯 Result

✅ Grafana UI working with Loki logs
✅ Promtail shipping logs correctly
✅ Prometheus scraping metrics
✅ cAdvisor exposing Docker metrics

**All working from scratch. No shortcuts. Just real engineering.**
