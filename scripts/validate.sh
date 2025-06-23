#!/bin/bash

echo "Validating the service..."

# 从配置文件中获取端口（默认 8080）
CONFIG_FILE="/home/ec2-user/myapp/application.properties"
PORT=$(grep "server.port" "$CONFIG_FILE" | cut -d'=' -f2 || echo "8080")

# 等待应用启动（可调整超时时间）
MAX_RETRIES=5
RETRY_INTERVAL=5
for i in $(seq 1 $MAX_RETRIES); do
  if ss -tuln | grep ":$PORT" > /dev/null; then
    echo "Port $PORT is listening."
    # 进一步检查 HTTP 接口（示例）
    if curl -s "http://localhost:$PORT/actuator/health" | grep -q "UP"; then
      echo "Service is fully up and healthy."
      exit 0
    fi
  fi
  sleep "$RETRY_INTERVAL"
  echo "Retrying... ($i/$MAX_RETRIES)"
done

echo "Validation failed: Service not responding on port $PORT."
exit 1