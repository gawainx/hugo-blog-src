---
title: Java Mongodb 使用指南（一）增删查改
date: '2017-07-20 16:22:24'
tags:
- java
slug: mongodbj
draft: false
---

# 前言

最近在重构之前宇宙 mei毕设项目的注册中心，为了跟 Docker 容器技术无缝衔接将原先的 SQLServer 换成了与前端统一的 mongodb。让人不愉快的是，java 调用 mongodb 时遇到了好些问题，首先是 mongo版本更新3.0.0之后DB 相关的 API 已经废弃不用了，直接导致很多不够新的书籍都不具有参考价值；此外无论官网提供的 API 参考还是网络上很多教程，要么就是甩了一堆天花龙凤的代码，要么就是摸不着头脑的类列表。所以才有了这篇方便理顺思路的文章。

<!--more-->

# 基本概念

先讲清楚两个后面用到的最重要的两个类：`BSON`和`Document`。

## BSON

`BSON`是 JSON 文件的二进制储存格式。在 mongodb 的 Java 驱动中，这种数据类型主要用于建立查询条件。比如说在 mongodb shell 里面`.find({"id":"0001"})`这句话里面的`{"id":"0001"}`部分对应在 Java 代码里面就是一个 BSON。

查询条件里面有个很有意思的概念是操作算子/条件算子，具体留到另一篇文章再说。

## Document

官方翻译是文档，就是对应于一条 JSON 格式数据。在使用中要注意的是这玩意不能用String 类型的 JSON 格式字符串来初始化，只能用 Map 类型或者单一键值对来初始化。

# 操作

## 增（Insert）

`mongoCollection.insertOne(Document)`

直接插入 Document 类型的数据。要注意的是这个插入默认是无条件的，是可以连续两次插入完全一样的文档（因为在 mongodb 内部是用`_id`来判断两个文档）

## 删（delete）

`mongoCollection.deleteOne(BSON)`

这个方法可以用来删除满足条件的一条数据，BSON 用于定义条件，比方说，要删除 id 字段为0001的数据，构造的 BSON 对象就是`new BasicDBObject("id","0001")`，完整的调用语句就是`mongoCollection(new BasicDBObject("id","0001"))`。

## 查（find）

`mongoCollection.find()`

默认不加参数时，会返回这个集合中的所有文档，返回类型是一个类似迭代器的东西，要遍历查询结果时可以这样写：

```java
FindIterable<Document> res = mongoCollection.find();
for(Document item : res){
  //do something
}
```

在这段代码中的 res，有个`.first()`方法，返回所有结果的第一个元素，如果结果是空集的时候，方法返回`null`。有意思的是，就算结果集是空集（找不到任何东西），res 也不会是 null。所以判断查找是否成功对 first()方法判空。

`mongoCollection.find(BSON)`

传入参数是客制化的查找条件（BSON 格式）

## 改（update 或 replace）

`mongoCollection.replace(BSON,Document)`

第一个参数是查询条件，第二个参数是完整的文档，这个方法的作用是将满足条件的文档用传入参数中的文档来进行替换。

`.updateOne(BSON bson1,BSON bson2)`

调用这个方法时，第一个 bson 是查询条件，第二个 bson （bson1）是替换目标，这个方法执行结果是查询满足条件bson1的结果，然后将这些文档的 bson1字段用 bson2代替。

这个方法执行起来可能会让人很无语，因为按照直觉，我们调用的时候可能更想做的是查找满足条件的文档，然后将里面的其他一些字段用 bson2替换掉。要实现这个功能也不是不可能的，不过要搞个嵌套 BasicDBObject，要用到`$set`操作算子。示例代码段如下：

```java
BasicDBObject opr = new BasicDBObject("$set",new BasicDBObject("status","on"));
mongoCollection.updateOne(new BasicDBObject("id","0005"),opr);
```

这段代码执行的结果是查找 id 是0005的文档，然后把这个文档中的 status 字段设为 on。

