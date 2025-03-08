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

# Install Git
apt-get install -y git

# Clone repository
git clone https://github.com/UnpredictablePrashant/TravelMemory.git /opt/travel-memory

# Set up backend
cd /opt/travel-memory/server

# Create .env file
cat > .env << EOF
PORT=${backend_port}
MONGO_URI=mongodb://${mongodb_username}:${mongodb_password}@${mongodb_ip}:${mongodb_port}/travel_memory?authSource=admin
EOF


# Install dependencies and start server
npm install
npm install -g pm2
pm2 start index.js --name "backend"
pm2 startup
pm2 save

echo "Backend setup completed"