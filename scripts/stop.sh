#!/bin/bash

# 使用实际部署目录和精确路径
DEPLOY_DIR="/home/ec2-user/myapp"
JAR_PATH="$DEPLOY_DIR/target/cloudRaiser-eks-0.0.1-SNAPSHOT.jar"

# 1. 检查JAR文件是否存在
if [ ! -f "$JAR_PATH" ]; then
  echo "WARNING: JAR file not found at $JAR_PATH"
  echo "Checking for any JAR file in target directory..."

  # 尝试在target目录下查找任何JAR文件
  ALTERNATE_JAR=$(ls "$DEPLOY_DIR"/target/*.jar 2>/dev/null | head -n 1)

  if [ -z "$ALTERNATE_JAR" ]; then
    echo "ERROR: No JAR files found in $DEPLOY_DIR/target/"
    echo "Directory contents:"
    ls -lR "$DEPLOY_DIR"
    exit 0  # 不是错误退出，只是没有应用需要停止
  else
    JAR_PATH="$ALTERNATE_JAR"
    echo "Found alternate JAR file: $JAR_PATH"
  fi
fi

# 2. 获取进程PID
PID=$(pgrep -f "$(basename "$JAR_PATH")")

# 3. 停止应用
if [ -n "$PID" ]; then
  echo "Stopping application (PID: $PID) using JAR: $JAR_PATH"
  kill "$PID"  # 先尝试优雅终止
  sleep 5
  if ps -p "$PID" > /dev/null; then
    echo "Force killing PID: $PID"
    kill -9 "$PID"
  fi
  echo "Application stopped successfully."
else
  echo "Application is not running (No process found for: $(basename "$JAR_PATH"))."
fi

exit 0