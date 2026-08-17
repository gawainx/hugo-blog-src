---
title: 解决DGL库AttributeError deferred_dtype 错误
mathjax: false
tags:
- DGL
- GNN
date: '2022-06-17 20:49:39'
slug: dgl-error-4107
draft: false
---

DGL 库升级到最新版本`0.9.0+`的测试版之后，运行老版本的代码会遇到错误

`AttributeError: 'Column' object has no attribute deferred_dtype`

在官方GitHub页面可以看到相关的讨论：[GitHub issue 4107](https://github.com/dmlc/dgl/issues/4107)

个人推测是因为DGL版本升级对底层代码进行了重构，我的代码中，使用老版本的DGL构建了图实例，并且使用`dill`持久化为二进制文件，在新环境加载这个代码的时候，就会遇到一些新添加进去的属性没有的情况，也就是`AttributeError`。

解决方法：回滚到老版本

```shell
# if you use cuda 11.03 
pip uninstall dgl-cu113
pip install dgl-cu113==0.8.1 dglgo -f https://data.dgl.ai/wheels/repo.html
# if you use cuda 10.2
pip uninstall dgl-cu102
pip install dgl-cu102==0.8.1 dglgo -f https://data.dgl.ai/wheels/repo.html
```