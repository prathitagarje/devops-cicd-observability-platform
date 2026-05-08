# Public IP of EC2 instance
output "instance_public_ip" {
  description = "Public IP address of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_server.public_ip
}

# Public DNS (useful for browser access)
output "instance_public_dns" {
  description = "Public DNS of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_server.public_dns
}

# Jenkins URL
output "jenkins_url" {
  description = "Access Jenkins UI"
  value       = "http://${aws_instance.jenkins_server.public_ip}:8080"
}

# SonarQube URL (since you opened port 9000)
output "sonarqube_url" {
  description = "Access SonarQube UI (if installed)"
  value       = "http://${aws_instance.jenkins_server.public_ip}:9000"
}

# Prometheus URL
output "prometheus_url" {
  description = "Access Prometheus UI"
  value       = "http://${aws_instance.jenkins_server.public_ip}:9090"
}

# Grafana URL
output "grafana_url" {
  description = "Access Grafana UI"
  value       = "http://${aws_instance.jenkins_server.public_ip}:3000"
}

# SSH Command (very useful for quick access)
output "ssh_command" {
  description = "SSH command to connect to EC2"
  value       = "ssh -i jenkins.pem ec2-user@${aws_instance.jenkins_server.public_ip}"
}

# Key Pair Name
output "key_pair_name" {
  description = "AWS Key Pair name used for EC2"
  value       = aws_key_pair.jenkins_key.key_name
}

# Security Group ID
output "security_group_id" {
  description = "Security Group ID for Jenkins server"
  value       = aws_security_group.jenkins_sg.id
}

# Private Key (save this to jenkins.pem)
output "private_key" {
  description = "Private key for SSH access"
  value       = tls_private_key.jenkins.private_key_pem
  sensitive   = true
}