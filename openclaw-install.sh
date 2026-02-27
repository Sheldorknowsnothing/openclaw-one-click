#!/bin/bash
# 你的私人 PaaS：OpenClaw 一键安装脚本
# 功能：自动安装所有环境并启动 OpenClaw

# 颜色输出（让日志更清晰）
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 第一步：更新系统包
echo -e "${YELLOW}[1/6] 正在更新系统依赖...${NC}"
sudo apt update && sudo apt upgrade -y
if [ $? -ne 0 ]; then
    echo -e "${RED}系统更新失败！${NC}"
    exit 1
fi

# 第二步：安装基础工具
echo -e "${YELLOW}[2/6] 正在安装 Git 和编译工具...${NC}"
sudo apt install -y git build-essential curl wget
if [ $? -ne 0 ]; then
    echo -e "${RED}基础工具安装失败！${NC}"
    exit 1
fi

# 第三步：安装 Node.js 20（长期支持版）
echo -e "${YELLOW}[3/6] 正在安装 Node.js 20...${NC}"
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
if [ $? -ne 0 ]; then
    echo -e "${RED}Node.js 安装失败！${NC}"
    exit 1
fi

# 第四步：克隆 OpenClaw 仓库
echo -e "${YELLOW}[4/6] 正在克隆 OpenClaw 代码...${NC}"
cd ~
if [ -d "openclaw" ]; then
    echo -e "${YELLOW}检测到已存在 openclaw 目录，正在更新...${NC}"
    cd openclaw && git pull
else
    git clone https://github.com/openclaw/openclaw.git
    cd openclaw
fi
if [ $? -ne 0 ]; then
    echo -e "${RED}代码克隆失败！${NC}"
    exit 1
fi

# 第五步：安装项目依赖
echo -e "${YELLOW}[5/6] 正在安装 OpenClaw 依赖...${NC}"
npm install
if [ $? -ne 0 ]; then
    echo -e "${RED}依赖安装失败！${NC}"
    exit 1
fi

# 第六步：启动 OpenClaw
echo -e "${GREEN}[6/6] 所有环境安装完成，正在启动 OpenClaw...${NC}"
echo -e "${YELLOW}提示：启动后请按提示配置 API Key，或编辑 ~/.openclaw/openclaw.json${NC}"
npm start

# 脚本结束
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}✅ OpenClaw 一键部署完成！${NC}"
echo -e "${GREEN}📌 项目目录：~/openclaw${NC}"
echo -e "${GREEN}🔧 配置文件：~/.openclaw/openclaw.json${NC}"
echo -e "${GREEN}=====================================${NC}"
