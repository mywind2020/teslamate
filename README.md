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

### 微信推送
![微信推送](https://www.teslamate.com.cn/img/extras/extras_2.png)

### 高德地图替代开源地图
- teslamate自带的是开源地图，在国内使用总是有不尽如意的地方，地图信息不详细，不准确，显示效果也不尽如意，字体特别模糊，全是xx路，甚至有时连路都不显示，只能显示到区县。完全不知道在哪里。。
- 高德地图字体清晰，相关信息详细准确，由于是国内服务器，加载速度也大大提高
![高德地图与开源地图对比](https://www.teslamate.com.cn/img/teslamatebox/map_compare.png)

### 地址显示对比

- 下图展示了高德地图与开源地图在地址显示上的区别。高德地图能够显示详细的街道和门牌号信息，而开源地图往往只显示到区县或模糊的路名，无法满足精确定位的需求。
![高德地图与开源地图地址对比](https://www.teslamate.com.cn/img/teslamatebox/address_compare.png)



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
   mkdir -p /opt/teslamate && cd /opt/teslamate
   ```
3. **下载一键安装脚本并安装**
   ```bash
   curl -fsSL http://download.dhuar.com/teslamate/docker/upgrade/install.sh -o install.sh && bash install.sh
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
   curl -fsSL http://download.dhuar.com/teslamate/docker/upgrade/install.sh -o install.sh && bash install.sh
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
  
   
