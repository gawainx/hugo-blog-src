---
title: 使用mage实现交叉编译
date: '2018-04-23 11:17:36'
tags:
- golang
slug: mage2
draft: false
---
golang 为微服务的开发带来了无可比拟的便利。使用的时候也自然而言发现一些问题，因为 golang 不像 Java 有 Maven 这样的打包工具，而是直接编译成二进制可执行文件，所以在开发机（macOS）上编译出来的可执行文件是无法在服务器或者 docker 容器里运行的，如果把源代码提交上去服务器编译，又会带来重新下载依赖包的麻烦（golang 的包依赖关系管理方面的缺失是我认为 golang 为数不多的缺点之一）。最近一直在思考有没有类似 Makefile 的方式来解决这件事（如果只想交叉编译的话直接用 go build或者借助 [gox](https://github.com/mitchellh/gox) 等工具也不是不可以，可还是，不够方便）。直到之前 ing 大神给我推荐了 Hugo 这个静态博客框架，虽然目前因为找不到合适的博客主题没有从 hexo 迁移过去，但看源代码的时候有了一个重要的收获，就是[mage](https://magefile.org)
关于 mage 的基本安装和使用详见[mage 使用教程(一)]()
<!--more-->

## golang 交叉编译的基本原理

交叉编译的实现主要是依靠三个参数，`CGO_ENABLE`,`GOOS`,`GOARCH`
`CGO_ENABLE`在源代码中使用 C/C++时必须开启，这样就无法实现交叉编译了，这部分代码还是得具体平台生成特定的代码。因此，交叉编译是在没有混编代码的前提下的。将`CGO_ENABLE`设为0，表示关闭。
`GOOS`是目标操作系统，macOS 对应的是`darwin`，Linux 平台对应的是`linux`。
`GOARCH`是目标架构，一般设为`amd64`
按照如上所述设定要编译参数之后再执行`go build`即可生成目标平台的代码。

## 实现

```go
// +build mega
// magefile.go
func Linux(){
	//设置环境变量
    var e= make(map[string]string)
	e["CGO_ENABLE"] = "0"
	e["GOOS"] = "linux"
	e["GOARCH"] = "amd64"
	name := fmt.Sprintf("%s-linux-%s",prefix,VERSION)
	//创建 bin 文件夹
	if err := os.Mkdir("bin", 0700); err != nil && !os.IsExist(err) {
		fmt.Errorf("failed to create %s: %v", "bin", err)
		os.Exit(1)
	}
	path := filepath.Join("bin",name)
	fmt.Println("Building app for linux...")
	//运行构建命令
	err := sh.RunWith(e,"go","build","-o",path,"main.go","utils.go","RESTHandler.go","module.go")
	if err != nil{
		fmt.Println(err)
		return
	}
	fmt.Printf("Sucessfully Built.Output File: %s\n",path)
}
```

在magefile所在文件夹输入 `mage linux` 即可编译生成适用于 Linux 的运行文件。