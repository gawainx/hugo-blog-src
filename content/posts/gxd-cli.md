---
title: gxd-cli is gawainx' docker client
date: '2018-06-27 16:42:27'
tags:
- docker
- go
slug: gxd-cli
draft: false
---
# gxd-cli : 一种快速创建多容器工具

通过 `docker run` 命令行启动容器的时候，配置网络、挂载卷是一件非常麻烦的事，`gxd-cli`将这些麻烦的工作简化成修改配置文件`TOML`达成在不需要记忆繁琐的 docker 命令行参数就能快速启动多容器。

## 功能列表

- 创建多容器，创建每个容器过程可以配置一下选项
  - 挂载卷（支持以`pwd`指代当前路径）
  - 指定容器的网络
  - 自定义容器名
  - 设定容器暴露的端口
- 创建网络
- 快速生成模板文件

## 安装

支持从源码构建，构建之前首先保证系统已经安装`golang`和`dep`
步骤如下:

```shell
git clone git@github.com:gawainx/gxd-cli.git
dep ensure -update
go install
```

安装完毕后在命令行通过`gxd-cli`调用。

## 项目地址

[gawainx/gxd\-cli](https://github.com/gawainx/gxd-cli)
