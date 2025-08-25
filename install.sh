#!/bin/bash

# TeslaMate Docker 安装/更新脚本
# 下载并更新必要的脚本文件

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 基础下载URL
BASE_URL="http://download.dhuar.com/teslamate/docker/upgrade"

# 需要下载的脚本文件列表
SCRIPT_FILES=("htpasswd.sh" "start.sh" "stop.sh" "upgrade.sh" "get-docker.sh")

echo -e "${GREEN}=== TeslaMate Docker 安装/更新脚本 ===${NC}"
echo ""

# 下载 yq 工具
echo -e "${YELLOW}检查并下载 yq 工具...${NC}"
if [ ! -f "./yq" ]; then
    echo -n "下载 yq_linux_amd64... "
    
    if command -v curl >/dev/null 2>&1; then
        if curl -fsSL "${BASE_URL}/yq_linux_amd64" -o "yq"; then
            echo -e "${GREEN}成功${NC}"
        else
            echo -e "${RED}失败${NC}"
            echo -e "${RED}错误: 无法下载 yq 工具${NC}"
            exit 1
        fi
    elif command -v wget >/dev/null 2>&1; then
        if wget -qO "yq" "${BASE_URL}/yq_linux_amd64"; then
            echo -e "${GREEN}成功${NC}"
        else
            echo -e "${RED}失败${NC}"
            echo -e "${RED}错误: 无法下载 yq 工具${NC}"
            exit 1
        fi
    else
        echo -e "${RED}错误: 系统中未找到 curl 或 wget，无法下载文件${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}yq 工具已存在${NC}"
fi

# 添加 yq 工具可执行权限
echo -n "添加 yq 工具可执行权限... "
if chmod +x "./yq"; then
    echo -e "${GREEN}成功${NC}"
else
    echo -e "${RED}失败${NC}"
    echo -e "${RED}错误: 无法设置 yq 工具可执行权限${NC}"
    exit 1
fi

# 验证 yq 工具
if ! ./yq --version >/dev/null 2>&1; then
    echo -e "${RED}错误: yq 工具无法正常运行${NC}"
    exit 1
fi

echo ""

# 检查curl或wget是否可用
if command -v curl >/dev/null 2>&1; then
    DOWNLOAD_CMD="curl -fsSL"
    echo -e "${GREEN}使用 curl 进行下载${NC}"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget -qO-"
    echo -e "${GREEN}使用 wget 进行下载${NC}"
else
    echo -e "${RED}错误: 系统中未找到 curl 或 wget，无法下载文件${NC}"
    exit 1
fi

echo ""

# 下载并覆盖脚本文件
echo -e "${YELLOW}正在下载和更新脚本文件...${NC}"
for file in "${SCRIPT_FILES[@]}"; do
    echo -n "下载 ${file}... "
    
    if [[ "$DOWNLOAD_CMD" == "curl -fsSL" ]]; then
        if curl -fsSL "${BASE_URL}/${file}" -o "${file}"; then
            echo -e "${GREEN}成功${NC}"
        else
            echo -e "${RED}失败${NC}"
            echo -e "${RED}警告: 无法下载 ${file}${NC}"
        fi
    else
        if wget -qO "${file}" "${BASE_URL}/${file}"; then
            echo -e "${GREEN}成功${NC}"
        else
            echo -e "${RED}失败${NC}"
            echo -e "${RED}警告: 无法下载 ${file}${NC}"
        fi
    fi
done

echo ""

# 检查 .htpasswd 文件是否存在
echo -e "${YELLOW}检查 .htpasswd 文件...${NC}"
if [ ! -f ".htpasswd" ]; then
    echo "未找到 .htpasswd 文件，正在下载默认密码文件..."
    
    if [[ "$DOWNLOAD_CMD" == "curl -fsSL" ]]; then
        if curl -fsSL "${BASE_URL}/.htpasswd" -o ".htpasswd"; then
            echo -e "${GREEN}默认 .htpasswd 文件下载成功${NC}"
        else
            echo -e "${RED}错误: 无法下载默认 .htpasswd 文件${NC}"
            exit 1
        fi
    else
        if wget -qO ".htpasswd" "${BASE_URL}/.htpasswd"; then
            echo -e "${GREEN}默认 .htpasswd 文件下载成功${NC}"
        else
            echo -e "${RED}错误: 无法下载默认 .htpasswd 文件${NC}"
            exit 1
        fi
    fi
else
    echo -e "${GREEN}.htpasswd 文件已存在，跳过下载${NC}"
fi

