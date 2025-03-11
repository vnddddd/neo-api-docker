# 使用 pengzhile/new-api:latest 作为基础镜像
FROM pengzhile/new-api:latest

# 安装 Redis 和 Supervisord
RUN apk update && apk add --no-cache redis supervisor && rm -rf /var/cache/apk/*

# 配置 Redis，支持 IPv4 和 IPv6
RUN mkdir -p /etc/redis
RUN echo "bind 0.0.0.0 ::1" > /etc/redis/redis.conf \
    && echo "port 49153" >> /etc/redis/redis.conf \
    && echo "requirepass redispw" >> /etc/redis/redis.conf

# 配置 Supervisord，添加日志输出
RUN mkdir -p /etc/supervisor/conf.d /var/log/supervisor
RUN echo "[supervisord]" > /etc/supervisor/conf.d/supervisord.conf \
    && echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "logfile=/var/log/supervisor/supervisord.log" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "loglevel=debug" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "[program:redis]" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "command=redis-server /etc/redis/redis.conf" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "startsecs=3" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "stdout_logfile=/var/log/supervisor/redis.log" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "stderr_logfile=/var/log/supervisor/redis_err.log" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "[program:new_api]" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "command=newapi" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "startsecs=3" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "depends_on=redis" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "stdout_logfile=/var/log/supervisor/new_api.log" >> /etc/supervisor/conf.d/supervisord.conf \
    && echo "stderr_logfile=/var/log/supervisor/new_api_err.log" >> /etc/supervisor/conf.d/supervisord.conf

# 设置环境变量
ENV REDIS_CONN_STRING=redis://default:redispw@localhost:49153

# 暴露端口
EXPOSE 49153

# 启动 Supervisord
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]