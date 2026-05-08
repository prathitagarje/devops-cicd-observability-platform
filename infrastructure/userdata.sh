#!/bin/bash
set -euxo pipefail

# Log output (important for debugging)
exec > /var/log/user-data.log 2>&1

# Update system
yum update -y

# Install base tools
yum install -y git docker maven tree wget

# Start & enable Docker
systemctl enable docker
systemctl start docker

# Install Java (Corretto 21)
dnf install -y java-21-amazon-corretto

# Add Jenkins repo
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import Jenkins key
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
dnf install -y jenkins

# Allow Jenkins to run Docker
usermod -aG docker jenkins

#Reload the systemd process completely while keeping currently running services alive
systemctl daemon-reexec
# Enable & start Jenkins
systemctl enable jenkins
systemctl start jenkins

# Wait until Jenkins is ready (better than sleep)
until systemctl is-active --quiet jenkins; do
  sleep 5
done

# Save admin password securely
cat /var/lib/jenkins/secrets/initialAdminPassword > /home/ec2-user/jenkins-pass.txt
chown ec2-user:ec2-user /home/ec2-user/jenkins-pass.txt
chmod 400 /home/ec2-user/jenkins-pass.txt

# Install Prometheus
# Add Prometheus repo
cat > /etc/yum.repos.d/prometheus.repo <<EOF
[prometheus]
name=Prometheus
baseurl=https://packagecloud.io/prometheus-rpm/release/el/7/\$basearch
repo_gpgcheck=1
enabled=1
gpgkey=https://packagecloud.io/prometheus-rpm/release/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
EOF

dnf install -y prometheus

# Enable & start Prometheus
systemctl enable prometheus
systemctl start prometheus

# Install Grafana
# Add Grafana repo
cat > /etc/yum.repos.d/grafana.repo <<EOF
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgkey=https://rpm.grafana.com/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

dnf install -y grafana

# Enable & start Grafana
systemctl enable grafana-server
systemctl start grafana-server