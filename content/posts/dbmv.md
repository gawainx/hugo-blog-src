---
title: 豆瓣电影海报下载-Workflow
date: '2018-07-17 21:03:53'
tags:
- Mac
- Alfred
slug: dbmv
draft: false
---
# Preface

最近实验室里买了打印机，手账 er 多年以来的为电影手账贴上海报缩略图的心愿终于有机会打成了。

那么问题来了，去哪找电影海报可以更快更方便呢？每次都是打开网页->搜索->图片另存为，太麻烦。于是我盯上了 Alfred，于是就有了这个工具。

<!--more-->

## 使用

首先配置好文件储存的路径。

在 Alfred 中输入 `dbmv`，选择 setting，在配置文件中的`img_path`输入想要保存图片的目录。

然后就可以愉快的使用了。

1. ⌘ + Space 唤醒 Alfred 窗口，输入 `dbmv` 启动 Workflow。
2. 选择 Movie
3. 输入想要搜索的电影名字
4. 在搜索结果中选择要下载的电影海报，
5. 回车确认，然后在目标路径就会看到下载好的海报了。

## 下载地址

[Releases · gawainx/dbmv](https://github.com/gawainx/dbmv/releases)

## 特别鸣谢

本 Workflow 系基于[做了一个豆瓣搜索的 Workflow for Alfred - 海边的石头](http://stonebythesea.org/posts/douban-search-workflow-for-alfred/)作品的改写。
