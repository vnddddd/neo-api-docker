FROM pensile/new-api

# 设置Redis连接环境变量
ENV REDIS_CONN_STRING=redis://redis:6379

# 其他可能需要的环境变量设置
# ENV REDIS_PASSWORD=your_password
# ENV REDIS_MASTER_NAME=your_master_name

# 如果需要暴露特定端口
EXPOSE 3000