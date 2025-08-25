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

## 🚀 快速开始

### 要求
 - 本文档假定您对linux和docker有一定的了解.
 - 如果有任何问题,可以参考 [TeslaMate中文文档](https://teslamate.com.cn)
### 安装步骤
1. **切换到root** 
    ```bash
   sudo su
   ```
2. **选择文件夹**
   ``` bash
   cd /opt
   ```
3. **创建teslamate文件夹（已存在直接跳过）**
   ```bash
   mkdir -p teslamate
   ```
4. **进入teslamate文件夹**
   ```bash
   cd teslamate
   ```
5. **下载一键安装脚本**
   ```bash
   wget http://download.dhuar.com/teslamate/docker/upgrade/install.sh
   ```
6. **执行一键安装脚本**
   ```bash
   bash install.sh
   ```
7.  **启动服务**
   ```bash
   bash start.sh
   ```
