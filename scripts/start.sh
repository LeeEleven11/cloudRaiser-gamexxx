#!/bin/bash

DEPLOY_DIR="/home/ec2-user/myapp"
JAR_FILE="$DEPLOY_DIR/target/cloudRaiser-eks-0.0.1-SNAPSHOT.jar"

if [ ! -f "$JAR_FILE" ]; then
  echo "ERROR: JAR file not found at $JAR_FILE"
  echo "Directory contents:"
  ls -lR "$DEPLOY_DIR"
  exit 1
fi

nohup java -jar "$JAR_FILE" > /home/ec2-user/logs/app.log 2>&1 &
echo "Started: $JAR_FILE (PID: $!)"