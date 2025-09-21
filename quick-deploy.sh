#!/bin/bash

# 一键部署脚本 - 适用于VPS快速部署
# 使用方法: curl -sSL https://your-repo/quick-deploy.sh | bash

set -e

PROJECT_NAME="dify-showcase"
REPO_URL="https://github.com/your-username/dify-workflow-showcase.git"  # 替换为您的仓库地址
DEPLOY_DIR="/opt/$PROJECT_NAME"

echo "🚀 开始一键部署 Dify 工作流展示网站..."

# 检查是否为root用户
if [[ $EUID -eq 0 ]]; then
   echo "❌ 请不要使用root用户运行此脚本"
   exit 1
fi

# 安装Docker (如果未安装)
install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "📦 安装 Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
        echo "✅ Docker 安装完成"
    else
        echo "✅ Docker 已安装"
    fi
}

# 安装Docker Compose (如果未安装)
install_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        echo "📦 安装 Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo "✅ Docker Compose 安装完成"
    else
        echo "✅ Docker Compose 已安装"
    fi
}

# 克隆或更新代码
deploy_code() {
    if [ -d "$DEPLOY_DIR" ]; then
        echo "📁 更新现有代码..."
        cd $DEPLOY_DIR
        git pull origin main
    else
        echo "📁 克隆代码库..."
        sudo mkdir -p $DEPLOY_DIR
        sudo chown $USER:$USER $DEPLOY_DIR
        git clone $REPO_URL $DEPLOY_DIR
        cd $DEPLOY_DIR
    fi
}

# 部署应用
deploy_app() {
    echo "🔨 构建并启动应用..."
    cd $DEPLOY_DIR

    # 停止现有容器
    docker-compose down 2>/dev/null || true

    # 构建并启动
    docker-compose up -d --build

    # 等待启动
    echo "⏳ 等待应用启动..."
    sleep 10

    # 检查状态
    if docker-compose ps | grep -q "Up"; then
        echo "✅ 应用启动成功！"
        echo "🌐 访问地址: http://$(curl -s ipinfo.io/ip):3000"
    else
        echo "❌ 应用启动失败，请检查日志:"
        docker-compose logs
        exit 1
    fi
}

# 主流程
main() {
    install_docker
    install_docker_compose
    deploy_code
    deploy_app

    echo ""
    echo "🎉 部署完成！"
    echo "📋 常用命令:"
    echo "   查看日志: cd $DEPLOY_DIR && docker-compose logs -f"
    echo "   停止服务: cd $DEPLOY_DIR && docker-compose down"
    echo "   重新部署: cd $DEPLOY_DIR && ./deploy.sh"
}

main "$@"