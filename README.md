# Platform Infrastructure

This repository provides the local infrastructure stack required for running all services (API, crawler, processor, notification, etc.) in a reproducible environment.
It includes the following components:

* MySQL – Primary application database
* Prometheus / Grafana – Metrics collection and visualization
* Loki / Promtail – Centralized log collection
* Tempo – Distributed tracing
* OpenTelemetry Collector – Unified telemetry gateway
* Docker Compose & Makefile – Local orchestration and automation

---

## 🧱 Prerequisites

Before starting, ensure you have:
* Docker Engine installed
* Docker Compose plugin (docker compose command available)
* Git
* (Optional) `make` command-line tool for convenience

If docker compose is not recognized, install the plugin:
```bash
sudo apt-get update  
sudo apt-get install docker-compose-plugin
```

Or install the full Docker Engine stack (recommended):  
```bash
sudo apt-get remove docker docker-engine docker.io containerd runc  
sudo apt-get install ca-certificates curl gnupg lsb-release -y  
sudo mkdir -p /etc/apt/keyrings  
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg  
echo \  
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \  
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \  
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null  
sudo apt-get update  
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```
---

## ⚙️ Setup
1. Clone this repository
    ```bash
    git clone https://github.com/your-org/platform-infra.git
    cd platform-infra
    ```
2. Create your environment file
    ```bash
   cp .env.example .env
    ``` 
3. Start all infrastructure
    ```bash
    make up
    ``` 
   or, if you don’t have make:
    ```bash
    docker compose up -d
    ``` 
4. Check running containers
    ```bash
    make ps
    ``` 

---

## 🧩 Access Points
| Service                         | URL                                            | Default Credentials         |
| ------------------------------- | ---------------------------------------------- | --------------------------- |
| Grafana                         | [http://localhost:3000](http://localhost:3000) | `admin / change_me_grafana` |
| Prometheus                      | [http://localhost:9090](http://localhost:9090) | —                           |
| MySQL                           | `127.0.0.1:3306`                               | `root / change_me_root`     |
| Tempo                           | [http://localhost:3200](http://localhost:3200) | —                           |
| Loki Logs (via Grafana Explore) | —                                              | —                           |
All telemetry data (metrics, traces, logs) flows through OpenTelemetry Collector, which exports to Prometheus, Tempo, and Loki.

---

## 🧠 Connecting Your Applications
Applications (e.g., paper-api, paper-crawler, paper-processor) should:
* Use MySQL host: mysql, port 3306
* Export OTLP telemetry to otel-collector:
    ```
    OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4318
    OTEL_RESOURCE_ATTRIBUTES=service.name=your-service
    ```
Traces → Tempo
Metrics → Prometheus
Logs → Loki

All data becomes visible in Grafana.

---

## 🧪 Useful Commands
| Command          | Description                                                      |
| ---------------- | ---------------------------------------------------------------- |
| `make up`        | Start all containers in detached mode                            |
| `make down`      | Stop and remove containers                                       |
| `make logs`      | Follow logs for all services                                     |
| `make ps`        | Show container status                                            |
| `make mysql-cli` | Open a MySQL shell as root                                       |
| `make wipe`      | Remove all containers and persistent volumes *(⚠️ irreversible)* |

---

## 🔐 Secrets & Environment
* Local secrets are stored in .env (never commit it).
* Use .env.example as a public reference.
* In CI (GitHub Actions), define equivalent secrets under repository settings.
* Applications should only read secrets from environment variables, never hardcode them.

## 🚀 Deployment to Ubuntu
1. Install Docker:
    ```bash
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
    ```
   Log out and back in.
2. Copy this repository and .env file to the Ubuntu host.
3. Run:
    ```bash
    make up
    ```
4. Verify:
    ```bash
    docker compose ps
    ```

Your full local infrastructure should now run identically on Ubuntu.