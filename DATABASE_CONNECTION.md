# 连接 n8n PostgreSQL 数据库指南

## 数据存储方式

**已更新为本地文件夹映射**：
- PostgreSQL数据存储在：`./postgres_data/` 
- n8n配置数据存储在：`./n8n_data/`
- 数据直接映射到本地，方便备份和访问

## 连接信息

现在您可以使用以下信息从本地DataGrid连接到n8n的PostgreSQL数据库：

### 连接参数
- **主机地址**: `localhost` 或 `127.0.0.1`
- **端口**: `5432`
- **数据库名**: `n8n`
- **用户名**: `n8n`
- **密码**: `n8n_password`

### 连接字符串
```
postgresql://n8n:n8n_password@localhost:5432/n8n
```

## 常用DataGrid工具连接方法

### 1. DBeaver
1. 新建连接 → PostgreSQL
2. 主机: `localhost`
3. 端口: `5432`
4. 数据库: `n8n`
5. 用户名: `n8n`
6. 密码: `n8n_password`

### 2. pgAdmin
1. 添加服务器
2. 主机: `localhost`
3. 端口: `5432`
4. 维护数据库: `n8n`
5. 用户名: `n8n`
6. 密码: `n8n_password`

### 3. TablePlus (macOS推荐)
1. 新建连接 → PostgreSQL
2. 主机: `127.0.0.1`
3. 端口: `5432`
4. 数据库: `n8n`
5. 用户: `n8n`
6. 密码: `n8n_password`

### 4. DataGrip (JetBrains)
1. 新建数据源 → PostgreSQL
2. 主机: `localhost`
3. 端口: `5432`
4. 数据库: `n8n`
5. 用户: `n8n`
6. 密码: `n8n_password`

### 5. VS Code + PostgreSQL 扩展
1. 安装 PostgreSQL 扩展
2. 添加连接：`postgresql://n8n:n8n_password@localhost:5432/n8n`

## 启动服务

### 首次部署或数据迁移

如果您之前使用过Docker卷存储数据，请先运行迁移脚本：

```bash
# 运行数据迁移脚本
./migrate_data.sh
```

### 正常启动

确保使用更新后的配置启动服务：

```bash
# 停止现有服务（如果正在运行）
docker-compose -f docker-compose.postgres.yml down

# 启动服务
docker-compose -f docker-compose.postgres.yml up -d

# 查看服务状态
docker-compose -f docker-compose.postgres.yml ps
```

## 验证连接

可以使用以下命令验证PostgreSQL是否可以从本地访问：

```bash
# 使用psql命令行工具连接（需要先安装postgresql客户端）
psql -h localhost -p 5432 -U n8n -d n8n

# 或者使用Docker容器内的psql
docker exec -it n8n_postgres psql -U n8n -d n8n
```

## 主要数据表

n8n在PostgreSQL中创建的主要表包括：

- `workflow_entity` - 工作流定义
- `execution_entity` - 执行记录
- `credentials_entity` - 凭证信息
- `webhook_entity` - Webhook配置
- `tag_entity` - 标签
- `workflow_statistics` - 工作流统计
- `execution_metadata` - 执行元数据

## 安全注意事项

1. **生产环境**: 不要在生产环境中暴露数据库端口到公网
2. **密码安全**: 修改默认密码 `n8n_password` 为更安全的密码
3. **网络限制**: 考虑使用防火墙限制数据库访问
4. **SSL连接**: 生产环境建议启用SSL连接

## 故障排除

### 连接被拒绝
- 确保Docker服务正在运行
- 检查端口5432是否被其他服务占用
- 验证Docker容器状态：`docker-compose ps`

### 密码错误
- 确认使用正确的密码：`n8n_password`
- 如果修改了密码，需要重新创建容器

### 数据库不存在
- 等待PostgreSQL完全启动（可能需要几分钟）
- 检查容器日志：`docker-compose logs postgres`

## 备份和恢复

### 备份数据库
```bash
# 备份整个数据库
docker exec -t n8n_postgres pg_dumpall -c -U n8n > n8n_backup.sql

# 备份单个数据库
docker exec -t n8n_postgres pg_dump -c -U n8n n8n > n8n_backup.sql
```

### 恢复数据库
```bash
# 恢复数据库
cat n8n_backup.sql | docker exec -i n8n_postgres psql -U n8n -d n8n
```
