#!/bin/bash
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
apt-get update
apt-get install -y mongodb-org

# Create MongoDB configuration directory if it doesn't exist
mkdir -p /etc/mongod

# Configure MongoDB to accept remote connections
cat > /etc/mongod.conf << EOF
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# network interfaces
net:
  port: ${mongodb_port}
  bindIp: 0.0.0.0  # Allow remote connections

# security settings
security:
  authorization: enabled
EOF

# Start MongoDB
systemctl start mongod
systemctl enable mongod

# Wait for MongoDB to start
sleep 10

# Create admin user
mongosh admin --eval 'db.createUser({user: "${db_username}", pwd: "${db_password}", roles: [{role: "root", db: "admin"}]})'

#mongo admin --eval 'db.createUser({user: "admin", pwd: "Aks_pwd_skilltest@3", roles: [{role: "root", db: "admin"}]})'

# Create database and user for the application
mongosh admin -u "${db_username}" -p "${db_password}" --eval 'db = db.getSiblingDB("travel_memory"); db.createUser({user: "${db_username}", pwd: "${db_password}", roles: [{role: "readWrite", db: "travel_memory"}]})'

#mongosh admin -u "admin" -p "Aks_pwd_skilltest@3" --eval 'db = db.getSiblingDB("travel_memory"); db.createUser({user: "admin", pwd: "Aks_pwd_skilltest@3", roles: [{role: "readWrite", db: "travel_memory"}]})'


# Restart MongoDB for changes to take effect
systemctl restart mongod

echo "MongoDB setup completed"