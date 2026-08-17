---
title: go 语言中 JSON 数据的处理
date: '2018-03-30 15:20:31'
tags:
- go
slug: gojson
draft: false
---

Golang 中处理 JSON 格式数据主要依赖`encoding/json`这个库，很多教程（包括 Go 语言圣经）讲 JSON 数据处理时都会定义一个结构体对应于 JSON 数据的各个字段，这种处理方法在 JSON 中字段相对固定时非常实用。但对于字段可能不断变化或者只有一两个字段是固定的时候，如何处理这个问题往往令很多人感到困惑。最近研究 gin 这个库的时候发现一个思路非常值得学习借鉴。
<!--more-->

## What

说了这么多，其实并不神秘，就是来自 gin 框架源码中的一句关键定义

```go
// H is a shortcup for map[string]interface{}
type H map[string]interface{}
```

定义了这个数据结构之后，gin 框架就可以处理几乎所有的 JSON 数据。

同理，我们在自己的代码中想不受结构体限制灵活处理 JSON 数据时，也可以在程序代码中添加类似的定义

```go
type message map[string]interface{}
```

从字符串解析 JSON 数据时，只需要

```go
//body is string message
var result mss
json.Unmarshal([]byte(body),&result)
```

包装 JSON 也类似

```go
//mes is message type
bty,err := json.Marshal(mes)
```

值得一说的是平时处理 JSON 数据经常出现的反斜杠双引号问题，用这种方法处理时并没有出现。

## Why

背后原理分析。

这一行代码之所以这么实用是因为` interface{}`这个 golang 中的“万金油”。Golang 中不存在类和对象的概念，因此空接口就成了所有变量的“超类”一样的存在，可以承载一切的变量。

## 潜在问题 and Further More

处理 JSON Array 时会出现问题，就是明知它是数组却不能直接用下标进行操作（会提示`{}interface` 不支持下标，导致编译失败），实际运行时用反射包的`reflect.TypeOf`查看JSON 数组解析出来的类型明明是`[]interface{}`，是接口slice，是支持下标操作的。

原因是 Golang 是静态语言，代码中所有变量的类型都是在编译期确定的，我们所定义的类型中 map 的 value 部分是`{}interface`，在 运行时接收到需要解析的 JSON 数据之前编译器和我们都不知道它“事实上”是一个 slice。

这个在项目应用中实际存在的矛盾也解决我学 OOP 语言一直以来的困惑，就是反射是什么？为什么现代编程语言都选择加入反射作为基本特性（Java，C#，还有本文中的 Golang），就是因为我们有在运行时获取某个对象/变量的实际类型的需要。

由于目前学习还不够深入，不能对反射机制展开深入的探讨，在这里讲一下如何利用类型断言机制解决上面说到的问题。

```go
cs,ok := result["containers"].([]interface{})
	if ok{
		for i,item := range cs{
			//do something
		}
	}
```

`cs,ok := result["containers"].([]interface{})`这一句就是解决问题的关键所在，也就是称为运行时类型断言的机制。`a.(Type) `是尝试对a进行类型转换的操作，如果转换成功则返回一个转换成 Type 类型的变量和`true`指示转换成功，失败则返回`false`。

值得一提的是，断言失败不会导致编译失败（要是会导致编译失败也就不能解决上面这个问题了），所以为了代码健壮性需要对转换结果进行判断比较好。