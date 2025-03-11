# New API with Redis Docker Setup

这个仓库包含了将 New API 与 Redis 缓存服务一起部署到 Railway 的配置文件。

## 文件结构

- `Dockerfile`: New API 服务的 Docker 配置
- `Dockerfile.redis`: Redis 服务的 Docker 配置
- `redis.conf`: Redis 服务器的配置文件
- `railway.toml`: Railway 平台的配置文件

## 部署说明

### 在 Railway 上部署

1. 将这个仓库链接到你的 Railway 项目
2. Railway 将自动检测 `railway.toml` 文件并构建两个服务:
   - New API 服务
   - Redis 服务
3. 服务将自动配置好相互连接

### 自定义配置

如果需要修改配置，可以编辑以下文件:

- 修改 `Dockerfile` 中的环境变量来配置 New API
- 修改 `redis.conf` 来配置 Redis 服务器
- 修改 `railway.toml` 来配置 Railway 服务设置

## 环境变量

New API 服务配置了以下环境变量:

- `REDIS_CONN_STRING=redis://redis:6379`: 连接到 Redis 服务

如果需要使用 Redis 的密码认证，可以在 Dockerfile 中取消注释并设置:
```
ENV REDIS_PASSWORD=your_password
```

如需使用 Redis 的哨兵模式，可以设置:
```
ENV REDIS_MASTER_NAME=your_master_name
```

## 故障排除

如果 New API 服务无法连接到 Redis，请检查:

1. Redis 服务是否正常运行
2. `REDIS_CONN_STRING` 环境变量是否正确设置
3. 两个服务是否在同一网络中