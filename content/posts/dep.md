---
title: golang/dep 包管理（一）原理
date: '2018-06-12 21:17:51'
tags:
- go
- golang
slug: dep
draft: false
---

# Golang 包依赖管理工具

golang 一直以来一个为人诟病的问题就是没有完善可用的包管理工具（类比 java 的 gradle 和 maven，Python 的 pip，nodejs 的 npm），这与 golang 的追求简约高效的原则有关。golang 1.5版本之后引入了`vendor`机制，1.8之后终于有了官方的包管理工具，`golang/dep`。
<!--more-->

![四元组架构](https://golang.github.io/dep/docs/assets/four-states.png)

## 相关链接

[Golang依赖管理工具：Dep \- 乐金明的博客 \| Robin Blog](https://supereagle.github.io/2017/10/05/golang-dep/)
[Models and Mechanisms · dep](https://golang.github.io/dep/docs/ensure-mechanics.html)
[golang/dep: Go dependency management tool](https://github.com/golang/dep)