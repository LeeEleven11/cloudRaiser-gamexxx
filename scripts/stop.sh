#!/bin/bash

# 匹配部署目录中的 JAR 文件
DEPLOY_DIR="/home/ec2-user/myapp"
JAR_FILE=$(ls "$DEPLOY_DIR"/*.jar | head -n 1)
if [ -z "$JAR_FILE" ]; then
  echo "Error: No JAR file found in $DEPLOY_DIR!"
  exit 1
fi

# 获取进程 PID
PID=$(pgrep -f "$(basename "$JAR_FILE")")
if [ -n "$PID" ]; then
  echo "Stopping application (PID: $PID)..."
  kill "$PID"  # 先尝试优雅终止
  sleep 5
  if ps -p "$PID" > /dev/null; then
    echo "Force killing PID: $PID"
    kill -9 "$PID"
  fi
else
  echo "Application is not running."
fi