#!/bin/bash

## 匹配部署目录中的 JAR 文件
#DEPLOY_DIR="/home/ec2-user/myapp"
#JAR_FILE=$(ls "$DEPLOY_DIR"/*.jar | head -n 1)
#if [ -z "$JAR_FILE" ]; then
#  echo "Error: No JAR file found in $DEPLOY_DIR!"
#  exit 1
#fi
#
## 获取进程 PID
#PID=$(pgrep -f "$(basename "$JAR_FILE")")
#if [ -n "$PID" ]; then
#  echo "Stopping application (PID: $PID)..."
#  kill "$PID"  # 先尝试优雅终止
#  sleep 5
#  if ps -p "$PID" > /dev/null; then
#    echo "Force killing PID: $PID"
#    kill -9 "$PID"
#  fi
#else
#  echo "Application is not running."
#fi

#
##!/bin/bash
#
DEPLOY_DIR="/home/ec2-user/myapp"
JAR_PATH="$DEPLOY_DIR/target/cloudRaiser-eks-0.0.1-SNAPSHOT.jar"  # 直接指定路径

if [ ! -f "$JAR_PATH" ]; then
  echo "ERROR: JAR file not found at $JAR_PATH"
  echo "Directory contents:"
  ls -lR "$DEPLOY_DIR"  # 打印完整目录结构以便调试
  exit 1
fi

# 获取进程 PID（通过 JAR 文件名匹配）
PID=$(pgrep -f "$(basename "$JAR_PATH")")
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