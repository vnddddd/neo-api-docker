#!/bin/sh
set -e

# 读取Redis密码
source /app/redis_password.env

# 导出环境变量，让应用能够使用
export REDIS_CONN_STRING="redis://default:${REDIS_PW}@localhost:6379"
echo "Redis connection string: $REDIS_CONN_STRING"

# 检查Redis是否已在运行
if ! pgrep -x "redis-server" > /dev/null; then
    # 启动Redis服务
    redis-server /app/redis.conf &
    
    # 等待Redis启动完成
    sleep 2
    
    # 测试Redis连接
    redis-cli -a "$REDIS_PW" ping
fi

exec /neo-api/server  