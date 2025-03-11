#!/bin/sh

# 输出调试信息
echo "Starting New API with Redis connection setup..."

# 检查Railway环境变量
if [ -n "$RAILWAY_ENVIRONMENT" ]; then
  echo "Running in Railway environment"
  
  # 使用Railway自动提供的Redis环境变量
  if [ -n "$REDIS_HOST" ]; then
    echo "Setting up Redis connection using REDIS_HOST: $REDIS_HOST"
    export REDIS_CONN_STRING="redis://$REDIS_HOST:$REDIS_PORT"
  elif [ -n "$REDISHOST" ]; then
    echo "Setting up Redis connection using REDISHOST: $REDISHOST"
    export REDIS_CONN_STRING="redis://$REDISHOST:$REDISPORT"
  # 使用Railway服务URL格式
  elif [ -n "$REDIS_URL" ]; then
    echo "Setting up Redis connection using REDIS_URL: $REDIS_URL"
    export REDIS_CONN_STRING="$REDIS_URL"
  else
    echo "No Railway Redis variables found, using default internal address"
    # 尝试使用Railway内部服务发现
    export REDIS_CONN_STRING="redis://redis.railway.internal:6379"
  fi
else
  # 本地开发环境
  echo "Running in local development environment"
  export REDIS_CONN_STRING="redis://redis:6379"
fi

echo "REDIS_CONN_STRING=$REDIS_CONN_STRING"

# 执行原始入口点命令（这会根据pengzhile/new-api的设置来执行）
exec "$@" 