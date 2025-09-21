#!/bin/bash

# Dify工作流展示网站 - VPS部署脚本
# 使用方法: ./deploy.sh

echo "🚀 开始部署 Dify 工作流展示网站..."

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

# 停止现有容器
echo "🛑 停止现有容器..."
docker-compose down

# 构建新镜像
echo "🔨 构建 Docker 镜像..."
docker-compose build --no-cache

# 启动服务
echo "🎯 启动服务..."
docker-compose up -d

# 检查服务状态
echo "📊 检查服务状态..."
sleep 5
docker-compose ps

# 显示日志
echo "📝 显示服务日志..."
docker-compose logs --tail=20

echo "✅ 部署完成！"
echo "🌐 访问地址: http://您的VPS-IP:3000"
echo "📋 查看日志: docker-compose logs -f"
echo "🛑 停止服务: docker-compose down"