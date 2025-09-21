# Dify 工作流展示网站

一个现代化的 Dify 工作流集成展示平台，基于 Next.js 14 构建，支持响应式设计和 Docker 容器化部署。

## ✨ 特性

- 🎨 **现代化 UI** - 基于 shadcn/ui 组件库和 Tailwind CSS
- 📱 **响应式设计** - 完美适配桌面端和移动端
- 🌙 **主题切换** - 支持亮色/暗色主题自动切换
- 🔗 **灵活集成** - 支持 iframe 嵌入和新标签页打开
- 🐳 **容器化部署** - 完整的 Docker 部署方案
- ⚡ **性能优化** - Next.js 14 App Router + 生产环境优化

## 🚀 快速开始

### 本地开发

1. **克隆项目**
   ```bash
   git clone <your-repository>
   cd dify工作展示
   ```

2. **安装依赖**
   ```bash
   npm install
   ```

3. **启动开发服务器**
   ```bash
   npm run dev
   ```

4. **访问应用**
   打开浏览器访问 [http://localhost:3000](http://localhost:3000)

## 🐳 VPS Docker 部署

### 环境要求

**最低配置**:
- CPU: 1核
- 内存: 1GB
- 存储: 5GB
- 系统: Ubuntu 18.04+ / CentOS 7+ / Debian 9+

**软件依赖**:
- Docker 20.10+
- Docker Compose 1.29+
- Git（可选）

### 一、准备VPS环境

#### 1.1 连接到VPS
```bash
ssh 用户名@您的VPS-IP
```

#### 1.2 更新系统并安装必要工具
```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git unzip

# CentOS/RHEL
sudo yum update -y
sudo yum install -y curl wget git unzip
```

#### 1.3 安装Docker
```bash
# 下载并运行Docker安装脚本
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 将用户添加到docker组
sudo usermod -aG docker $USER

# 清理安装脚本
rm get-docker.sh
```

#### 1.4 安装Docker Compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

#### 1.5 启动Docker服务
```bash
sudo systemctl start docker
sudo systemctl enable docker

# 验证安装
docker --version
docker-compose --version
```

**⚠️ 重要**: 重新登录VPS让用户组权限生效
```bash
exit
ssh 用户名@您的VPS-IP
```

### 二、部署应用

#### 2.1 上传代码（选择其中一种方式）

**方式A: SCP上传（推荐）**
```bash
# 在本地执行
scp -r ./dify工作展示/* 用户名@VPS-IP:/tmp/dify-showcase/

# 在VPS执行
sudo mkdir -p /opt/dify-showcase
sudo mv /tmp/dify-showcase/* /opt/dify-showcase/
sudo chown -R $USER:$USER /opt/dify-showcase
```

**方式B: Git克隆**
```bash
cd /opt
sudo mkdir -p dify-showcase
sudo chown -R $USER:$USER dify-showcase
git clone https://github.com/您的用户名/项目名.git dify-showcase
```

#### 2.2 执行部署
```bash
cd /opt/dify-showcase

# 设置执行权限
chmod +x deploy.sh update.sh update-config.sh

# 运行部署脚本
./deploy.sh
```

#### 2.3 配置防火墙
```bash
# Ubuntu/Debian
sudo ufw allow 22    # SSH
sudo ufw allow 3000  # 应用端口
sudo ufw enable

# CentOS/RHEL
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

#### 2.4 验证部署
```bash
# 检查容器状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 测试访问
curl http://localhost:3000
```

**🌐 访问地址**: `http://您的VPS-IP:3000`

### 三、生产环境部署（使用Nginx）

如果需要使用标准的80端口和更好的性能：

```bash
cd /opt/dify-showcase

# 停止开发环境
docker-compose down

# 启动生产环境
docker-compose -f docker-compose.prod.yml up -d

# 配置防火墙
sudo ufw allow 80
sudo ufw allow 443
```

**🌐 访问地址**: `http://您的VPS-IP` (无需端口号)

## 🔄 网站更新方法

### 快速更新脚本

项目提供了多种更新方式，根据修改内容选择合适的方法：

#### 方法1: 智能更新脚本（推荐）
```bash
cd /opt/dify-showcase
./update.sh
```

选择更新类型：
- `1` - 仅重启容器（配置已手动更新）
- `2` - Git拉取 + 重启（推荐）
- `3` - Git拉取 + 重新构建
- `4` - 完整重新部署

#### 方法2: 配置文件快速更新
```bash
# 直接编辑配置
./update-config.sh

# 或指定新配置文件
./update-config.sh /path/to/new/workflows.ts
```

#### 方法3: 一行命令更新

**最快速（仅重启）**:
```bash
docker-compose restart
```

**中等速度（拉取代码+重启）**:
```bash
git pull origin main && docker-compose restart
```

**完整重构**:
```bash
docker-compose up -d --build
```

### 更新流程详解

#### 📝 修改工作流配置

1. **本地修改**
   ```bash
   # 编辑 src/lib/workflows.ts 文件
   nano src/lib/workflows.ts
   ```

2. **上传到VPS**
   ```bash
   scp src/lib/workflows.ts user@vps:/opt/dify-showcase/src/lib/
   ```

3. **应用更新**
   ```bash
   cd /opt/dify-showcase
   docker-compose restart
   ```

#### 🔧 修改其他代码文件

1. **使用Git方式**
   ```bash
   # 本地提交
   git add .
   git commit -m "更新描述"
   git push origin main

   # VPS更新
   cd /opt/dify-showcase
   git pull origin main
   docker-compose restart
   ```

2. **使用文件上传**
   ```bash
   # 批量上传文件
   rsync -av --exclude node_modules --exclude .git ./src/ user@vps:/opt/dify-showcase/src/

   # 重启服务
   docker-compose restart
   ```

#### 🏗️ 添加新依赖或大版本更新

```bash
cd /opt/dify-showcase
git pull origin main  # 如果使用Git
docker-compose up -d --build  # 重新构建镜像
```

## ⚙️ 工作流配置

### 配置文件位置
`src/lib/workflows.ts`

### 配置示例
```typescript
export const workflows: WorkflowConfig[] = [
  {
    id: 'vps-knowledge',
    title: 'VPS知识库',
    description: '记录常用的脚本和密码，VPS管理相关的知识库助手',
    difyUrl: 'http://dify.sop.design/chatbot/5xviFcRKCkWM1EWD',
    category: 'assistant',
    tags: ['VPS', '密码', '脚本'],
    openMode: 'modal'
  },
  // 添加更多工作流...
]
```

### 配置字段说明
- `id`: 唯一标识符
- `title`: 工作流标题
- `description`: 工作流描述
- `difyUrl`: Dify 工作流的完整URL
- `category`: 分类标签（影响卡片颜色）
- `tags`: 标签数组（显示在卡片底部）
- `openMode`: 打开方式
  - `modal`: 弹窗模式（推荐）
  - `new_tab`: 新标签页

### 获取Dify URL
1. 打开Dify工作台
2. 选择您的应用
3. 点击"发布" → "Web应用"
4. 复制生成的URL

## 🛠️ 管理命令

### 服务管理
```bash
# 查看服务状态
docker-compose ps

# 查看实时日志
docker-compose logs -f

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看资源使用
docker stats
```

### 故障排除
```bash
# 查看容器详细信息
docker-compose ps -a

# 查看最近20行日志
docker-compose logs --tail=20

# 重新构建并启动
docker-compose up -d --build

# 清理未使用的Docker资源
docker system prune -a
```

### 备份和恢复
```bash
# 备份配置
tar -czf backup-$(date +%Y%m%d).tar.gz src/lib/workflows.ts

# 备份整个项目
tar -czf dify-showcase-backup-$(date +%Y%m%d).tar.gz /opt/dify-showcase
```

## 🔒 安全配置

### 防火墙配置
```bash
# Ubuntu/Debian
sudo ufw status
sudo ufw allow 22      # SSH
sudo ufw allow 80      # HTTP
sudo ufw allow 443     # HTTPS
sudo ufw deny 3000     # 如果使用Nginx，关闭直接访问

# CentOS/RHEL
sudo firewall-cmd --list-all
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### SSL证书配置（可选）
1. 获取域名和SSL证书
2. 将证书文件放到 `./ssl/` 目录
3. 编辑 `nginx.prod.conf` 配置HTTPS
4. 重启服务：`docker-compose -f docker-compose.prod.yml up -d`

## 📁 项目结构

```
├── src/
│   ├── app/                 # Next.js App Router
│   │   ├── globals.css     # 全局样式
│   │   ├── layout.tsx      # 根布局
│   │   └── page.tsx        # 主页面
│   ├── components/         # React 组件
│   │   ├── ui/            # shadcn/ui 基础组件
│   │   ├── header.tsx     # 头部组件
│   │   ├── theme-provider.tsx
│   │   ├── theme-toggle.tsx
│   │   └── workflow-card.tsx
│   ├── lib/               # 工具函数和配置
│   │   ├── utils.ts       # 通用工具函数
│   │   └── workflows.ts   # 工作流配置 ⭐
│   └── types/             # TypeScript 类型定义
│       └── workflow.ts
├── deploy.sh              # 一键部署脚本 ⭐
├── update.sh              # 智能更新脚本 ⭐
├── update-config.sh       # 配置更新脚本 ⭐
├── docker-compose.yml     # 基础Docker配置
├── docker-compose.prod.yml # 生产环境配置
├── Dockerfile            # Docker构建文件
├── nginx.prod.conf       # Nginx配置
└── README.md             # 本文档
```

## 🛠️ 开发指南

### 可用脚本
```bash
npm run dev          # 开发模式
npm run build        # 构建生产版本
npm run start        # 启动生产服务器
npm run lint         # 代码检查
npm run type-check   # 类型检查
```

### 技术栈
- **框架**: Next.js 14 (App Router)
- **语言**: TypeScript
- **样式**: Tailwind CSS
- **组件库**: shadcn/ui
- **图标**: Lucide React
- **主题**: next-themes

### 自定义主题
项目支持亮色/暗色主题切换。您可以在 `src/app/globals.css` 中自定义主题变量：

```css
:root {
  --background: 0 0% 100%;
  --foreground: 222.2 84% 4.9%;
  /* 更多主题变量... */
}

.dark {
  --background: 222.2 84% 4.9%;
  --foreground: 210 40% 98%;
  /* 暗色主题变量... */
}
```

## 📖 使用说明

1. **浏览工作流**: 在主页面浏览所有可用的工作流卡片
2. **查看详情**: 点击卡片查看工作流的详细信息
3. **体验工作流**:
   - 模态框模式：在页面内的弹窗中体验工作流
   - 新标签页模式：在新标签页中打开工作流
4. **主题切换**: 使用右上角的主题切换按钮

## 🚨 常见问题

### Q: 端口被占用怎么办？
```bash
sudo netstat -tlnp | grep :3000
sudo kill -9 PID
```

### Q: 权限问题怎么解决？
```bash
sudo chown -R $USER:$USER /opt/dify-showcase
```

### Q: 服务启动失败？
```bash
# 查看详细日志
docker-compose logs

# 检查防火墙
sudo ufw status
```

### Q: 如何备份数据？
```bash
# 备份配置
cp src/lib/workflows.ts ~/workflows-backup.ts

# 完整备份
tar -czf backup.tar.gz /opt/dify-showcase
```

## 🎯 性能优化

### Docker优化
```yaml
# 在docker-compose.yml中添加
deploy:
  resources:
    limits:
      memory: 512M
    reservations:
      memory: 256M
```

### 监控命令
```bash
# 查看资源使用
docker stats

# 查看磁盘使用
df -h

# 查看内存使用
free -h
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 🙏 致谢

- [Next.js](https://nextjs.org/) - React 框架
- [Tailwind CSS](https://tailwindcss.com/) - CSS 框架
- [shadcn/ui](https://ui.shadcn.com/) - 组件库
- [Lucide](https://lucide.dev/) - 图标库

---

## 📞 技术支持

如果在部署或使用过程中遇到问题：

1. 查看本文档的常见问题部分
2. 检查 `docker-compose logs` 日志输出
3. 确认防火墙和网络配置
4. 提交 GitHub Issue

**祝您使用愉快！** 🎉