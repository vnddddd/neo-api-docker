FROM pengzhile/new-api

# 设置时区为上海
ENV TZ=Asia/Shanghai

# 设置Redis连接环境变量 - 使用Railway内部DNS
ENV REDIS_CONN_STRING=redis://redis.railway.internal:6379

# 如果需要暴露特定端口
EXPOSE 3000

# 不需要额外的启动脚本，使用原始镜像的入口点 