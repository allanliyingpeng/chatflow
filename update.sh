#!/bin/bash

# 快速更新脚本 - 用于更新代码内容
# 使用方法: ./update.sh

echo "🔄 快速更新 Dify 工作流展示网站..."

# 检查是否在项目目录
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ 请在项目根目录运行此脚本"
    exit 1
fi

# 获取更新类型
echo "请选择更新类型："
echo "1) 仅重启容器（配置文件已手动更新）"
echo "2) Git拉取最新代码 + 重启"
echo "3) Git拉取最新代码 + 重新构建"
echo "4) 完整重新部署"

read -p "请输入选项 (1-4): " choice

case $choice in
    1)
        echo "🔄 重启容器..."
        docker-compose restart
        ;;
    2)
        echo "📥 拉取最新代码..."
        git pull origin main
        echo "🔄 重启容器..."
        docker-compose restart
        ;;
    3)
        echo "📥 拉取最新代码..."
        git pull origin main
        echo "🔨 重新构建镜像..."
        docker-compose up -d --build
        ;;
    4)
        echo "🔨 完整重新部署..."
        ./deploy.sh
        ;;
    *)
        echo "❌ 无效选项"
        exit 1
        ;;
esac

# 等待服务启动
sleep 5

# 检查服务状态
echo "📊 检查服务状态..."
docker-compose ps

# 显示访问地址
if docker-compose ps | grep -q "Up"; then
    LOCAL_IP=$(hostname -I | awk '{print $1}')
    PUBLIC_IP=$(curl -s ipinfo.io/ip 2>/dev/null || echo "获取失败")
    echo ""
    echo "✅ 更新完成！"
    echo "🌐 本地访问: http://$LOCAL_IP:3000"
    echo "🌐 公网访问: http://$PUBLIC_IP:3000"
    echo ""
    echo "📋 查看日志: docker-compose logs -f"
else
    echo "❌ 服务启动失败，请检查日志："
    docker-compose logs --tail=20
fi