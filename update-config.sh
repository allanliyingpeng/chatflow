#!/bin/bash

# 工作流配置快速更新脚本
# 使用方法: ./update-config.sh [workflows.ts文件路径]

CONFIG_FILE="src/lib/workflows.ts"

echo "⚡ 快速更新工作流配置..."

# 如果提供了参数，使用参数作为源文件
if [ "$1" ]; then
    if [ -f "$1" ]; then
        echo "📁 从 $1 复制配置文件..."
        cp "$1" "$CONFIG_FILE"
    else
        echo "❌ 文件 $1 不存在"
        exit 1
    fi
else
    echo "📝 当前配置文件: $CONFIG_FILE"
    echo "💡 提示: 您可以直接编辑此文件，或者使用: ./update-config.sh 新文件路径"

    # 询问是否要编辑文件
    read -p "是否要编辑配置文件? (y/N): " edit_choice
    if [[ $edit_choice =~ ^[Yy]$ ]]; then
        # 检查可用的编辑器
        if command -v nano &> /dev/null; then
            nano "$CONFIG_FILE"
        elif command -v vim &> /dev/null; then
            vim "$CONFIG_FILE"
        else
            echo "❌ 未找到文本编辑器 (nano/vim)"
            exit 1
        fi
    fi
fi

# 验证文件语法
echo "🔍 验证配置文件语法..."
if node -c "$CONFIG_FILE" 2>/dev/null; then
    echo "✅ 配置文件语法正确"
else
    echo "❌ 配置文件语法错误，请检查"
    exit 1
fi

# 重启容器
echo "🔄 重启应用容器..."
docker-compose restart dify-showcase

# 等待启动
echo "⏳ 等待服务启动..."
sleep 3

# 检查状态
if docker-compose ps | grep dify-showcase | grep -q "Up"; then
    echo "✅ 配置更新完成！"
    echo "🌐 请刷新浏览器页面查看更新"
else
    echo "❌ 服务重启失败，查看日志："
    docker-compose logs --tail=10 dify-showcase
fi