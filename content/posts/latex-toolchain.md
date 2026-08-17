---
title: LaTeX排版学术论文工具链
date: '2018-05-21 10:48:35'
tags:
- LaTeX
slug: latex-toolchain
draft: false
---
# LaTeX 排版工具链

 这里整理了 $\LaTeX$ 排版学术论文的工具链。根据自己的实践和大家的留言补充定期更新。
<!--more-->

## 操作系统，软件等

$\LaTeX$ 可以在 Windows、Linux 和 macOS 平台上运行。Windows 上可以安装 MikTex，Linux 上有 TeX Live，考虑美观度和排版过程的愉悦度，本人使用的 LaTeX 排版环境大致如下：

- OS : macOS(Darwin)
- 编辑器：[Microsoft VSCode](https://code.visualstudio.com)
- 插件：LaTeX Workshop
- $\LaTeX$ 软件：MacTeX 工具包
- PDF 阅读工具：skim

## 模板

[IEEE tran](https://github.com/uefs/ieee-template-latex/blob/master/bare_jrnl.tex)
`bare_jrnl.tex`最新版本应该是 v1.7，但在网上好像找不到这个最新的版本，准备整理一个多文件编译的版本放到 GitHub 上。

欢迎留言补充其它模板。:)

## 数学公式

[数学符号集](http://mohu.org/info/symbols/symbols.htm)

## 插入伪代码（算法宏包的相关使用）

[LaTeX算法排版](https://www.zybuluo.com/jfruan/note/720298)

## 代码

使用`listings`宏包。[LaTeX/Source Code Listings](https://en.wikibooks.org/wiki/LaTeX/Source_Code_Listings)
但这个宏包没有 golang 语法高亮支持的！要使 golang 语法高亮，可添加宏包[listings-golang](https://github.com/julienc91/listings-golang)

## 图片与表格

首先要理解浮动体的概念，[LaTeX 中的浮动体：浮动算法](https://liam0205.me/2017/04/30/floats-in-LaTeX-the-positioning-algorithm/)

## 学习资源

[LaTeX 开源小屋](http://www.latexstudio.net)
[Begin LaTeX in minutes](https://github.com/luongvo209/Begin-Latex-in-minutes)
[LaTeX 入门](https://book.douban.com/subject/24703731/)
