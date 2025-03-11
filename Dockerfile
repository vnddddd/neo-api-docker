# 使用 pengzhile/new-api:latest 作为基础镜像
FROM pengzhile/new-api:latest

# 安装 Redis 和 Supervisord，基于 Alpine 的包管理器 apk
RUN apk update && apk add --no-cache redis supervisor && rm -rf /var/cache/apk/*

# 配置 Redis
RUN mkdir -p /etc/redis
RUN echo "bind 0.0.0.0" > /etc/redis/redis.conf \
    && echo "port 49153" >> /etc/redis/redis.conf \
    && echo "requirepass redispw" >> /etc/redis/redis.conf

# 配置 Supervisord
RUN mkdir -p /etc/supervisor/conf.d
RUN echo "[supervisord]" > /etc/supervisor/conf.d/supervisord.conf \
    && echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "[program:redis]" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "command=redis-server /etc/redis/redis.conf" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "startsecs=0" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "[program:new_api]" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "command=newapi" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "startsecs=0" >> /etc/supervisor/conf.d/supervisord.conf

# 设置环境变量
ENV REDIS_CONN_STRING=redis://default:redispw@localhost:49153

# 暴露端口（可选，取决于容器网站需求）
EXPOSE 49153

# 启动 Supervisord
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]