#!/bin/bash

# Script to configure a load-balanced web environment securely

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <Backend_IP_1> <Backend_IP_2> <Frontend_IP>"
    exit 1
fi

BACKEND1=$1
BACKEND2=$2
FRONTEND=$3

echo "Starting setup for Frontend ($FRONTEND) and Backends ($BACKEND1, $BACKEND2)"

# Function to execute commands on a remote server
run_remote() {
    ssh -o StrictHostKeyChecking=no root@$1 "$2"
}

# Install and configure Apache on backend servers
for BACKEND in $BACKEND1 $BACKEND2; do
    echo "Configuring Backend Server: $BACKEND"
    run_remote $BACKEND "
        yum install -y httpd &&
        systemctl enable --now httpd &&
        echo '<h1>Welcome to Backend $BACKEND</h1>' > /var/www/html/index.html &&
        firewall-cmd --permanent --add-service=http &&
        firewall-cmd --reload &&
        setsebool -P httpd_can_network_connect on
    "
done

# Install and configure Nginx on frontend server
echo "Configuring Frontend Server: $FRONTEND"
run_remote $FRONTEND "
    yum install -y epel-release &&
    yum install -y nginx &&
    systemctl enable --now nginx &&
    firewall-cmd --permanent --add-service=http &&
    firewall-cmd --reload &&
    setsebool -P httpd_can_network_connect on &&
    setsebool -P nginx_can_network_connect on
"

# Configure Nginx for load balancing
run_remote $FRONTEND "cat > /etc/nginx/conf.d/load_balancer.conf <<EOF
upstream backend_servers {
    server $BACKEND1;
    server $BACKEND2;
}
server {
    listen 80;
    location / {
        proxy_pass http://backend_servers;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF
systemctl reload nginx
"

echo "Setup complete. Frontend at $FRONTEND is now load-balancing between $BACKEND1 and $BACKEND2."
