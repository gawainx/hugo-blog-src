---
title: 11月论文阅读总结
date: '2018-11-29 16:48:39'
tags:
- 科研
slug: papers-nov
draft: false
---

转博了之后平时的工作重心从写代码慢慢的转移到科研读论文复现论文等上面来。选研究方向的时候也费了好大一番功夫去纠结，一开始想继续做微服务和SDN的东西，后面却逐渐发现往深入去做的话又兜兜转转回到了通信的轨道上了。后面终于下定决心做知识图谱的东西。整个十一月都在看知识图谱的论文，主要集中在知识表示领域的几种Translation模型上。

<!--more-->

## 什么是Translation？

知识图谱是一种偏向于人类认知的“数据结构”，将实体之间用关系的方式进行链接，比如说“中国的首都是北京“这句话，用知识图谱进行建模的方式就是，“中国”（实体）的首都是（“关系表示”）“北京”（另一个实体）。

这样，一条知识就可以用图这个数据结构的一条边（edge）来表示。参考图的关系描述方式，知识图谱中可以使用 $h,r,t$ 三元组来表示一条“知识”，$h$ 是head，头部知识，知识的端点，在上面的例子中，为“中国”，$r$是relation，表示关系的意思，$t$是tail，在上面的例子中，为“北京”。

知识终究是要喂给计算机进行处理的，计算机只能处理数据信息。知识图谱上面的东西都是离散的，符合人类认知逻辑的，和计算机处理的数据没有半毛钱的关系。因此，就有了知识表示的说法。怎么把图结构表示成计算机可以处理的数据的形式。

Translation，是对知识表示的一种“形容”，目标是将三元组映射到计算机可以处理的连续数值向量空间中，当然了，最好这个空间的维度可以低一些。

## Translation Embedding（TransE）

TransE，是最早的研究用嵌入（embed）方法来进行知识表示的一篇论文。基本思想就是最直观的将实体关系数据嵌入到低维度向量空间中。

关于TransE，网路上有很多讨论的文章（毕竟出来最早），讨论的内容都大同小异，可以参考[TransE算法的理解 \| Yaoleo](http://yaoleo.github.io/2017/10/27/TransE%E7%AE%97%E6%B3%95%E7%9A%84%E7%90%86%E8%A7%A3/)

TransE所完成的，是最基本的知识嵌入，忽略了知识中普遍存在的一对多、多对一、自反关系的问题，自反关系中，$r$会被建模成$0$向量；多对一的关系中，因为它的Scoring Function设定为 $\Vert h-r+t \Vert$， 假设$h_0,...,h_m$ 均与$t$形成关系$r$，那么$h_0,...,h_m$的向量表示是相等的。一对多的关系同理。

因此，有了TransH。

## Translation Hyperplane

这个方法是紧跟随TransE提出来的。主要有两个改进的地方（对比TransE）

1. 引入entity的分布式表示。将Relation的表示放在了与entity的不同空间当中（也是Hyperplane的由来）。两个空间（relation和entity之间）的向量表示是一个投影关系（projection）

2. 将现有知识图谱的“未完成”问题考虑进来，负样本的构造过程不再像以往模型那样随机选择，而是基于伯努利分布的一个选择过程。而且对与多对一和一对多时候的“污染源”也是有区别的。

此外Scoring Function和Loss Function也有改进。

## OpenKE Toolkit

第三篇论文是2018年清华大学发布的，是一个工具包的简介。基于Trans的模型有不下五六种，模型的训练和测试成为了一个难题。而且每提出一个新的算法都要对前面的东西进行重复验证。所以这篇论文中将这几种常见模型的算法集中到了一起，提供统一的接口和数据库，并且保证了向后兼容性。提供了TF和PyTorch的接口，实现GPU训练和CPU多线程并行训练。

在这篇论文中作者还指出，前面的各种Translation算法，本质上最大的区别就是Scoring Function和Loss Function的区别。

## 参考链接

1. [清华大学开源OpenKE：知识表示学习平台 \| 机器之心](https://www.jiqizhixin.com/articles/2017-11-04-2) 里面有上面提到的所有论文的链接。

2. Zhen Wang, J. Z. J. F. Z. C. (2014). Knowledge Graph Embedding by Translating on Hyperplanes, 1–8.

3. OpenKE: An Open Toolkit for Knowledge Embedding. (2018). OpenKE: An Open Toolkit for Knowledge Embedding, 1–6.

4. Translating Embeddings for Modeling Multi-relational Data. (2013). Translating Embeddings for Modeling Multi-relational Data, 1–9.