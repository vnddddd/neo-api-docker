FROM pengzhile/new-api

# 设置时区为上海
ENV TZ=Asia/Shanghai

# Railway会自动为连接的服务提供环境变量
# 我们不手动设置REDIS_CONN_STRING，而是在下面的startup.sh中动态设置

# 添加启动脚本
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# 如果需要暴露特定端口
EXPOSE 3000

# 使用启动脚本启动应用
ENTRYPOINT ["/startup.sh"]