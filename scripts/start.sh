#!/bin/bash

echo "Starting the application..."

# 确保进入正确的目录（根据 appspec.yml 中的 destination）
DEPLOY_DIR="/home/ec2-user/myapp"
cd "$DEPLOY_DIR" || { echo "Failed to enter $DEPLOY_DIR"; exit 1; }

# 动态匹配 JAR 文件名（避免硬编码）
JAR_FILE=$(ls *.jar | head -n 1)
if [ -z "$JAR_FILE" ]; then
  echo "Error: No JAR file found in $DEPLOY_DIR!"
  exit 1
fi

# 启动应用并记录 PID
nohup java -Dspring.profiles.active=prod -jar "$JAR_FILE" > /home/ec2-user/logs/app.log 2>&1 &
echo "Application started: $JAR_FILE (PID: $!)"