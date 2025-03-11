# Neo API Docker

这是一个基于 `pengzhile/new-api` 的 Docker 镜像，集成了 Redis 服务并预配置了多种环境变量，可以快速部署使用。

## 功能特点

- 基于 `pengzhile/new-api` 镜像
- 内置 Redis 服务
- 预配置的环境变量
- 自定义入口脚本

## 环境变量说明

本项目使用以下环境变量，可以在 `.env` 文件中配置：

### Redis 配置
| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `REDIS_PASSWORD` | Redis 密码 | 必须设置一个强密码 |
| `ALLOW_EMPTY_PASSWORD` | 是否允许空密码 | no |
| `REDIS_DISABLE_COMMANDS` | 禁用的 Redis 命令 | FLUSHDB,FLUSHALL |
| `REDIS_CONN_STRING` | Redis 连接字符串 | redis://redis |

### 系统配置
| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `TZ` | 时区 | Asia/Shanghai |
| `TIKTOKEN_CACHE_DIR` | Tiktoken 缓存目录 | /data/cache |
| `SESSION_SECRET` | 会话密钥 | 所有集群机器统一值 |
| `NODE_TYPE` | 节点类型 | slave |
| `SYNC_FREQUENCY` | 同步频率（秒） | 60 |
| `SQL_DSN` | SQL 数据库连接字符串 | your_database_type://your_username:your_password@your_database_host:your_port/your_database_name
 |
其余环境变量去 [one-api](https://github.com/songquanpeng/one-api?tab=readme-ov-file#%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F)基本都是通用的
## 一键部署

### 前提条件

- 安装 [Docker](https://docs.docker.com/get-docker/)
- 安装 [Docker Compose](https://docs.docker.com/compose/install/) (可选，但推荐)

### 使用 Docker Compose 部署（推荐）

1. 克隆仓库：
   ```bash
   git clone https://github.com/yourusername/neo-api-docker.git
   cd neo-api-docker
   ```

2. 复制并根据需要修改环境变量：
   ```bash
   cp .env.example .env
   # 编辑 .env 文件，按需修改环境变量
   ```

3. 创建 docker-compose.yml 文件：
   ```yaml
   version: '3'
   services:
     neo-api:
       build: .
       ports:
         - "3000:3000"
         - "6379:6379"
       env_file:
         - .env
       volumes:
         - data:/data
   volumes:
     data:
   ```

4. 启动服务：
   ```bash
   docker-compose up -d
   ```

### 使用 Docker 命令部署

1. 克隆仓库：
   ```bash
   git clone https://github.com/yourusername/neo-api-docker.git
   cd neo-api-docker
   ```

2. 创建并配置 `.env` 文件

3. 构建镜像：
   ```bash
   docker build -t neo-api-docker .
   ```

4. 启动容器：
   ```bash
   docker run -d --name neo-api --env-file .env -p 6379:6379 -p 3000:3000 neo-api-docker
   ```

## 使用说明

部署完成后：

1. API 服务会在端口 3000 上运行
2. Redis 服务会在端口 6379 上运行

访问 `http://your-server-ip:3000` 来使用 API 服务。

## 自定义配置

如果需要自定义 Redis 配置，可以编辑 `redis.conf` 文件。

## 故障排除

遇到问题？查看容器日志：

```bash
docker logs neo-api
```

## 维护与更新

更新到最新版本：

```bash
git pull
docker-compose down
docker-compose up -d --build
``` 