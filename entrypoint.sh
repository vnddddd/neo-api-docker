#!/bin/sh
# 启动 Redis 在后台
redis-server /app/redis.conf &
# 运行默认的 /neo-api/server
exec /neo-api/server
