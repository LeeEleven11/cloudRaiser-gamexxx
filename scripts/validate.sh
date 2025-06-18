#!/bin/bash

echo "Validating the service..."

# 等待应用启动
sleep 10

# 检查是否监听了端口（例如 8080）
PORT=8080
if ss -tuln | grep ":$PORT" > /dev/null; then
  echo "Port $PORT is listening. Service is up."
else
  echo "Service failed to start on port $PORT."
  exit 1
fi
