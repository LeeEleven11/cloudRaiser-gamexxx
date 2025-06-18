#!/bin/bash

echo "Starting the application..."

cd /home/ec2-user/myapp || exit

JAR_FILE="cloudRaiser-eks-0.0.1-SNAPSHOT.jar"

if [ -f "$JAR_FILE" ]; then
  nohup java -Dspring.profiles.active=prod -jar $JAR_FILE > /home/ec2-user/logs/app.log 2>&1 &
  echo "Application started: $JAR_FILE"
else
  echo "No JAR file found to start!"
  exit 1
fi
