#!/bin/bash

# VPS Docker 部署故障排除脚本
# 解决常见的构建和部署问题

echo "🔧 VPS Docker 部署故障排除..."

# 检查必要目录
check_directories() {
    echo "📁 检查项目目录结构..."

    # 创建必要目录
    mkdir -p public
    mkdir -p src/app
    mkdir -p src/components
    mkdir -p src/lib
    mkdir -p src/types

    # 检查关键文件
    if [ ! -f "package.json" ]; then
        echo "❌ 缺少 package.json 文件"
        exit 1
    fi

    if [ ! -f "Dockerfile" ]; then
        echo "❌ 缺少 Dockerfile 文件"
        exit 1
    fi

    if [ ! -f "docker-compose.yml" ]; then
        echo "❌ 缺少 docker-compose.yml 文件"
        exit 1
    fi

    # 确保 public 目录存在
    if [ ! -d "public" ]; then
        mkdir -p public
        echo "# Public directory for static files" > public/.gitkeep
    fi

    echo "✅ 目录结构检查完成"
}

# 清理 Docker 缓存
clean_docker() {
    echo "🧹 清理 Docker 缓存..."

    # 停止现有容器
    docker-compose down 2>/dev/null || true

    # 删除相关镜像
    docker images | grep dify | awk '{print $3}' | xargs -r docker rmi -f 2>/dev/null || true

    # 清理构建缓存
    docker builder prune -a -f

    echo "✅ Docker 缓存清理完成"
}

# 修复文件权限
fix_permissions() {
    echo "🔐 修复文件权限..."

    # 修复项目目录权限
    sudo chown -R $USER:$USER . 2>/dev/null || chown -R $USER:$USER .

    # 确保脚本可执行
    chmod +x deploy.sh update.sh update-config.sh vps-fix.sh 2>/dev/null || true

    echo "✅ 文件权限修复完成"
}

# 验证 Docker 环境
check_docker() {
    echo "🐳 检查 Docker 环境..."

    if ! command -v docker &> /dev/null; then
        echo "❌ Docker 未安装"
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo "❌ Docker Compose 未安装"
        exit 1
    fi

    # 检查 Docker 服务状态
    if ! docker info &> /dev/null; then
        echo "❌ Docker 服务未启动"
        sudo systemctl start docker
    fi

    echo "✅ Docker 环境检查完成"
}

# 构建测试
test_build() {
    echo "🔨 测试 Docker 构建..."

    # 尝试构建镜像
    if docker-compose build --no-cache; then
        echo "✅ Docker 构建成功"
        return 0
    else
        echo "❌ Docker 构建失败"

        # 显示详细的构建日志
        echo "📋 构建日志："
        docker-compose build --no-cache --progress=plain

        return 1
    fi
}

# 主修复流程
main() {
    echo "🚀 开始修复流程..."

    check_directories
    fix_permissions
    check_docker
    clean_docker

    echo ""
    echo "🔨 尝试重新构建..."
    if test_build; then
        echo ""
        echo "✅ 修复完成！现在可以启动服务："
        echo "   docker-compose up -d"
    else
        echo ""
        echo "❌ 仍有问题，请检查："
        echo "1. 确保所有文件已正确上传"
        echo "2. 检查 VPS 磁盘空间: df -h"
        echo "3. 检查 VPS 内存: free -h"
        echo "4. 手动检查缺失文件"
    fi
}

# 显示帮助信息
show_help() {
    echo "VPS Docker 部署故障排除脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  --clean-only    仅清理 Docker 缓存"
    echo "  --check-only    仅检查环境"
    echo "  --help         显示此帮助信息"
    echo ""
    echo "常见问题解决:"
    echo "  failed to compute cache key: 运行完整修复"
    echo "  permission denied: 运行 --fix-permissions"
    echo "  docker daemon not running: 检查 Docker 服务"
}

# 处理命令行参数
case "${1:-}" in
    --clean-only)
        clean_docker
        ;;
    --check-only)
        check_directories
        check_docker
        ;;
    --help)
        show_help
        ;;
    *)
        main
        ;;
esac