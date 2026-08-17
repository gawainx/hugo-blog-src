---
title: Javalin 框架使用指南（一）
date: '2017-10-24 14:28:20'
tags:
- Java
- REST
- 微服务
slug: javalin1
draft: false
---

[Javalin](https://javalin.io/)是一款建基于 jetty 的轻量级 RESTful 框架，支援 Java 和 Kotlin 编程语言，非常适合用来部署REST 风格的微服务程序，因为里面对 lamada 表达式的应用可以说是到了出神入化的地步，所以一直都是我最喜欢用的框架。这系列的文章主要是介绍如何在微服务开发中应用这套框架来进行开发。
<!--more-->

# 安装

Javalin 支持几乎所有常见的项目管理工具，出于一般性，文章中以 Maven 为例进行说明。

安装框架本体

在项目的 pom.xml文件中的`<dependencies></dependencies>`标签下粘贴以下代码。

```XML
<dependency>
     <groupId>io.javalin</groupId>
     <artifactId>javalin</artifactId>
     <version>0.5.4</version>
</dependency>
```

这是官网中介绍的安装方法，要注意到，仅仅粘贴了以上代码段的话，会遇到两个问题：

1. maven 默认的 JVM 环境是 JDK1.6，是不支持 Lamada 表达式这种尤物的，我们需要在项目中添加 Java8支持。

   在`pom.xml`中粘贴以下代码：

   ```xml
   <build>
           <plugins>
               <plugin>
                   	<groupId>org.apache.maven.plugins</groupId>
                   <artifactId>maven-compiler-plugin</artifactId>
                   <configuration>
                       <source>1.8</source>
                       <target>1.8</target>
                   </configuration>
               </plugin>
           </plugins>
       </build>
   ```

   要注意到这段代码和`<dependencies></dependencies>`标签段是并行而不是包含关系的。

2. 在运行过程中可能会遇到以下错误提示：

   ```
   SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".SLF4J: Defaulting to no-operation (NOP) logger implementationSLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
   ```

   ​

   ​

虽然这个错误提示不会影响程序的正常运行，但强迫症总是让人不爽，解决方法是添加这个依赖关系

```XML
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-simple</artifactId>
    <version>1.7.25</version>
</dependency>
```

经过以上配置之后，就可以跑起第一段程序了

# HelloWorld

`HelloWorld` 是开发者学习新的编程语言、框架所绕不过去的坎，用 Javalin 开发一个 GET 方法访问根路径返回“helloworld”的 REST 服务器非常的简单。示例代码如下：

```java
import io.javalin.Javalin;

public class HelloWorld {
    public static void main(String[] args) {
        Javalin app = Javalin.start(7000);
        app.get("/", ctx -> ctx.result("Hello World"));
    }
}
```

从代码中可以看出，通过一个 lamada 表达式就可以完成指定路径到具体响应方法的绑定操作，还有什么比这个更让 RESTful 微服务开发者拍手称快的呢。

简单说明一下，框架中用 Javalin 类型的一个对象实例来完成整个 RESTful 风格的服务器的全部操作。上述代码中，首先是实例化了一个名为`app`的 Javalin类型实体，然后调用了`get(String path, lamada expression)`，以 lamada 表达式的表示一个具体的响应操作，以字符串的形式表示具体的路径，将两者绑定到一体。方法名称`get`表示响应 REST 规范中的 GET 请求。

此外，`ctx`参数指代的是连接上下文，调用`result()`方法可以将字符串塞进响应体中进行返回。

# MORE

Javalin 框架的安装和第一个服务器程序都可以非常简便的就完成了，但这只是一个开始，通过 Javalin 框架可以完成非常复杂的响应逻辑，而且最近的更新版本中还加入了对 WebSocket 服务器的支持。接下来的文章将会介绍如何进行进一步的开发和遇到的常见问题等。

**1024**节日快乐:halloween: