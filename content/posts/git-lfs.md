---
title: git-lfs 基础使用指南
date: '2022-11-17 20:44:01'
tags:
- git
slug: git-lfs
draft: false
---

最近用`🤗Transformers`的时候发现它们模型已经转移到glfs（git large file system）上，刚好自己想上传数据集的时候也需要用到。顺手了解了一下

## 配置

LFS不属于git，而是GitHub开发出来的一套东西，在`command line`上使用的话需要安装[lsf插件](https://git-lfs.github.com)

压缩包下载下来之后，解压然后运行安装

```shell
$cd ~/Downloads
$tar -xf {your *.gz}
# install here
$chmod 755 install.sh
$sudo ./install.sh
```

## 使用

LFS提供的是一个钩子（hook）。因此，对每个使用LFS的repo都要hook一下

```shell
git lfs install
```

安装之后，使用步骤如下

使用`git lfs track "*.m"` 来追踪想要放到大文件系统上的内容。

这条命令会在文件夹中创建属性文件，要注意使用git追踪这个文件

```shell
git add .gitattributes
```

后续就是重复普通的add and commit 就ok

```shell
git add ubattery_dep.m
git commit -am "Add isotopic composition after depletion"
git push origin master
```

## Source

- [Git Large File Storage](http://arfc.github.io/manual/guides/git-lfs)
- [Git Large File Storage | Git Large File Storage (LFS) replaces large files such as audio samples, videos, datasets, and graphics with text pointers inside Git, while storing the file contents on a remote server like GitHub.com or GitHub Enterprise.](https://git-lfs.github.com/)

