#!/bin/bash
apt update -y
apt install -y apache2

# Get the instance ID using the instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Install the AWS CLI
apt install -y awscli

# Create a simple HTML file 
echo "<h1>This is my Terraform Project!! from $(hostname -f)</h1>" > /var/www/html/index.html


# Start Apache and enable it on boot
systemctl start apache2
systemctl enable apache2