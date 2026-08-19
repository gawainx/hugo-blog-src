+++
date = '2026-08-19T12:00:00+08:00'
draft = false
title = '【arXivArcher】v2.0.4 版本更新'
+++

# 【arXivArcher】v2.0.4 版本更新

搞完各种发版流水之后，终于可以兑现周更甚至日更的承诺。
今天的更新内容非常 tiny - 完善 deepseek 简化配置支持

在我自己使用archer的流程来看，我非常喜欢使用deepseek作为模型总结、翻译和阅读的API后端，但是使用时发现默认的思考模式会导致吐出来的第一个token时间太长，实际上比如翻译功能并不需要思考。

基于这个观察，archer v2.0.4 版本新增 deepseek 配置，并可以关闭思考模式。使用方法如图：

![Setting Panel](https://img.antarxly.com/original/landscape/20260819-7ec770e7.png)

配置之后，即可感受丝般顺滑的操作体验。

## 安装 / 更新

```bash
brew tap gawainx/tap
brew trust --cask gawainx/tap/arxivarcher
brew install --cask arxivarcher
```

已经装过的直接：

```bash
brew update
brew upgrade --cask arxivarcher
```

## Beyond

时隔四年，终于把博客配置好了。由于 `x.com` 的崛起，原来的域名 `antarx.com` 简直就是网络时代的“洛阳纸贵”，于是更换了新的域名 `antarxly.com`。