#!/bin/bash
# Jenkins setup script

# Update package lists
apt-get update

# Install Java (required for Jenkins)
apt-get install -y openjdk-11-jdk

# Add Jenkins repository
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update

# Install Jenkins
apt-get install -y jenkins

# Start Jenkins service
systemctl start jenkins
systemctl enable jenkins

# Install other necessary tools
apt-get install -y git curl unzip

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update
apt-get install -y terraform

# Install Node.js and npm for frontend deployment
apt-get install -y nodejs npm

# Install MongoDB client for potential database operations
apt-get install -y mongodb-clients

# Setup SSH keys for Jenkins user to access other instances
mkdir -p /var/lib/jenkins/.ssh
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
chmod 700 /var/lib/jenkins/.ssh

# Get Jenkins initial admin password for later use
echo "Jenkins initial admin password: $(cat /var/lib/jenkins/secrets/initialAdminPassword)"

# Install Jenkins plugins via CLI
# In a real setup, you'd use Jenkins Configuration as Code (JCasC)
JENKINS_CLI="/tmp/jenkins-cli.jar"
wget -q http://localhost:8080/jnlpJars/jenkins-cli.jar -O $JENKINS_CLI
sleep 60 # Wait for Jenkins to start up

# Install necessary plugins
java -jar $JENKINS_CLI -s http://localhost:8080/ -auth admin:$(cat /var/lib/jenkins/secrets/initialAdminPassword) install-plugin git aws-credentials terraform pipeline-aws credentials-binding

# Setup firewall to allow Jenkins web interface
ufw allow 8080/tcp
ufw allow 22/tcp
ufw --force enable

echo "Jenkins setup completed"
