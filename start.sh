#!/bin/bash

# 确保Redis数据目录存在
mkdir -p /var/lib/redis
mkdir -p /var/log/redis
mkdir -p /var/run/redis

# 启动Redis服务器
redis-server /etc/redis/redis.conf

# 等待Redis启动完成
sleep 2

# 设置Redis连接环境变量（确保API能连接到本地Redis）
export REDIS_CONN_STRING="redis://localhost:6379"

# 启动New API（根据新API的启动方式调整）
# 因为这里是基于pensile/new-api镜像，我们需要找到原镜像的入口点并执行它
# 这里我假设原镜像有一个默认的CMD或ENTRYPOINT

# 获取原镜像的ENTRYPOINT
ORIGINAL_ENTRYPOINT=$(cat /proc/1/cmdline | tr '\0' ' ' | awk '{print $1}')

if [ -n "$ORIGINAL_ENTRYPOINT" ] && [ "$ORIGINAL_ENTRYPOINT" != "/start.sh" ]; then
    # 执行原来的入口点
    exec $ORIGINAL_ENTRYPOINT "$@"
else
    # 如果无法确定原始入口点，则尝试常见的启动方式
    # 假设API应用是Node.js应用
    if [ -f "package.json" ]; then
        exec npm start
    # 假设API应用是Python应用
    elif [ -f "app.py" ]; then
        exec python app.py
    elif [ -f "main.py" ]; then
        exec python main.py
    # 其他可能的入口点文件
    else
        # 保持容器运行，并输出日志
        echo "Redis server is running. API service not started automatically."
        echo "Please ensure your New API service is configured correctly."
        tail -f /var/log/redis/redis-server.log
    fi
fi