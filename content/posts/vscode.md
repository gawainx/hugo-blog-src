---
title: vscode配置 c++ 开发环境(一):智能提示
date: '2017-02-18 18:48:20'
tags:
- M$
slug: vscode
draft: false
---
#前言
[vscode](https://code.visualstudio.com)是微软推出的跨平台的编辑器, 开发者可以通过丰富的插件把它定制成最适合自己使用的开发环境. 对于我来说,它最吸引的地方之一就是可以为 Mac 还有 Linux 平台提供了与 Visual Studio 类似的智能提示功能.
<!--more-->
# 正文
1. 首先, 下载对应系统的 VScode.
2. 如果是 Mac 系统,那么请安装 xcode 命令行工具,如果是 Linux 系统,请安装clang 编译器.
3. 安装 cpptools 和 C++clang 插件.其中, cpptools 可以提供代码检错等功能,而 IntelliSense 功能,是通过 C++clang 插件实现的.
4. 按` command+,`,打开用户配置文件` setting.json`, 将以下代码拷贝进去.

```json
	{
    	"clang.executable": "/usr/bin/clang++",
    	"clang.completion.enable": true,
    	"clang.completion.triggerChars": [
    	".",
    	":",
    	">"],
  		"clang.cxxflags": ["-std=c++11"]
	}
```
要注意到配置文件是 json 格式,所以,如果之前已经有其它的设置,请按照 json 文件的语法格式将大括号里面的内容拷贝进去.
4. 重启应用程序,即可享受 vscode 带来的智能提示功能了.效果图如下.
![](http://7xpabg.com1.z0.glb.clouddn.com/20170218191445_ChAaV7_Screenshot.jpeg)