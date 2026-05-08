# devops-cicd-observability-platform

## 🚀 End-to-End DevOps CI/CD Platform on AWS

This repository combines the application pipeline and the infrastructure deployment into a single project. It includes:

- A Node.js application with Docker build support
- A Jenkins CI/CD pipeline definition
- Terraform infrastructure for AWS EC2 provisioning
- Monitoring with Prometheus and Grafana
- Automated Jenkins installation on EC2 via user-data

---

## 🏗️ Architecture

```
GitHub → Jenkins → Docker Build → Docker Hub → EC2 Deployment → User Access
```

### Components

- AWS EC2 instance provisioned by Terraform
- Jenkins installed via bootstrap scripts
- Docker and Maven configured on the Jenkins host
- Prometheus and Grafana for monitoring
- Node.js application packaged with Docker

---

## 📁 Recommended Project Structure

```
app/
  ├── index.js
  ├── package.json
  ├── package-lock.json
  ├── Dockerfile
  └── public/
      └── index.html

infrastructure/
  ├── main.tf
  ├── variables.tf
  ├── outputs.tf
  ├── terraform.tfvars
  ├── userdata.sh
  └── .terraform.lock.hcl

jenkins/
  └── Jenkinsfile

README.md
.gitignore
LICENSE
```

> If you haven’t yet moved the files, put the application assets under `app/`, and the Terraform files under `infrastructure/`.

---

## 🚀 Features

- Automated infrastructure provisioning with Terraform
- Jenkins CI/CD pipeline for building, testing, and deploying Docker images
- Docker containerization for the Node.js app
- Prometheus monitoring and Grafana dashboards
- Secure AWS setup with IMDSv2 and SSH restrictions

---

## 🔧 Setup & Deployment

### 1. Clone repository

```bash
git clone <your-repo-url>
cd devops-cicd-observability-platform
```

### 2. Provision infrastructure

```bash
cd infrastructure
terraform init
terraform apply
```

This provisions:
- EC2 instance
- Jenkins server
- Docker runtime
- Monitoring stack

### 3. Access Jenkins

```text
http://<EC2_PUBLIC_IP>:8080
```

Retrieve Jenkins admin password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### 4. Build and test the app

From the application directory:

```bash
cd app
docker build -t basic-webapp .
docker run -p 3000:3000 basic-webapp
```

### 5. Health check

```bash
curl http://localhost:3000/health
```

Expected response:

```json
{ "status": "UP" }
```

---

## 🌐 Access URLs

- Jenkins: `http://<public-ip>:8080`
- Prometheus: `http://<public-ip>:9090`
- Grafana: `http://<public-ip>:3000`
- Application: `http://<public-ip>:3000`

---

## 🔐 Security Best Practices

- IMDSv2 enabled for EC2
- SSH restricted via CIDR
- Sensitive files excluded with `.gitignore`
- Do not commit `terraform.tfstate` / `terraform.tfstate.backup`

---

## 📈 Future Improvements

- Add ALB and Auto Scaling
- Integrate SonarQube for code quality
- Deploy using EKS
- Push Docker images to AWS ECR
- Add HTTPS with a load balancer

---

## 👨‍💻 Author

**Prathita Garje**
