# n8n Docker Compose 部署指南

本仓库包含了基于 n8n 官方 Docker 部署指南的 Docker Compose 配置文件。

## 文件说明

- `docker-compose.yml` - 基础版本，使用 SQLite 数据库
- `docker-compose.postgres.yml` - 完整版本，使用 PostgreSQL 数据库（推荐生产环境使用）
- `.env.example` - 环境变量配置模板
- `CONFIGURATION_GUIDE.md` - 详细配置指南

## 快速开始

### 方式一：使用 SQLite（简单部署）

```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f n8n

# 停止服务
docker-compose down
```

### 方式二：使用 PostgreSQL（推荐生产环境）

```bash
# 1. 配置环境变量
cp .env.example .env
# 编辑 .env 文件，修改密码和密钥

# 2. 启动服务
docker-compose -f docker-compose.postgres.yml up -d

# 3. 查看日志
docker-compose -f docker-compose.postgres.yml logs -f n8n

# 停止服务
docker-compose -f docker-compose.postgres.yml down
```

> ⚠️ **重要**：使用 PostgreSQL 版本前，请务必阅读 `CONFIGURATION_GUIDE.md` 并修改默认密码和加密密钥！

## ⭐ 新功能：环境变量配置

现在所有配置都支持通过 `.env` 文件进行自定义！主要特性：

- ✅ **完全基于环境变量**：所有硬编码值已移除
- ✅ **安全默认值**：提供合理的默认配置
- ✅ **灵活端口配置**：支持自定义端口映射
- ✅ **完整的安全配置**：包含加密和认证设置

### 配置步骤

```bash
# 1. 复制配置模板
cp .env.example .env

# 2. 修改重要配置（必须）
# 编辑 .env 文件，修改：
# - POSTGRES_PASSWORD（数据库密码）
# - N8N_ENCRYPTION_KEY（加密密钥）
# - N8N_BASIC_AUTH_USER（管理员用户名）
# - N8N_BASIC_AUTH_PASSWORD（管理员密码）
```

### 访问地址

部署完成后，访问：http://localhost:5678

### 数据持久化

- n8n 数据存储在 `n8n_data` volume 中
- PostgreSQL 数据存储在 `postgres_data` volume 中（如果使用 PostgreSQL）

## 安全建议

1. **更改默认密码**：修改 `N8N_BASIC_AUTH_PASSWORD` 和数据库密码
2. **设置加密密钥**：生成并设置唯一的 `N8N_ENCRYPTION_KEY`
3. **启用 HTTPS**：生产环境建议使用反向代理（如 Nginx）配置 SSL
4. **网络安全**：不要将数据库端口暴露到外网

## 生产环境部署建议

1. 使用 PostgreSQL 数据库版本
2. 配置反向代理（Nginx/Traefik）
3. 启用 SSL/TLS
4. 定期备份数据
5. 监控资源使用情况

## 常用命令

```bash
# 查看运行状态
docker-compose ps

# 重启服务
docker-compose restart

# 更新到最新版本
docker-compose pull
docker-compose up -d

# 查看数据卷
docker volume ls

# 备份数据卷
docker run --rm -v n8n_data:/data -v $(pwd):/backup alpine tar czf /backup/n8n_backup.tar.gz -C /data .

# 恢复数据卷
docker run --rm -v n8n_data:/data -v $(pwd):/backup alpine tar xzf /backup/n8n_backup.tar.gz -C /data
```

## 故障排除

1. **端口冲突**：如果 5678 端口被占用，修改 `docker-compose.yml` 中的端口映射
2. **权限问题**：确保数据目录有正确的权限
3. **数据库连接问题**：检查数据库服务是否正常启动

## 更多信息

- [n8n 官方文档](https://docs.n8n.io/)
- [n8n Docker 镜像](https://hub.docker.com/r/n8nio/n8n)
- [n8n GitHub 仓库](https://github.com/n8n-io/n8n)
