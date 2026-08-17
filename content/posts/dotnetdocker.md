---
title: macOS下使用 docker 进行 CSharp 开发（一）
date: '2017-08-27 18:46:52'
tags:
- docker
slug: dotnetdocker
draft: false
---
# 前言
过去一年多时间里一直忙着准备考研、OJ、毕设这些东西，都没时间在微软的技术方面进行更深入的学习。现在很多事情都尘埃落定之后，终于可以重操旧业继续传教之路。因为研究生研究的方向跟 docker 有些关系，自己也觉得这玩意挺有意思的。所以，以后的一大段时间里都会探索.net 跟 docker 的结合的相关应用。这一系列文章如果没有特别说明，都是以 macOS 为主要的开发环境，也算是为微软的跨平台大业添砖加瓦了。

这篇算是一个起点，探讨在 macOS 环境下进行开发的相关配置。
<!--more-->

# 安装 Docker 环境
现在在 macOS 上安装 docker 已经没有以前那么复杂了。基本上就是下载 dmg 文件回来拖拖鼠标的事儿。在毕设那段时间的体验中，甚至觉得在 macOS 上安装 Docker 是最为简便快捷，很难出什么幺蛾子的。：）

下载地址：[Docker 官网](https://www.docker.com/get-docker)
经测试现在不用翻墙就可以访问啦。
要下载镜像的话还是配置加速器会比较快一些，我自己是配了阿里云提供的一个加速器地址。注册阿里云账号之后会免费提供。

# 下载 dotnet 镜像
运行命令
```shell
    docker pull microsoft/dotnet
```
默认下载的是 latest 版本。

# 基于镜像运行容器

在开发中我的习惯是将源代码放到本地的文件夹中，然后将这个文件夹挂载到 Docker 容器里面，这样在本地就可以用自己熟悉的环境对源代码各种修改，容器那边只需要重启一下就会自动运行新版本的代码，十分方便。

运行以下命令：
```shell
    docker run -it -v `pwd`:/csharp -w /csharp microsoft/dotnet
```
命令中通过`-it`开启了实时交互模式，只是因为在家里没梯子，下载 dotnet core 的 SDK 贼慢，只好采取此方法。
实际应用的时候可以在本地 shell 先建立好项目编辑完源代码直接甩容器里跑最方便的。

# 新建项目、编辑代码、运行
运行容器之后，在容器弹出的交互界面中，输入
```shell
    dotnet new console -o hwapp
```
命令的基本含义是以控制台为模板新建一个名为`hwapp`的项目。
在本机，用 vscode 打开工作目录下的 Program.cs 源文件，编辑代码，本次以输出“hello docker‘为例。
编辑完代码，保存之后，在容器的终端中运行`dotnet run`运行项目。
![运行结果](http://7xpabg.com1.z0.glb.clouddn.com/20170827192813_U1a7uG_Snip20170827_3.jpeg)

//忽略第一次那个白痴错误（汗

# 后记
到此为止，在 macOS 下用 Docker 运行.net 程序的第一次尝试就完成了。要补充的内容还有很多，比如配置 vscode 开发环境等等工作，也只能等到回校有畅快的开发环境再慢慢补完了。