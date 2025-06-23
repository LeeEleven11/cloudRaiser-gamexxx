#!/bin/bash

echo "Executing BeforeInstall hook..."

# 1. 停止当前运行的应用程序（如果有的话）
APP_NAME="cloudRaiser-eks-0.0.1-SNAPSHOT.jar"
PID=$(ps -ef | grep $APP_NAME | grep -v grep | awk '{print $2}')

if [ -n "$PID" ]; then
  echo "Stopping the currently running application with PID: $PID"
  kill -9 $PID
  sleep 3  # 等待进程完全停止
else
  echo "No application is currently running."
fi

# 2. 清理旧部署文件（新增关键步骤）
DEPLOY_DIR="/home/ec2-user/myapp"
TARGET_DIR="$DEPLOY_DIR/target"

echo "Cleaning previous deployment files..."
rm -fv "$TARGET_DIR/$APP_NAME"  # 强制删除旧JAR文件
rm -fv "$DEPLOY_DIR/application.properties"  # 清理旧配置文件

# 3. 备份当前配置文件（如果需要）
CONFIG_BACKUP_DIR="$DEPLOY_DIR/config_backup"
CURRENT_CONFIG_FILE="$DEPLOY_DIR/application.properties"

if [ -f "$CURRENT_CONFIG_FILE" ]; then
  echo "Backing up current configuration file..."
  mkdir -p $CONFIG_BACKUP_DIR
  cp -v $CURRENT_CONFIG_FILE $CONFIG_BACKUP_DIR/application.properties_$(date +%Y%m%d%H%M%S)
else
  echo "No configuration file found to backup."
fi

# 4. 重建目录结构（增强版）
echo "Recreating directory structure..."
mkdir -p "$TARGET_DIR"  # 确保target目录存在
mkdir -p "$DEPLOY_DIR"
mkdir -p "/home/ec2-user/logs"

# 5. 设置权限（新增）
chown -R ec2-user:ec2-user "$DEPLOY_DIR"
chmod -R 755 "$DEPLOY_DIR"

# 6. 其他预处理任务
echo "Setting environment variables..."
export SPRING_PROFILES_ACTIVE=prod

echo "BeforeInstall hook completed successfully."