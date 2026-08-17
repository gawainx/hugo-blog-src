---
title: Cygwin安装独立的pip环境
date: '2015-12-25 18:37:31'
tags:
- Python
categories: 
description: 
slug: cygpy
draft: false
---
# 前言
在Windows下配置python的虚拟环境时常常会遇到各种各样的问题。所幸Windows平台下有Cygwin这个虚拟Linux的环境。在cygwin下安装了独立的Python环境后，再安装pip，即可通过`pip install virtualenv`命令安装Python虚拟环境，之后通过虚拟环境安装Flask，Django等网络开发环境就可以一气呵成了。
# 安装步骤
1. 首先，安装Cygwin并在软件包选择页面选择安装Python软件包。
2. 前往[Get Pip](https://pip.pypa.io/en/latest/installing.html)下载get-pip.py文件到cygwin的home目录.
3. 在Cygwin命令行环境下进行pip的安装。执行`python get-pip.py`命令即可。
4. 安装完毕之后，关闭Cygwin交互环境再打开，就可以进行虚拟环境的安装了。
# pip安装成功的标志
**注意**: 直接输入pip命令没有提示`command not found`并不能说明pip被成功安装在cygwin的python运行环境下。如果Windows下也存在Python和pip的话，在Cygwin命令行输入pip会直接调用Windows平台下的`pip`命令。

可行的判断方法如下：（以下命令均在Cygwin交互环境下输入）
1. 命令行输入`which pip`返回的结果为'/usr/bin/pip'
2. 命令行输入`pip -V`返回的结果为`pip 1.5.6 from /usr/lib/python2.7/site-packages (python 2.7)`

至此，Cygwin下独立的pip环境已经配置完毕，之后就可以安装Linux下配置Flask，Pyramid或者Django环境的办法愉快的玩耍了。
