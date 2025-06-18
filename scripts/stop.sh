#!/bin/bash

APP_NAME="cloudRaiser-eks-0.0.1-SNAPSHOT.jar"
PID=$(ps -ef | grep $APP_NAME | grep -v grep | awk '{print $2}')

if [ -n "$PID" ]; then
  echo "Stopping application with PID: $PID"
  kill -9 $PID
else
  echo "Application is not running."
fi
