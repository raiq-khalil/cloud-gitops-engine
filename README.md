# Cloud GitOps Engine

[![CI & GitOps Deployment](https://github.com/raiq-khalil/cloud-gitops-engine/actions/workflows/ci.yml/badge.svg)](https://github.com/raiq-khalil/cloud-gitops-engine/actions/workflows/ci.yml)
[![Terraform Lint & Validation](https://github.com/raiq-khalil/cloud-gitops-engine/actions/workflows/terraform-ci.yml/badge.svg)](https://github.com/raiq-khalil/cloud-gitops-engine/actions/workflows/terraform-ci.yml)
[![Container Registry](https://img.shields.io/badge/GHCR-Docker%20Image-blue?logo=docker)](https://github.com/raiq-khalil/cloud-gitops-engine/pkgs/container/cloud-gitops-engine)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An enterprise-grade, GitOps-automated cloud native backend running on AWS. The platform couples a hardened FastAPI microservice with automated infrastructure as code (IaC) written in modular Terraform, orchestrated via GitHub Actions and deployed to an isolated, multi-tier AWS ECS Fargate environment.

---

## 🏛️ System Architecture

```text
                          Internet Traffic (HTTP:80)
                                      │
                                      ▼
                      ┌───────────────────────────────┐
                      │    Internet Gateway (IGW)     │
                      └───────────────┬───────────────┘
                                      │
        ┌─────────────────────────────┼─────────────────────────────┐
        │ AWS VPC (10.10.0.0/16)      │                             │
        │                             ▼                             │
        │   ┌───────────────────────────────────────────────────┐   │
        │   │ Public Subnets (us-east-1a / us-east-1b)          │   │
        │   │                                                   │   │
        │   │   ┌───────────────────────────────────────────┐   │   │
        │   │   │     Application Load Balancer (ALB)       │   │   │
        │   │   │         [Security Group: Ingress 80]      │   │   │
        │   │   └─────────────────────┬─────────────────────┘   │   │
        │   │                         │                         │   │
        │   │   ┌───────────────────┐ │                         │   │
        │   │   │    NAT Gateway    │ │                         │   │
        │   │   │  (Elastic IP EIP) │ │                         │   │
        │   │   └─────────▲─────────┘ │                         │   │
        │   └─────────────┼───────────┼─────────────────────────┘   │
        │                 │           │ Target Group                │
        │                 │           │ Health Check: /health       │
        │                 │           ▼ (Port 8000)                 │
        │   ┌─────────────┼─────────────────────────────────────┐   │
        │   │ Private Subnet (us-east-1a)                       │   │
        │   │             │                                     │   │
        │   │   ┌─────────┴────────┐   ┌────────────────────┐   │   │
        │   │   │  AWS ECS Fargate │   │ CloudWatch Logs    │   │   │
        │   │   │  Task Definition │──▶│ /ecs/cloud-gitops  │   │   │
        │   │   │  [FastAPI :8000] │   └────────────────────┘   │   │
        │   │   │  [SG: Only ALB]  │                            │   │
        │   │   └──────────────────┘                            │   │
        │   └───────────────────────────────────────────────────┘   │
        └───────────────────────────────────────────────────────────┘
```
---

## 🔒 Security Posture & Zero-Trust Design

* **Network Isolation:** Workloads run strictly inside private subnets without public IPv4 addresses, preventing direct inbound internet access.
* **Controlled Egress:** Outbound container traffic (dependencies, image registries, system updates) routes strictly through a managed NAT Gateway and Elastic IP.
* **Least-Privilege Security Groups:** Application containers accept ingress exclusively from the ALB Security Group on port 8000; external traffic cannot hit compute instances directly.
* **Container Hardening:** Built on an unprivileged non-root user (`appuser:10001`), utilizing a multi-stage distroless-style build to eliminate shell utilities, package managers, and root escape vectors.
* **IAM Least Privilege:** Fargate execution tasks operate with minimal execution roles restricted solely to CloudWatch log creation and telemetry streaming.

---

## 🔄 Dual GitOps Pipelines

The repository maintains strict separation of concerns between application code delivery and foundational cloud infrastructure via two automated GitHub Actions workflows:

### 1. Application CI/CD Pipeline (`.github/workflows/ci.yml`)
* **Test & Lint:** Executes unit test suites on Python 3.11 with `pytest` covering API routes and health endpoints.
* **Build & Publish:** Triggers Docker Buildx to generate multi-architecture container layers, tagging releases with the immutable Git commit SHA and publishing to the GitHub Container Registry (`ghcr.io`).
* **GitOps Deploy:** Injects the newly minted image SHA directly into the ECS task definition manifest (`task-definition.json`) to trigger rolling, zero-downtime service deployments.

### 2. Infrastructure as Code Validation Gate (`.github/workflows/terraform-ci.yml`)
* **Style Enforcement:** Runs `terraform fmt -check -recursive` across all modules.
* **Provider Verification:** Initializes provider plugins (`hashicorp/aws ~> 5.0`) with `terraform init -backend=false`.
* **Static Synthesis:** Runs `terraform validate` to catch misconfigurations, broken references, or invalid typing before code merges into `main`.

---

## 📁 Repository Structure

```text
cloud-gitops-engine/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── terraform-ci.yml
│       └── deploy/
│           └── task-definition.json
├── app/
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── src/
│   │   ├── __init__.py
│   │   └── main.py
│   └── tests/
│       ├── __init__.py
│       └── test_main.py
├── terraform/
│   ├── environments/
│   │   └── dev/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   └── modules/
│       ├── vpc/
│       ├── security/
│       ├── alb/
│       └── compute/
├── .gitignore
└── README.md
```

---

## 🚀 Local Development & Execution

### 1. Run the Microservice Locally
```bash
# Set up virtual environment
python3 -m venv .venv
source .venv/bin/activate
pip install -r app/requirements.txt

# Run test suite
pytest -v app/tests/test_main.py

# Launch development server
uvicorn app.src.main:app --host 0.0.0.0 --port 8000 --reload

### 2. Run Container with Docker
```bash
# Build the container
docker build -t cloud-gitops-engine:local -f app/Dockerfile ./app

# Run locally as an unprivileged user
docker run -p 8000:8000 --rm cloud-gitops-engine:local

# Test health check probe
curl http://localhost:8000/health

### 3. Validate Terraform Configurations
cd terraform/environments/dev
terraform fmt -check -recursive ../../
terraform init -backend=false
terraform validate

Route,Method,Access,Description
/,GET,Public (via ALB),Welcome diagnostic payload
/health,GET,Public (via ALB),"Target group health probe (status, environment, version)"
/docs,GET,Public (via ALB),Native Swagger UI OpenAPI documentation

---

### Next Step
Save the file (`Ctrl + S`), then push it to GitHub:

```bash
git add README.md
git commit -m "docs: complete enterprise architectural README and system documentation"
git push origin main