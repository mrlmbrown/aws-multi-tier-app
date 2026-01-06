#!/bin/bash
# Update system packages
dnf update -y

# Install Python 3 and pip
dnf install -y python3 python3-pip

# Install Flask and PyMySQL
pip3 install flask pymysql

# Create app directory
mkdir -p /opt/flask-app
cd /opt/flask-app

# Create Flask application
cat > app.py << 'EOF'
from flask import Flask, jsonify
import pymysql
import os

app = Flask(__name__)

# Database configuration from template variables
DB_HOST = "${db_endpoint}"
DB_NAME = "${db_name}"
DB_USER = "${db_username}"
DB_PASS = "${db_password}"

@app.route('/')
def home():
    return jsonify({
        "message": "Welcome to the Multi-Tier Flask Application!",
        "status": "running"
    })

@app.route('/health')
def health():
    return jsonify({"status": "healthy"}), 200

@app.route('/db-test')
def db_test():
    try:
        connection = pymysql.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASS,
            database=DB_NAME
        )
        cursor = connection.cursor()
        cursor.execute("SELECT VERSION()")
        version = cursor.fetchone()
        connection.close()
        return jsonify({
            "status": "success",
            "database": "connected",
            "version": version[0]
        })
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# Create systemd service
cat > /etc/systemd/system/flask-app.service << 'EOF'
[Unit]
Description=Flask Application
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/flask-app
ExecStart=/usr/bin/python3 /opt/flask-app/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the Flask app
systemctl daemon-reload
systemctl enable flask-app
systemctl start flask-app