---
title: Javalin框架使用指南(2)
date: '2017-10-28 20:15:17'
tags:
- Java
- Javalin
- WebSocket
slug: javalin2
draft: false
---

# 前言
> WebSocket协议是基于TCP的一种新的网络协议。它实现了浏览器与服务器全双工(full-duplex)通信——允许服务器主动发送信息给客户端。

最近在项目中需要开发响应 WebSocket 的服务器程序来实现向客户端推送视频流的功能，刚好 Javalin 在最新版本中已经添加了对 WebSocket 的基本支持，于是有了这篇文章。
<!--more-->

# 依赖关系配置（基于 Maven）

和前面一样，使用 Maven 作为项目的包管理工具。要使 Javalin 框架的应用程序完整支持 WebSocket，需要额外添加以下的依赖关系包：

```XML
<dependency>
    <groupId>org.eclipse.jetty.websocket</groupId>
    <artifactId>websocket-servlet</artifactId>
    <version>9.4.7.v20170914</version>
</dependency>
<dependency>
    <groupId>org.eclipse.jetty.websocket</groupId>
    <artifactId>websocket-server</artifactId>
    <version>9.4.7.v20170914</version>
</dependency>
<dependency>
    <groupId>org.eclipse.jetty.websocket</groupId>
    <artifactId>websocket-common</artifactId>
    <version>9.4.7.v20170914</version>
</dependency>
<dependency>
    <groupId>org.eclipse.jetty.websocket</groupId>
    <artifactId>websocket-api</artifactId>
    <version>9.4.7.v20170914</version>
</dependency>
```

为了避免一些千奇百怪的类、方法错误，建议加入的 jetty 依赖包的版本尽量保持严格一直（然而在目前的开发中还是遇到了奇奇怪怪的方法缺失错误，虽然不影响正常的运行不过看着还是蛮闹心的Orz）

# 四个基本方法

和前面介绍的一样，Javalin 主要还是通过 lamada 表达式的方式来实现对特定路径的 WebSocket响应，基本的代码架构如下：

```java
app.ws("/path",ws ->{
  ws.onConnect(session -> {
        //do something
    });
  ws.onMessage((session,message) -> {
      
  });
  ws.onClose(/*insert you lamada expr*/);
  ws.onError(/*insert you lamada expr*/);
});
```

四个以`on`开头的方法是实现 WebSocket 基本功能的方法，每个方法的基本含义如下：

- `onConnect( session)`用于处理客户端与服务器端的连接事件，用`session`来指代服务器端与具体某个客户端的连接本身。`session`中有个`getRemoteEndpoint()`的方法可以获取表征客户端的“端点”一类的东西，通过这个“端点”，可以随时“主动”的向客户端发送数据。这也是 WebSocket 的优势和魅力所在（一旦建立连接之后，服务器端可以根据具体情况随时主动的向客户端推送信息）。
- `onMessage(session,message)`用于处理收到客户端信息时候的响应，session 的基本含义同上，message 表示来自客户端的信息。
- `onClose()`用于处理连接关闭时的事件。
- `onError()`用于发生错误时的响应。

# 其他

Javalin 当中对于 WebSocket 的实现，主要是建基于 jetty 对 WebSocket 的支持的基础上进行了二次封装，所以，Javalin目前不支持的一些方法、操作等都可以单独引用 jetty 提供的方法进行实现，只是这时候更加要注意依赖关系等问题了。

除了绑定 lamada 表达式之外，`app.ws()`方法也可以将特定路径和实现了 WebSocket 响应的具体的类进行绑定，不过这个我还没有尝试过，理论上来说用起来会更加灵活，以后如果用到了也会写后续文章跟大家分享使用经验。

