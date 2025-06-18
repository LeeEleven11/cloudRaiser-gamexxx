#!/bin/bash

echo "Executing BeforeInstall hook..."

# 1. 停止当前运行的应用程序（如果有的话）
APP_NAME="cloudRaiser-eks-0.0.1-SNAPSHOT.jar"
PID=$(ps -ef | grep $APP_NAME | grep -v grep | awk '{print $2}')

if [ -n "$PID" ]; then
  echo "Stopping the currently running application with PID: $PID"
  kill -9 $PID
else
  echo "No application is currently running."
fi

# 2. 备份当前配置文件（如果需要）
CONFIG_BACKUP_DIR="/home/ec2-user/myapp/config_backup"
CURRENT_CONFIG_FILE="/home/ec2-user/myapp/application.properties"

if [ -f "$CURRENT_CONFIG_FILE" ]; then
  echo "Backing up current configuration file..."
  mkdir -p $CONFIG_BACKUP_DIR
  cp $CURRENT_CONFIG_FILE $CONFIG_BACKUP_DIR/application.properties_$(date +%Y%m%d%H%M%S)
else
  echo "No configuration file found to backup."
fi

# 3. 创建必要的目录结构
DEPLOY_DIR="/home/ec2-user/myapp"
LOGS_DIR="/home/ec2-user/logs"

echo "Creating necessary directories..."
mkdir -p $DEPLOY_DIR
mkdir -p $LOGS_DIR

# 4. 其他预处理任务（例如设置环境变量）
echo "Setting environment variables..."
export SPRING_PROFILES_ACTIVE=prod

echo "BeforeInstall hook completed successfully."
