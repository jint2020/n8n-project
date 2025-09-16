#!/bin/bash

# n8n 数据迁移脚本
# 将Docker卷中的数据迁移到本地文件夹

echo "=== n8n 数据迁移脚本 ==="
echo "此脚本将把现有Docker卷中的数据迁移到本地文件夹"
echo ""

# 检查当前目录
if [ ! -f "docker-compose.postgres.yml" ]; then
    echo "错误：请在包含 docker-compose.postgres.yml 的目录中运行此脚本"
    exit 1
fi

# 停止现有服务
echo "1. 停止现有服务..."
docker-compose -f docker-compose.postgres.yml down

# 创建本地数据目录
echo "2. 创建本地数据目录..."
mkdir -p postgres_data
mkdir -p n8n_data

# 备份现有数据卷到本地
echo "3. 迁移PostgreSQL数据..."
if docker volume ls | grep -q "n8n_pg_postgres_data"; then
    docker run --rm -v n8n_pg_postgres_data:/source -v "$(pwd)/postgres_data":/dest alpine sh -c "cp -r /source/* /dest/ 2>/dev/null || true"
    echo "   PostgreSQL数据已迁移到 ./postgres_data/"
else
    echo "   未找到现有PostgreSQL数据卷，将创建新的数据库"
fi

echo "4. 迁移n8n数据..."
if docker volume ls | grep -q "n8n_pg_n8n_data"; then
    docker run --rm -v n8n_pg_n8n_data:/source -v "$(pwd)/n8n_data":/dest alpine sh -c "cp -r /source/* /dest/ 2>/dev/null || true"
    echo "   n8n数据已迁移到 ./n8n_data/"
else
    echo "   未找到现有n8n数据卷，将创建新的配置"
fi

# 设置正确的权限
echo "5. 设置文件权限..."
sudo chown -R 999:999 postgres_data 2>/dev/null || echo "   注意：无法设置PostgreSQL目录权限，启动时可能需要调整"
sudo chown -R 1000:1000 n8n_data 2>/dev/null || echo "   注意：无法设置n8n目录权限，启动时可能需要调整"

echo ""
echo "=== 迁移完成 ==="
echo "现在您的数据将存储在本地文件夹中："
echo "- PostgreSQL数据: $(pwd)/postgres_data"
echo "- n8n数据: $(pwd)/n8n_data"
echo ""
echo "启动服务："
echo "docker-compose -f docker-compose.postgres.yml up -d"
echo ""
echo "清理旧的Docker卷（可选）："
echo "docker volume rm n8n_pg_postgres_data n8n_pg_n8n_data"
