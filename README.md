# TeslaMate中文版

[![Docker](https://img.shields.io/badge/Docker-Required-blue.svg)](https://www.docker.com/)
[![TeslaMate](https://img.shields.io/badge/TeslaMate-Latest-green.svg)](https://github.com/adriankumpf/teslamate)


## 📖 项目简介

TeslaMate中文版修正了TeslaMate在国内使用的各种问题,并添加了大量本地化功能
- 专为手机屏幕优化过的界面，可在手机直接访问车辆数据
- 微信公众号实时推送行程和充电等消息
- 大部分页面中文化
- 使用高德地图替换原有的开源地图，可以显示精确的位置信息，而不是xx路
- 为TeslaMate添加了安全认证功能,防止数据泄露

## 相关界面
### 手机访问支持
![TeslaMate中文版界面](https://www.teslamate.com.cn/img/extras/extras_1.png)


## 🚀 快速开始

### 要求
 - 本脚本可以用于全新安装
 - 也可以用于已安装teslamate的情况下升级到teslamate中文版.
 - 如果有任何问题,可以参考 [TeslaMate中文文档](https://teslamate.com.cn)
### 全新安装
1. **切换到root** 
    ```bash
   sudo su
   ```
2. **创建teslamate文件夹**
   ```bash
   mkdir -p /opt/teslamate && cd teslamate
   ```
3. **下载一键安装脚本并安装**
   ```bash
   wget http://download.dhuar.com/teslamate/docker/upgrade/install.sh -O install.sh && bash install.sh
   ```
### 已有TeslaMate,升级到中文版
1. **切换到root** 
    ```bash
   sudo su
   ```
2. **进入teslamate文件夹**
   ```bash
   cd /opt/teslamate
   ```
3. **下载一键安装脚本并执行**
   ```bash
   wget http://download.dhuar.com/teslamate/docker/upgrade/install.sh -O install.sh && bash install.sh
   ```

### 如何使用
详细使用方法请参考文档：[https://www.teslamate.com.cn/docs/installation/auto#用法](https://www.teslamate.com.cn/docs/installation/auto#用法)

### 微信绑定
浏览器访问 http://ip:15000 (将ip替换成服务器ip) ,页面上有二维码,直接扫码绑定后即可在公众号内访问和接收消息推送.
默认的用户名密码都是admin

### 修改密码
   ```bash
   bash htpasswd.sh
   ```
 grafana的密码自行在网页内修改
  
   