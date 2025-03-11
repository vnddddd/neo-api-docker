# 使用 pengzhile/new-api:latest 作为基础镜像
FROM pengzhile/new-api:latest

# 安装 Redis
RUN apk update && apk add --no-cache redis && rm -rf /var/cache/apk/*

# 配置 Redis（简化）
RUN echo "port 49153" > /etc/redis.conf \
    && echo "requirepass redispw" >> /etc/redis.conf

# 创建启动脚本
RUN echo "#!/bin/sh" > /start.sh \
    && echo "redis-server /etc/redis.conf &" >> /start.sh \
    && echo "sleep 5" >> /start.sh \
    && echo "newapi" >> /start.sh \
    && chmod +x /start.sh

# 设置环境变量
ENV REDIS_CONN_STRING=redis://default:redispw@localhost:49153

# 暴露端口
EXPOSE 49153

# 使用启动脚本运行
CMD ["/start.sh"]