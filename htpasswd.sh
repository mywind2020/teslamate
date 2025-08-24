#!/bin/bash

echo -n "请输入您要创建用户名："
read USER_NAME 
echo -n "请输入您要创建的密码："
read PASSWD 

echo "用户名为:$USER_NAME，密码为:$PASSWD"

PASSWORD_HASH=$(openssl passwd -apr1 "$PASSWD")

# 创建.htpasswd文件
echo "$USER_NAME:$PASSWORD_HASH" > .htpasswd

echo "密码文件已创建: .htpasswd"

# 检查 web 容器是否在运行
if docker compose ps web | grep -q "Up"; then
    echo "检测到 web 容器正在运行，正在重启..."
    docker compose restart web
    echo "web 容器已重启"
else
    echo "web 容器未运行，无需重启"
fi