# 设置 .htpasswd 文件权限
echo ""
echo -e "${YELLOW}设置 .htpasswd 文件权限...${NC}"
if chmod 666 ".htpasswd"; then
    echo -e "${GREEN}.htpasswd 文件权限已设置为 666${NC}"
else
    echo -e "${RED}警告: 无法设置 .htpasswd 文件权限${NC}"
fi

# 检查 templates 文件夹是否存在
echo ""
echo -e "${YELLOW}检查 templates 文件夹...${NC}"
if [ ! -d "templates" ]; then
    echo "未找到 templates 文件夹，正在创建..."
    if mkdir -p "templates"; then
        echo -e "${GREEN}templates 文件夹创建成功${NC}"
    else
        echo -e "${RED}错误: 无法创建 templates 文件夹${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}templates 文件夹已存在${NC}"
fi

# 下载 default.conf.template 文件
echo ""
echo -e "${YELLOW}下载 default.conf.template 文件...${NC}"
echo -n "下载 templates/default.conf.template... "

if [[ "$DOWNLOAD_CMD" == "curl -fsSL" ]]; then
    if curl -fsSL "${BASE_URL}/templates/default.conf.template" -o "templates/default.conf.template"; then
        echo -e "${GREEN}成功${NC}"
    else
        echo -e "${RED}失败${NC}"
        echo -e "${RED}警告: 无法下载 default.conf.template${NC}"
    fi
else
    if wget -qO "templates/default.conf.template" "${BASE_URL}/templates/default.conf.template"; then
        echo -e "${GREEN}成功${NC}"
    else
        echo -e "${RED}失败${NC}"
        echo -e "${RED}警告: 无法下载 default.conf.template${NC}"
    fi
fi

# 检查 docker-compose.yml 文件是否存在
echo ""
echo -e "${YELLOW}检查 docker-compose.yml 文件...${NC}"
if [ ! -f "docker-compose.yml" ]; then
    echo "未找到 docker-compose.yml 文件，正在下载..."
    
    if [[ "$DOWNLOAD_CMD" == "curl -fsSL" ]]; then
        if curl -fsSL "${BASE_URL}/docker-compose.yml" -o "docker-compose.yml"; then
            echo -e "${GREEN}docker-compose.yml 文件下载成功${NC}"
        else
            echo -e "${RED}错误: 无法下载 docker-compose.yml 文件${NC}"
            exit 1
        fi
    else
        if wget -qO "docker-compose.yml" "${BASE_URL}/docker-compose.yml"; then
            echo -e "${GREEN}docker-compose.yml 文件下载成功${NC}"
        else
            echo -e "${RED}错误: 无法下载 docker-compose.yml 文件${NC}"
            exit 1
        fi
    fi
else
    echo -e "${GREEN}docker-compose.yml 文件已存在${NC}"
    echo -e "${YELLOW}使用 yq 工具安全更新配置...${NC}"
    
    # 备份原文件
    cp "docker-compose.yml" "docker-compose.yml.backup"
    echo "已备份原文件为 docker-compose.yml.backup"
    
    # 使用 yq 更新配置
    echo -n "更新 teslamate 镜像路径... "
    ./yq eval '.services.teslamate.image = "ccr.ccs.tencentyun.com/dhuar/teslamate:latest"' -i docker-compose.yml
    echo -e "${GREEN}完成${NC}"
    
    echo -n "更新 grafana 镜像路径... "
    ./yq eval '.services.grafana.image = "ccr.ccs.tencentyun.com/dhuar/grafana:latest"' -i docker-compose.yml
    echo -e "${GREEN}完成${NC}"
    
    echo -n "更新 mosquitto 镜像路径... "
    ./yq eval '.services.mosquitto.image = "ccr.ccs.tencentyun.com/dhuar/eclipse-mosquitto:2"' -i docker-compose.yml
    echo -e "${GREEN}完成${NC}"
    
    # 移除 teslamate 和 grafana 的 ports 配置
    echo -n "移除 teslamate ports 配置... "
    ./yq eval 'del(.services.teslamate.ports)' -i docker-compose.yml
    echo -e "${GREEN}完成${NC}"
    
    echo -n "移除 grafana ports 配置... "
    ./yq eval 'del(.services.grafana.ports)' -i docker-compose.yml
    echo -e "${GREEN}完成${NC}"
    
    # 添加或覆盖 extras 服务
    echo -n "配置 extras 服务... "
    ./yq eval '.services.extras = {
        "image": "ccr.ccs.tencentyun.com/dhuar/teslamate-extras:latest",
        "environment": [
            "DATABASE_USER=teslamate",
            "DATABASE_PASS=123456", 
            "DATABASE_NAME=teslamate",
            "DATABASE_HOST=database",
            "MQTT_HOST=mosquitto"
        ],
        "volumes": ["teslamate-extras-conf:/app/config"],
        "restart": "always"
    }' -i docker-compose.yml
    echo -e "${GREEN}完成${NC}"
    
    # 添加或覆盖 web 服务
    echo -n "配置 web 服务... "
    ./yq eval '.services.web = {
        "image": "ccr.ccs.tencentyun.com/dhuar/nginx:1.25.2",
        "restart": "always",
        "volumes": [
            "./templates:/etc/nginx/templates",
            "./.htpasswd:/etc/nginx/.htpasswd:ro"
        ],
        "ports": [
            "15000:15000",
            "4000:4000", 
            "3000:3000"
        ],
        "environment": ["NGINX_PORT=80"]
    }' -i docker-compose.yml
    echo -e "${GREEN}完成${NC}"
    
    # 检查并添加必要的 volumes
    echo -n "检查 teslamate-extras-conf volume... "
    if ./yq eval '.volumes | has("teslamate-extras-conf")' docker-compose.yml | grep -q "false"; then
        echo -e "${YELLOW}不存在，正在添加${NC}"
        ./yq eval '.volumes."teslamate-extras-conf".driver = "local"' -i docker-compose.yml
        echo -e "${GREEN}volume 添加完成${NC}"
    else
        echo -e "${GREEN}已存在${NC}"
    fi
    
    echo -e "${GREEN}docker-compose.yml 配置更新完成${NC}"
