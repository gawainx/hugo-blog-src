---
title: mage 使用教程(一)
date: '2018-04-23 10:24:36'
tags:
- golang
slug: mage1
draft: false
---

Mage 是使用 golang 开发的类 Make的软件构建工具。借助这个工具只需要编写符合 golang 语言规范的代码就可以实现比较复杂的源代码编译。
<!--more-->

## 安装

安装 mage 之前首先要安装 golang1.7或以上版本。安装好之后，执行以下代码

```shell
go get -u -d github.com/magefile/mage
cd $GOPATH/src/github.com/magefile/mage
go run bootstrap.go
```

编译完成之后，名为 mage 的可执行文件放在`$GOPATH/bin`目录下，将`$GOPATH/bin`加入到系统路径即可在终端中直接输入`mage`运行软件。

## 第一个 Magefile

Magefile 实质是符合 golang 语法的源代码，并且加入了特定的注记，规则如下：

1. 在包名之前加入一行，`// +build mage`
2. 包名必须为 `main`
3. 每个可导出函数会变成可被 mage 执行的选项（类似 Makefile 的每一个 tag）
4. 每个可导出函数前的注释会被转换成帮助文档
5. 文件名可以但不一定必须是 Magefile.go

在任意目录输入`mage -init`可以生成Magefile.go 模板代码。
可以输入以下代码实验以上规则

```go
// +build mage
package main
import(
    "fmt"
    "log"
)
//Build
func Build(){
    fmt.Println("Building...")
}
//Install
func Install(){
    log.Println("Installing...")
}
```

## 预备，构建
构建只需要一行代码`mage build`，程序就会自动执行 `Build` 函数，完成整个构建过程。
