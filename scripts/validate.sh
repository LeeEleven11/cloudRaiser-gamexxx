#!/bin/bash

echo "Validating the service..."

# 1. 确定配置文件路径
CONFIG_FILE="/home/ec2-user/myapp/application.properties"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: Configuration file not found at $CONFIG_FILE"
  exit 1
fi

# 2. 获取端口号（带默认值）
PORT=$(grep -E '^server.port' "$CONFIG_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
PORT=${PORT:-8080}  # 默认8080如果配置中没有指定
echo "Checking service on port: $PORT"

# 3. 等待应用启动
MAX_RETRIES=10
RETRY_INTERVAL=5
SERVICE_UP=false

for i in $(seq 1 $MAX_RETRIES); do
  # 检查端口是否监听
  if ss -tuln | grep -q ":$PORT "; then
    echo "Port $PORT is listening."

    # 检查健康端点
    HEALTH_RESPONSE=$(curl -s "http://localhost:$PORT/actuator/health" || echo "{}")
    if echo "$HEALTH_RESPONSE" | grep -q '"status":"UP"'; then
      echo "Service is fully up and healthy."
      SERVICE_UP=true
      break
    else
      echo "Health check failed. Response: $HEALTH_RESPONSE"
    fi
  else
    echo "Port $PORT not yet listening."
  fi

  echo "Retrying... ($i/$MAX_RETRIES)"
  sleep $RETRY_INTERVAL
done

if [ "$SERVICE_UP" = false ]; then
  echo "Validation failed: Service not responding properly on port $PORT"
  echo "Last health check response: $HEALTH_RESPONSE"
  exit 1
fi

exit 0