fi

echo ""
echo -e "${GREEN}=== 安装/更新完成 ===${NC}"
echo ""
echo -e "${YELLOW}提示:${NC}"
echo "- yq 工具已下载并可用于后续的 YAML 处理"
echo "- 所有脚本文件已下载更新 (包括 get-docker.sh)"
echo "- .htpasswd 文件权限已设置为 666"
echo "- templates 文件夹已确保存在"
echo "- default.conf.template 模板文件已更新"
echo "- docker-compose.yml 已使用 yq 工具安全处理："
echo "  * teslamate、grafana、mosquitto 镜像路径已更新"
echo "  * database 镜像版本将在最后进行检查"
echo "  * 已移除 teslamate 和 grafana 的 ports 配置"
echo "  * extras 和 web 服务已配置完成（存在时会覆盖）"
echo "  * extras 服务环境变量将自动从 teslamate 同步"
echo "  * teslamate-extras-conf volume 已确保存在"
echo "- 原 docker-compose.yml 已备份为 docker-compose.yml.backup"
echo "- 您现在可以使用 bash start.sh 启动 TeslaMate"
echo ""

# 最终检查
echo -e "${GREEN}=== 最终检查 ===${NC}"
echo ""

# 同步 extras 环境变量与 teslamate 保持一致
echo -e "${YELLOW}同步 extras 服务环境变量...${NC}"

# 获取 teslamate 的关键环境变量
env_vars_to_sync=("DATABASE_USER" "DATABASE_PASS" "DATABASE_NAME" "DATABASE_HOST" "MQTT_HOST")
sync_completed=true

echo "正在从 teslamate 同步环境变量到 extras..."

for var in "${env_vars_to_sync[@]}"; do
    teslamate_val=$(./yq eval ".services.teslamate.environment[]" docker-compose.yml 2>/dev/null | grep "^${var}=" | cut -d'=' -f2-)
    
    if [ -n "$teslamate_val" ]; then
        echo -n "同步 ${var}=${teslamate_val}... "
        
        # 更新 extras 服务的环境变量
        if ./yq eval ".services.extras.environment |= map(select(. | test(\"^${var}=\") | not)) + [\"${var}=${teslamate_val}\"]" -i docker-compose.yml; then
            echo -e "${GREEN}完成${NC}"
        else
            echo -e "${RED}失败${NC}"
            sync_completed=false
        fi
    else
        echo -e "${YELLOW}⚠ teslamate 中未找到 ${var} 环境变量${NC}"
        sync_completed=false
    fi
done

if [ "$sync_completed" = true ]; then
    echo -e "${GREEN}✓ 所有环境变量已同步完成${NC}"
else
    echo -e "${YELLOW}⚠ 部分环境变量同步可能存在问题${NC}"
fi

