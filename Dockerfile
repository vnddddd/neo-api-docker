FROM pengzhile/new-api 
# 安装 Redis
RUN apk add --no-cache redis
# 创建数据目录并设置权限（可选）
RUN mkdir -p /data && chown redis:redis /data
# 拷贝配置文件和启动脚本
COPY ./redis.conf /app/redis.conf
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
# 暴露 Redis 端口
EXPOSE 3000
EXPOSE 6379
# 环境变量
ENV TZ=Asia/Shanghai
ENV TIKTOKEN_CACHE_DIR=/data/cache
# ENV SESSION_SECRET=所有机器统一值
ENV NODE_TYPE=slave
ENV SYNC_FREQUENCY=60
# 生成随机密码并保存到文件中
RUN REDIS_PW=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 10) \
    && echo "requirepass $REDIS_PW" >> /app/redis.conf \
    && echo "REDIS_PW=$REDIS_PW" > /app/redis_password.env

# 使用自定义入口脚本
ENTRYPOINT ["/app/entrypoint.sh"]
