FROM pangzhile/new_api

# 安装必要包
RUN apt-get update && apt-get install -y supervisor redis-server

# 配置 Redis
RUN mkdir -p /etc/redis
RUN echo "bind 0.0.0.0" > /etc/redis/redis.conf
RUN echo "port 49153" >> /etc/redis/redis.conf
RUN echo "requirepass redispw" >> /etc/redis/redis.conf

# 配置 Supervisord
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 设置环境变量
ENV REDIS_CONN_STRING=redis://default:redispw@localhost:49153

# 设置入口点为 Supervisord
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]