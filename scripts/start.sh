#!/bin/bash

echo "Starting the application..."

# 使用实际部署目录
DEPLOY_DIR="/home/ec2-user/nyapp"
cd "$DEPLOY_DIR" || { echo "Failed to enter $DEPLOY_DIR"; exit 1; }

# 在 target/ 目录下查找 JAR 文件
JAR_FILE="target/cloudRaiser-eks-0.0.1-SNAPSHOT.jar"
if [ ! -f "$JAR_FILE" ]; then
  echo "ERROR: JAR file not found at $DEPLOY_DIR/$JAR_FILE"
  echo "Current directory contents:"
  ls -lR  # 打印完整目录结构
  exit 1
fi

# 启动应用
nohup java -Dspring.profiles.active=prod -jar "$JAR_FILE" > /home/ec2-user/logs/app.log 2>&1 &
echo "Application started: $JAR_FILE (PID: $!)"