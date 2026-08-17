---
title: vscode配置 c++ 开发环境(二):调试和头文件设置
date: '2017-10-18 14:28:45'
tags:
- vscode
- Microsoft
- c++
- IDE
slug: vscode2
draft: false
---

# 前言

上次在[vscode配置 c++ 开发环境(一):智能提示](http://antarx.com/2017/02/18/vscode/)文章中介绍了如何在 vscode 中配置 c++语言的智能提示，时间又过了很久，vscode 用的也越来越得心应手，今天终于有机会更新这个系列的第二篇文章，讲讲如何配置`includePath`来避免不愉快的波浪线和怎么用 vscode 对 cpp 程序进行调试。
<!--more-->

# 头文件目录配置

在默认情况下，就算是已经将 cpp 开发相关的插件装好，用 VScode 打开一个 cpp 文件的时候，通常还会看到令人不悦的波浪线，就像下面这样：
![软件找不到头文件时会有波浪线提示](http://7xpabg.com1.z0.glb.clouddn.com/20171018165327_gOFgYN_Screenshot.jpeg)

刚开始的时候我也非常的头疼这个问题，后来在[vscode 官方博客](https://code.visualstudio.com/docs/languages/cpp)的文章中找到了解决方案。

首先，在使用习惯上，要用 vscode 打开源代码所在的文件夹而不是打开单个文件，比如所，我有个`Josephus.cpp`源文件在`cppcode`文件夹下，那么就要在终端上输入`code cppcode` 用 vscode 打开这个文件夹，再对那个源代码文件进行编辑和处理，而避免直接`code Josephus.cpp`打开单个文件。（下面的相关配置都是基于这个使用习惯的基础之上的）

然后，在文件夹下新建`.vscode`目录（如果该目录已经存在，则可以略过这一步）。

在`.vscode`文件夹下，新建`c_cpp_properties.json`json 配置文件，在文件中粘贴以下代码：

```json
{
    "configurations": [
        {
            "name": "Mac",
            "includePath": [
                "/usr/include",
                "/usr/local/include",
                "/usr/include/c++/4.2.1"
                
            ],
            "browse": {
                "limitSymbolsToIncludedHeaders": true,
                "databaseFilename": "",
                "path": [
                    "/usr/include",
                    "/usr/local/include",
                    "${workspaceRoot}"
                ]
            },
            "intelliSenseMode": "clang-x64",
            "macFrameworkPath": [
                "/System/Library/Frameworks",
                "/Library/Frameworks"
            ]
        }
    ],   
    "version": 3
}
```

在这个配置文件中，`includePath`字段是指定 VScode 搜索头文件的目录，如果目录中不存在源代码里引用的头文件，则会有波浪线提示。

所以，将用到的头文件所在的位置都添加到该字段中，就可以解决“波浪线”问题了。

# 调试设置

在 Windows 上面用 VS 进行 C++开发的时候，最吸引人的一个功能是完善的调试功能，类似的功能在 VScode 上也可以实现。

首先，在`.vscode`文件夹下新建 `launch.json`和`tasks.json`两个配置文件，其中，`launch.json`文件是配置调试信息，`tasks.json`是用于配置编译信息。

`tasks.json`文件下，粘贴以下代码：

```json
{
    "version": "0.1.0",
    "command": "clang++",
    "args": ["-g","${file}","-o","${file}.out"],    // 编译命令参数
    "problemMatcher": {
        "owner": "cpp",
        "fileLocation": ["relative", "${workspaceRoot}"],
        "pattern": {
            "regexp": "^(.*):(\\d+):(\\d+):\\s+(warning|error):\\s+(.*)$",
            "file": 1,
            "line": 2,
            "column": 3,
            "severity": 4,
            "message": 5
        }
    }
}
```

上述代码中，`command`字段是编译程序（编译命令），根据个人喜好可以填g++或 clang++（编译 C++），如果想编译 c，也可以填 gcc 或 clang。
`args`字段是编译时添加的指令，`${file}.out`中`${file}`指的是当前编辑文件的文件名。（如果是在 Windows 下面配置，需要写成`${file}.exe`）

`launch.json`文件下，粘贴以下代码：

```json
{
        "version": "0.2.0",
        "configurations": [
            {
                "name": "(lldb) Launch",
                "type": "cppdbg",
                "request": "launch",
                "program": "${file}.out",
                "args": [],
                "stopAtEntry": false,
                "cwd": "${workspaceRoot}",
                "environment": [],
                "externalConsole": true,
                "MIMode": "lldb"
            }
        ]
}
```

`"program": "${file}.out"`字段表示调试的目标程序。

两个文件都配置好之后，打开要调试的 cpp 文件，首先选择“任务”->“运行任务…”,弹出的窗口中选择`clang++`,这一步是编译程序生成.out 文件的过程。

运行完毕后，选择“调试”->”启动调试“或按 F5快捷键，启动调试。如果看到下面这样的界面，表示配置没有问题，进入调试过程。

![调试Josephus.cpp](http://7xpabg.com1.z0.glb.clouddn.com/20171018171618_OX5c5q_Screenshot.jpeg)

# 参考网站

[如何在VSCode内编译运行C++](http://www.jianshu.com/p/d0350f51e87a)