echo ""
echo -e "${YELLOW}检查 Docker 位置...${NC}"
if command -v docker >/dev/null 2>&1; then
    docker_path=$(which docker)
    echo -e "${GREEN}✓ Docker 位置: $docker_path${NC}"
    
    # 检查 Docker 是否可执行
    if [ -x "$docker_path" ]; then
        echo -e "${GREEN}✓ Docker 可执行权限正常${NC}"
    else
        echo -e "${RED}⚠ Docker 可执行权限异常${NC}"
    fi
    
    # 检查 Docker 版本
    docker_version=$(docker --version 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Docker 版本: $docker_version${NC}"
    else
        echo -e "${RED}⚠ 无法获取 Docker 版本信息${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Docker 未安装，正在使用阿里云镜像源自动安装...${NC}"
    echo -e "${YELLOW}================================${NC}"
    
    # 检查 get-docker.sh 脚本是否存在
    if [ -f "./get-docker.sh" ]; then
        echo -e "${YELLOW}使用 get-docker.sh 脚本安装 Docker...${NC}"
        if bash get-docker.sh --mirror Aliyun; then
            echo -e "${YELLOW}================================${NC}"
            echo -e "${GREEN}✅ Docker 安装成功！${NC}"
            
            # 启动 Docker 服务
            echo -e "${YELLOW}启动 Docker 服务...${NC}"
            if systemctl start docker; then
                echo -e "${GREEN}✓ Docker 服务启动成功${NC}"
            else
                echo -e "${YELLOW}⚠ Docker 服务启动可能失败，请手动检查${NC}"
            fi
            
            # 重新检查 Docker 位置
            if command -v docker >/dev/null 2>&1; then
                docker_path=$(which docker)
                echo -e "${GREEN}✓ Docker 安装位置: $docker_path${NC}"
                docker_version=$(docker --version 2>/dev/null)
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✓ Docker 版本: $docker_version${NC}"
                fi
            fi
        else
            echo -e "${YELLOW}================================${NC}"
            echo -e "${RED}❌ Docker 安装失败！${NC}"
            echo -e "${YELLOW}请手动安装 Docker 后重试${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ 错误: get-docker.sh 脚本不存在${NC}"
        echo -e "${YELLOW}请确保 get-docker.sh 脚本已正确下载${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${YELLOW}检查 database 镜像版本...${NC}"

# 获取当前 database 镜像
database_image=$(./yq eval '.services.database.image' docker-compose.yml 2>/dev/null)

if [ "$database_image" != "null" ] && [ -n "$database_image" ]; then
    echo "当前 database 镜像: $database_image"
    
    # 提取版本号 (支持不同格式: postgres:17, dhuar/postgres:17, ccr.ccs.tencentyun.com/dhuar/postgres:17)
    version=$(echo "$database_image" | sed -n 's/.*postgres[:-]\([0-9]\+\).*/\1/p')
    
    if [ -n "$version" ] && [ "$version" -ge 17 ] 2>/dev/null; then
        echo -e "${GREEN}✓ PostgreSQL 版本 $version 符合要求 (≥17)${NC}"
        echo ""
        echo -e "${GREEN}🎉 所有检查通过！${NC}"
        echo ""
        echo -e "${YELLOW}是否要重启 TeslaMate 服务以应用新配置？${NC}"
        echo -e "${YELLOW}这将先停止现有服务，然后重新启动。${NC}"
        echo -n "请输入 no 跳过重启，或按回车键确认重启 [Y/n]: "
        read user_input
        
        if [ -z "$user_input" ] || [ "$user_input" = "yes" ] || [ "$user_input" = "YES" ] || [ "$user_input" = "y" ] || [ "$user_input" = "Y" ]; then
            echo ""
            echo -e "${YELLOW}正在重启 TeslaMate 服务...${NC}"
            
            # 检查 Docker 是否已安装
            echo -e "${YELLOW}检查 Docker 安装状态...${NC}"
            if command -v docker >/dev/null 2>&1; then
                echo -e "${GREEN}✓ Docker 已安装${NC}"
                docker_version=$(docker --version)
                echo -e "${GREEN}  Docker 版本: $docker_version${NC}"
            else
                echo -e "${YELLOW}⚠ Docker 未安装，正在使用阿里云镜像源安装...${NC}"
                echo -e "${YELLOW}================================${NC}"
                
                # 检查 get-docker.sh 脚本是否存在
                if [ -f "./get-docker.sh" ]; then
                    echo -e "${YELLOW}使用 get-docker.sh 脚本安装 Docker...${NC}"
                    if bash get-docker.sh --mirror Aliyun; then
                        echo -e "${YELLOW}================================${NC}"
                        echo -e "${GREEN}✅ Docker 安装成功！${NC}"
                        
                        # 启动 Docker 服务
                        echo -e "${YELLOW}启动 Docker 服务...${NC}"
                        if systemctl start docker; then
                            echo -e "${GREEN}✓ Docker 服务启动成功${NC}"
                        else
                            echo -e "${YELLOW}⚠ Docker 服务启动可能失败，请手动检查${NC}"
                        fi
                    else
                        echo -e "${YELLOW}================================${NC}"
                        echo -e "${RED}❌ Docker 安装失败！${NC}"
                        echo -e "${YELLOW}请手动安装 Docker 后重试${NC}"
                        exit 1
                    fi
                else
                    echo -e "${RED}❌ 错误: get-docker.sh 脚本不存在${NC}"
                    echo -e "${YELLOW}请确保 get-docker.sh 脚本已正确下载${NC}"
                    exit 1
                fi
            fi
            
            echo ""
            
            # 先停止服务
            echo -e "${YELLOW}正在停止现有服务...${NC}"
            echo -e "${YELLOW}================================${NC}"
            if bash stop.sh; then
                echo -e "${YELLOW}================================${NC}"
                echo -e "${GREEN}服务停止完成${NC}"
            else
                echo -e "${YELLOW}================================${NC}"
                echo -e "${YELLOW}服务可能未运行或停止时出现问题${NC}"
            fi
            
            echo ""
            
            # 然后启动服务
            echo -e "${YELLOW}正在启动 TeslaMate 服务...${NC}"
            echo -e "${YELLOW}================================${NC}"
            if bash start.sh; then
                echo -e "${YELLOW}================================${NC}"
                echo -e "${GREEN}✅ TeslaMate 已成功启动！${NC}"
            else
                echo -e "${YELLOW}================================${NC}"
                echo -e "${RED}❌ TeslaMate 启动失败，请检查配置或手动启动${NC}"
                echo -e "${YELLOW}您可以尝试手动执行：${NC}"
                echo -e "${GREEN}bash start.sh${NC}"
            fi
        else
            echo ""
            echo -e "${GREEN}已跳过重启操作${NC}"
            echo -e "${YELLOW}配置已更新，您可以稍后手动重启：${NC}"
            echo -e "${GREEN}bash stop.sh${NC}"
            echo -e "${GREEN}bash start.sh${NC}"
        fi
    else
        echo -e "${RED}❌ PostgreSQL 版本检查失败！${NC}"
        echo -e "${YELLOW}当前镜像: $database_image${NC}"
        
        if [ -n "$version" ]; then
            echo -e "${YELLOW}检测到版本: $version${NC}"
            if [ "$version" -lt 17 ] 2>/dev/null; then
                echo ""
                echo -e "${RED}💥 错误: PostgreSQL 版本 $version 过低！${NC}"
                echo -e "${RED}TeslaMate 需要 PostgreSQL 版本 17 或以上${NC}"
                echo ""
                echo -e "${YELLOW}必须执行以下操作才能继续:${NC}"
                echo -e "${YELLOW}1. 手动更新 docker-compose.yml 中的 database 镜像到:${NC}"
                echo -e "${YELLOW}   ccr.ccs.tencentyun.com/dhuar/postgres:17${NC}"
                echo -e "${YELLOW}2. 备份现有数据库数据${NC}"
                echo -e "${YELLOW}3. 进行数据库版本升级或重置数据库${NC}"
                echo -e "${YELLOW}4. 如需重置数据库，可删除旧的 volume:${NC}"
                echo -e "${YELLOW}   docker volume rm teslamate_teslamate-db${NC}"
                echo ""
                echo -e "${RED}⚠️  警告: 在解决数据库版本问题之前，请勿启动 TeslaMate！${NC}"
                echo -e "${RED}注意: 请在升级前仔细阅读 PostgreSQL 升级文档${NC}"
                echo ""
                exit 1
            fi
        else
            echo -e "${RED}❌ 错误: 无法检测 PostgreSQL 版本号${NC}"
            echo -e "${YELLOW}请手动检查镜像标签并确保使用 PostgreSQL 17 或以上版本${NC}"
            echo -e "${YELLOW}推荐镜像: ccr.ccs.tencentyun.com/dhuar/postgres:17${NC}"
            echo ""
            echo -e "${RED}⚠️  警告: 在确认数据库版本之前，请勿启动 TeslaMate！${NC}"
            echo ""
            exit 1
        fi
    fi
else
    echo -e "${RED}❌ 错误: 无法找到 database 服务或镜像配置${NC}"
    echo -e "${RED}请检查 docker-compose.yml 文件中的 database 服务配置${NC}"
    echo ""
    exit 1
fi
