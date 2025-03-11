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

# 尝试确定并执行原始镜像中的正确命令
if [ -f "/neo-api" ]; then
  echo "Using /neo-api executable"
  exec /neo-api
elif [ -f "/app/neo-api" ]; then
  echo "Using /app/neo-api executable"
  exec /app/neo-api
elif [ -f "/app/server" ]; then
  echo "Using /app/server executable"
  exec /app/server
elif [ -f "/app/main" ]; then
  echo "Using /app/main executable"
  exec /app/main
elif [ -f "/entrypoint.sh" ]; then
  echo "Using original entrypoint.sh script"
  exec /entrypoint.sh
elif [ -f "/app/entrypoint.sh" ]; then
  echo "Using app/entrypoint.sh script"
  exec /app/entrypoint.sh
elif [ -f "/app/start.sh" ]; then
  echo "Using app/start.sh script"
  exec /app/start.sh
elif [ -d "/app" ] && [ -f "/app/package.json" ]; then
  echo "Detected Node.js application, using npm start"
  cd /app && exec npm start
else
  echo "Could not determine original command. Listing available executables:"
  find / -type f -executable -not -path "*/proc/*" -not -path "*/sys/*" | grep -v "node_modules" | head -n 30
  
  echo "Trying fallback command: ls -la /"
  ls -la /
  echo "Trying fallback command: ls -la /app"
  ls -la /app 2>/dev/null || echo "No /app directory found"
  
  echo "ERROR: Could not find the correct executable. Please check the image documentation."
  # 保持容器运行以便检查
  tail -f /dev/null 