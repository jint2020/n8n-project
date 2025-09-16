# n8n PostgreSQL 配置指南

## 快速开始

### 1. 复制环境变量文件
```bash
cp .env.example .env
```

### 2. 修改配置（重要）
编辑 `.env` 文件，**必须**修改以下安全相关的配置：

```env
# ========== 安全配置（必须修改） ==========
POSTGRES_PASSWORD=your_secure_database_password
N8N_ENCRYPTION_KEY=your-very-long-random-encryption-key-at-least-32-characters
N8N_BASIC_AUTH_USER=your_admin_username
N8N_BASIC_AUTH_PASSWORD=your_secure_admin_password
```

### 3. 启动服务
```bash
docker-compose -f docker-compose.postgres.yml up -d
```

## 配置说明

### 基本服务配置
- `N8N_PORT`: n8n Web界面端口（默认：5678）
- `POSTGRES_PORT`: PostgreSQL数据库端口（默认：5432）

### 数据库配置
- `POSTGRES_DB`: 数据库名称
- `POSTGRES_USER`: 数据库用户名
- `POSTGRES_PASSWORD`: 数据库密码（**必须修改**）

### 安全配置
- `N8N_ENCRYPTION_KEY`: 数据加密密钥（**必须修改为随机字符串**）
- `N8N_BASIC_AUTH_ACTIVE`: 是否启用基本认证（建议：true）
- `N8N_BASIC_AUTH_USER`: 登录用户名
- `N8N_BASIC_AUTH_PASSWORD`: 登录密码（**必须修改**）

### 可选配置
- `WEBHOOK_URL`: 外部访问的Webhook URL
- `N8N_METRICS`: 是否启用指标监控
- `N8N_LOG_LEVEL`: 日志级别（debug, info, warn, error）

## 安全建议

1. **加密密钥生成**：
   ```bash
   # 生成32字符随机密钥
   openssl rand -base64 32
   ```

2. **强密码**：使用复杂的数据库密码和管理员密码

3. **端口配置**：如果不需要外部访问数据库，可以移除PostgreSQL端口映射

## 故障排除

### 查看日志
```bash
# 查看所有服务日志
docker-compose -f docker-compose.postgres.yml logs

# 查看特定服务日志
docker-compose -f docker-compose.postgres.yml logs n8n
docker-compose -f docker-compose.postgres.yml logs postgres
```

### 重置服务
```bash
# 停止服务
docker-compose -f docker-compose.postgres.yml down

# 清理数据（谨慎使用）
docker-compose -f docker-compose.postgres.yml down -v

# 重新启动
docker-compose -f docker-compose.postgres.yml up -d
```

## 访问方式

- **n8n Web界面**：http://localhost:5678
- **数据库连接**：localhost:5432（如果启用端口映射）

默认管理员账户（请在.env中修改）：
- 用户名：admin
- 密码：secure_admin_password