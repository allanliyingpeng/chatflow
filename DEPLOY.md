# VPS Docker 部署指南

## 🚀 快速部署（推荐）

### 方法一：直接上传部署

1. **上传代码到VPS**
   ```bash
   # 在VPS上创建目录
   mkdir -p /opt/dify-showcase
   cd /opt/dify-showcase

   # 上传项目文件（使用scp、rsync或git）
   # 例如：scp -r ./dify工作展示/* user@your-vps-ip:/opt/dify-showcase/
   ```

2. **运行部署脚本**
   ```bash
   cd /opt/dify-showcase
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **访问网站**
   ```
   http://您的VPS-IP:3000
   ```

### 方法二：Git克隆部署

1. **将代码推送到Git仓库**（GitHub/GitLab等）

2. **在VPS上克隆并部署**
   ```bash
   git clone https://github.com/您的用户名/项目名.git /opt/dify-showcase
   cd /opt/dify-showcase
   chmod +x deploy.sh
   ./deploy.sh
   ```

## 🛠️ 部署选项

### 基础部署（仅应用）
```bash
docker-compose up -d
```
- 访问端口：3000
- 适用于：测试环境、内网使用

### 生产部署（应用+Nginx）
```bash
docker-compose -f docker-compose.prod.yml up -d
```
- 访问端口：80 (HTTP) / 443 (HTTPS)
- 适用于：生产环境、公网访问

## ⚙️ 环境要求

### VPS最低配置
- **CPU**: 1核
- **内存**: 1GB
- **存储**: 5GB
- **系统**: Ubuntu 18.04+ / CentOS 7+ / Debian 9+

### 软件依赖
- Docker 20.10+
- Docker Compose 1.29+
- Git（如果使用Git部署）

## 📝 部署步骤详解

### 1. 准备VPS环境

```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装必要工具
sudo apt install -y curl wget git

# 安装Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# 安装Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 重新登录以应用Docker组权限
logout
```

### 2. 部署应用

```bash
# 上传或克隆项目代码
cd /opt/dify-showcase

# 构建并启动
docker-compose up -d --build

# 查看状态
docker-compose ps
```

### 3. 配置域名（可选）

如果您有域名，编辑 `nginx.prod.conf`：
```nginx
server_name your-domain.com;  # 替换为您的域名
```

然后使用生产配置：
```bash
docker-compose -f docker-compose.prod.yml up -d
```

## 🔧 常用命令

```bash
# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down

# 重新构建
docker-compose up -d --build

# 查看容器状态
docker-compose ps

# 进入容器
docker-compose exec dify-showcase sh

# 更新代码并重新部署
git pull origin main
./deploy.sh
```

## 🔒 安全配置

### 防火墙设置
```bash
# Ubuntu/Debian
sudo ufw allow 22      # SSH
sudo ufw allow 80      # HTTP
sudo ufw allow 443     # HTTPS
sudo ufw enable

# CentOS/RHEL
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### SSL证书配置（可选）
1. 获取SSL证书（Let's Encrypt推荐）
2. 将证书文件放到 `./ssl/` 目录
3. 编辑 `nginx.prod.conf` 启用HTTPS配置
4. 重新启动：`docker-compose -f docker-compose.prod.yml up -d`

## 🚨 故障排除

### 常见问题

1. **端口被占用**
   ```bash
   sudo netstat -tlnp | grep :3000
   sudo kill -9 PID
   ```

2. **权限问题**
   ```bash
   sudo chown -R $USER:$USER /opt/dify-showcase
   ```

3. **Docker权限问题**
   ```bash
   sudo usermod -aG docker $USER
   # 重新登录
   ```

4. **内存不足**
   ```bash
   # 创建swap文件
   sudo fallocate -l 1G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   ```

### 查看详细日志
```bash
# 应用日志
docker-compose logs dify-showcase

# Nginx日志（如果使用）
docker-compose logs nginx

# 系统资源使用
docker stats
```

## 📊 监控和维护

### 自动重启配置
Docker Compose已配置 `restart: unless-stopped`，服务会自动重启。

### 日志清理
```bash
# 清理Docker日志
docker system prune -a

# 设置日志大小限制（在docker-compose.yml中）
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

### 定期备份
```bash
# 备份配置文件
tar -czf backup-$(date +%Y%m%d).tar.gz src/lib/workflows.ts nginx.conf
```

## 🎯 性能优化

### 内存优化
在 `docker-compose.yml` 中添加：
```yaml
deploy:
  resources:
    limits:
      memory: 512M
    reservations:
      memory: 256M
```

### 缓存优化
Nginx已配置静态文件缓存，无需额外配置。

---

## 📞 技术支持

如果遇到问题，请检查：
1. VPS系统日志：`journalctl -u docker`
2. 应用日志：`docker-compose logs`
3. 网络连接：`curl -I http://localhost:3000`

祝您部署成功！🎉