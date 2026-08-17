---
title: go模块入门
date: '2018-09-03 15:25:44'
tags:
- go
- 文章翻译
slug: gomod
draft: false
---

# Go 模块入门

Go1.11 的一个重要特性就是 `go modules`，作为 Go 一直以来版本管理顽疾的官方解决方案，自然是非常值得重视的。最近看到一篇文章对它阐述的非常好，所以就翻译过来。

原文链接：[Introduction to Go Modules – Roberto Selbach](https://roberto.selbach.ca/intro-to-go-modules/)

<!--more-->

Go 语言的1.11版本即将带来modules 的实验性支持，这是 Go 语言中一个全新的依赖管理系统。

早前我[写过一篇文章](https://roberto.selbach.ca/playing-with-go-modules/)来阐述 Go 的模块，但里面的很多东西在那篇文章之后都发生了变化，所以就有了这篇文章，用更多的上手实践来介绍这个特性。

在这篇文章里，我们会创建一个新的包（package）和发布一些版本来验证 go 模块是如何工作的。

## 创建一个模块

首先，我们创建一个命名为“testmod”的包。一个重要的细节是，包文件夹应该在`$GOPATH`以外，因为在`$GOPATH`目录下，模块功能是默认关闭的。某种程度上可以认为 Go modules 是削弱`$GOPATH`职能的第一步。

```shell
$ mkdir testmod
$ cd testmod
```

包的内容非常简单，

```go
package testmod

import "fmt"

// Hi returns a friendly greeting
func Hi(name string) string {
   return fmt.Sprintf("Hi, %s", name)
}
```

这样不是一个模块，需要做以下变更

```shell
$ go mod init github.com/robteix/testmod
go: creating new go.mod: module github.com/robteix/testmod
```

这个命令会在目录下创建`go.mod`文件，内容如下

```shell
module github.com/robteix/testmod
```

这些步骤已经将我们的包转换成一个模块，我们可以把这些代码推送到仓库中，

```shell
$ git init 
$ git add * 
$ git commit -am "First commit"
$ git push -u origin master
```

这样，其他人可以通过`go get github.com/robteix/testmod`来使用这个包

这个操作会拉取`master`分支下的代码。这依然有效，但我们应该停止这么做因为我们找到了更好的方法。拉取`master`分支的做法是具有潜在危险性的，因为我们不能确定软件包的作者会不会作出一些让我们的调用不再生效的更改。这是 modules 主要想改善的状况。

## Module Versioning 简介

Go 模块是支持版本的概念的，也支持特别对待一些特殊的版本。首先（运用这些特性之前）你要熟悉[语义化版本](https://semver.org/lang/zh-CN/)的概念。

更重要的是，Go 使用仓库标签的方式来查找版本，某些版本会与众不同，比如version 2或者更高的版本应该享受与0或1版本不同的导入路径。

与此同时，Go 会默认拉取仓库中最新的可用标记版本（tagged version），这是非常值得注意的地方因为在此之前你或许已经习惯了使用 master 分支。

现在你需要知道的是为了发布我们的软件包，我们需要对软件仓库的代码用版本号来打标签，让我们开始吧！

## 第一次发布

让我们把写好的软件包发布出去。我们使用版本号标签的方式来实现，比如说发布1.0.0版本

```shell
$ git tag v1.0.0
$ git push --tags
```

这会在我的 GitHub 仓库上面将当前的提交标记为1.0.0发布版。

为这次发布创建一个新分支是一个好主意，尽管 Go 不会强制要求我们这样做。

```shell
$ git checkout -b v1
$ git push -u origin v1
```

现在我们可以专注于 `master` 分支，不用担心会破坏我们的发布版本。

## 使用我们的模块

我们将会创建一个简易程序来演示如何使用我们的模块/

```go
package main

import (
    "fmt"

    "github.com/robteix/testmod"
)

func main() {
    fmt.Println(testmod.Hi("roberto"))
}
```

在之前，你可以通过`go get github.com/robteix/testmod`来下载软件包，但使用模块功能，事情会变得有趣。首先我们要在自己的程序中开启模块功能

```shell
go mod init mod
```

它会创建`go.mod`文件，内容如下

```shell
module mod
```

当我们在试图构建我们的代码的时候事情变得有趣起来，

```shell
$ go build
go: finding github.com/robteix/testmod v1.0.0
go: downloading github.com/robteix/testmod v1.0.0
```

正如我们所见，`go`命令获取程序需要用到的软件包。这时候如果我们打开`go.mod`文件，可以看到

```shell
module mod
require github.com/robteix/testmod v1.0.0
```

另外我们会看到一个名为`go.sum`的新文件，包含了软件包的哈希值，确保我们下载了正确的版本和对应的二进制文件。

```shell
github.com/robteix/testmod v1.0.0 h1:9EdH0EArQ/rkpss9Tj8gUnwx3w5p0jkzJrd5tRAhxnA=
github.com/robteix/testmod v1.0.0/go.mod h1:UVhi5McON9ZLc5kl5iN2bTXlL6ylcxE9VInV71RrlO8=
```

## 发布修复 bug 的版本

现在假设我们意识到程序中存在的一个问题，打招呼的语句缺少标点符号。人们会因为我们这个程序的不够友好而勃然大怒，所以我们用新版本来修复这个问题

```go
// Hi returns a friendly greeting
func Hi(name string) string {
-       return fmt.Sprintf("Hi, %s", name)
+       return fmt.Sprintf("Hi, %s!", name)
}
```

我们在`v1`分支进行更改因为这与我们稍后在`v2`版本要做的事情毫无关系。在实际应用中，你或许会直接在 `master` 分支上干这件事情。无论哪种方式，我们需要修复我们`v1`分支上的代码并且标记成一个新的发布版本。

```shell
$ git commit -m "Emphasize our friendliness" testmod.go
$ git tag v1.0.1
$ git push --tags origin v1
```

## 更新模块

在默认情况下，Go 在未经许可之前不会更新模块，这是一件好事因为我们希望软件构建过程是可以预测的。如果 Go 模块每次有新版本发布的时候都会自动更新，我们会回到 Go1.11的一个非常原始的版本。现在，我们需要告诉 Go 来更新模块。

在老版本的`go get`，我们可以这样做

- `go get -u`来获取*minor*或者 *patch* 更新，比如从1.0.0更新到1.0.1或者1.1.0
- `go get -u=patch` 来获取最新的*patch*更新（会更新到1.0.1但不会更新1.1.0）
- `go get package@version` 来更新特定的版本。

在上面所说的措施里面，没有一个可行的举措来更新到最新的`major`版本，我们稍后会看到，这是有原因的。

因为我们的程序使用的是`1.0.0`版本的软件包，我们刚刚创建了`1.0.1`版本，以下任意一个命令会更新我们的软件包到1.0.1

```shell
$ go get -u
$ go get -u=patch
$ go get github.com/robteix/testmod@v1.0.1
```

运行以上任意命令之后，`go.mod`文件更改为

```shell
module mod
require github.com/robteix/testmod v1.0.1
```

## 主版本更新

根据语义化版本的语法，主版本（major version）不同于小版本更新（minors）。主版本可以破坏后向兼容性。Go模块的观点中，主版本是完全不同的软件包。这一点最开始看来非常的奇怪，但是讲得通的：两个版本的库是不兼容的，这是两个完全不同的库。

让我们创建软件包的一个主要版本，为`greeting`函数提供一个新的参数，

```go
package testmod

import (
    "errors"
    "fmt"
)

// Hi returns a friendly greeting in language lang
func Hi(name, lang string) (string, error) {
    switch lang {
    case "en":
        return fmt.Sprintf("Hi, %s!", name), nil
    case "pt":
        return fmt.Sprintf("Oi, %s!", name), nil
    case "es":
        return fmt.Sprintf("¡Hola, %s!", name), nil
    case "fr":
        return fmt.Sprintf("Bonjour, %s!", name), nil
    default:
        return "", errors.New("unknown language")
    }
}
```

使用我们 API 的现有软件在新版本之下不能运行因为他们不会传递一个语言参数而且不会返回一个错误，我们的新 API 不再与1.x 版本兼容。所以是时候更新2.0.0版本。

我之前提过有些版本有一些具体的特性，这里是具体的例子，Version 2 及以上的版本要修改导入路径，他们现在是不同的库。

我们通过在导入路径中加入新版本号来实现

```shell
module github.com/robteix/testmod/v2
```

剩下要做的事和之前的差不多，把代码推送到软件仓库，标签为2.0。0版本，创建 v2分支

```shell
$ git commit testmod.go -m "Change Hi to allow multilang"
$ git checkout -b v2 # optional but recommended
$ echo "module github.com/robteix/testmod/v2" > go.mod
$ git commit go.mod -m "Bump version to v2"
$ git tag v2.0.0
$ git push --tags origin v2 # or master if we don't have a branch
```

## 主要版本更新

虽然我们发布了软件库的新的、不兼容的版本，但现有的软件不会失效，因为它会继续使用现有的1.0.1版本，`go get -u`不会更新到2.0.0版本。

在某些场合，库的使用者可能会想要更新到2.0.0版本因为可能存在需要多语言支持的用户。

通过适度的修改来实现

```go
package main

import (
    "fmt"
    "github.com/robteix/testmod/v2" 
)

func main() {
    g, err := testmod.Hi("Roberto", "pt")
    if err != nil {
        panic(err)
    }
    fmt.Println(g)
}
```

之后，当我运行`go build`的时候，它会下载`2.0.0`版本。注意到，即使这个导入路径是以“v2”结尾，Go 依然可以正确引用模块名字（“testmod”）

正如我之前提到的是，主版本从各方面来说都是完全不同的包版本，Go 模块不会连接到两个不同的版本，这意味着我们可以在同一个程序里面使用两个不兼容的库版本。

```go
package main
import (
    "fmt"
    "github.com/robteix/testmod"
    testmodML "github.com/robteix/testmod/v2"
)

func main() {
    fmt.Println(testmod.Hi("Roberto"))
    g, err := testmodML.Hi("Roberto", "pt")
    if err != nil {
        panic(err)
    }
    fmt.Println(g)
}
```

这个举措降低了包管理体系里面常见问题的负面影响：在同一软件中依赖了同一个库的不同版本。

## 整理

回到那个只用`testmod v2.0.0`版本的软件，我们再看`go.mod`的内容，我们注意到

```shell
module mod
require github.com/robteix/testmod v1.0.1
require github.com/robteix/testmod/v2 v2.0.0
```

默认情况下 Go 不会主动移除过时版本的依赖，如果你不再使用并且想进行清理，你可以使用`tidy`命令

```shell
go mod tidy
```

现在`go.mod`里面只有我们在使用的软件包版本。

## Vendoring

默认情况下 Go 模块忽略`vendor/`目录。这个构想是为了废除`vendoring`机制，但如果我们依然想加入vendor依赖的话，依然可以实现。

```shell
go mod vendor
```

它会在你项目的根目录下创建`vendor/`目录，目录里面是你源代码的所有依赖关系。

同样地，`go build`会忽略这个目录下的所有内容，如果你想从这个目录中构建依赖关系，你需要输入

```shell
go build -mod vendor
```

我觉得很多开发者会在自己的机器上面使用正常状态下的`go build`而在持续集成的环境里使用`-mod vendor`

需要再次强调的是，Go 模块已经彻底抛弃了 vendoring 思想，转而使用 Go 模块代理，因为很多人不想直接依赖上游版本控制服务。

## 结论

这篇东西多多少少看起来有点劝退的意味，不过我尝试在一篇文章里解释多个概念，事实上 Go 模块是非常透明的，我们只需要像往常一样在代码中导入需要使用的代码然后`go`命令会帮我们做完剩下的所有事情。

当我们构建应用的时候，会自动拉取依赖关系。Go 模块同样削弱了`$GOPATH`的必要性，这玩意是新入门的 Go 开发者的一大绊脚石，他们往往无法理解问什么所有东西都要放到同一个目录中。