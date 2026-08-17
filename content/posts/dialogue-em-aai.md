---
title: 2022 年对话情绪识别的研究进展
date: '2022-12-05 21:56:12'
tags:
- Dialogue Emotion Detection
slug: dialogue-em-aai
draft: false
---

这篇文章总结一下对话情绪识别的进展情况，有两篇文章。

## Is Discourse Role Important for Emotion Recognition in Conversation?

来源：AAAI 2022

这篇文章关注在对话情绪识别中，已有的模型没有利用“Discourse Role Information” 对话角色信息这个东西。对话角色/话语角色这是语言学上的一个概念：

> 话语角色 是修辞主体 在一定语境中 实施言语行为时 所择取的 社会身份 话语角色不仅包括交际主体的社会职能特征 而且包括文化特征和心理特征 尤其是与其社会角色相应的语言特征 社会角色是话语角色的基础 话语角色是社会角色在言语交际领域的具体表现

文章的解决办法是引入一个变分自编码器来对这些信息进行编码。这里有个疑问就是它变分自编码器怎么保证学到的是话语角色信息而不是其他有用的信息？

## Contrast and Generation Make BART a Good Dialogue Emotion Recognizer

来源：AAAI 2022

这篇文章关注的问题是相似的语义放在不同的上下文里会有不同的信息。为了更好的进行区分，这篇文章做了两部分的贡献

1. 监督对比学习：用于更好区分不同的语义信息
2. 生成辅助任务：生成任务指的是让模型自己去生成下一段对话的内容，这样做的目的是更能捕捉富文本信息
