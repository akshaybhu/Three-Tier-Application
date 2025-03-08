#!/bin/bash
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install Node.js and npm
apt-get install -y ca-certificates curl gnupg
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get install -y nodejs

# Install Git and Nginx
apt-get install -y git nginx

# Clone repository
git clone https://github.com/UnpredictablePrashant/TravelMemory.git /opt/travel-memory

# Set up frontend
cd /opt/travel-memory/client

# Update the API endpoint in the configuration file
cat > src/url.js << EOF
export const url = "http://${backend_ip}:${backend_port}";
EOF

# Install dependencies and build the frontend
npm install
npm run build

# Configure Nginx to serve the frontend
cat > /etc/nginx/sites-available/travel-memory << EOF
server {
    listen 80;
    server_name _;

    location / {
        root /opt/travel-memory/client/build;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

# Enable the Nginx site
ln -s /etc/nginx/sites-available/travel-memory /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Restart Nginx
systemctl restart nginx
systemctl enable nginx

# For development purposes, also start the React development server
cd /opt/travel-memory/client
npm install -g pm2
pm2 start npm --name "frontend" -- start

echo "Frontend setup completed"