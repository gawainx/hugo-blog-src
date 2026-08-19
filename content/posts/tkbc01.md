---
title: 时序知识图谱补全论文整理：Ⅰ
mathjax: true
tags:
- Temporal Knowledge Graph
- TKG
- KGC
- TKGC
date: '2021-08-22 11:31:32'
slug: tkbc01
draft: false
---

整理最近阅读的时序知识图谱（Temporal Knowledge Graph）补全领域的文献。

## 基本概念

首先，明确基本概念。现有的知识图谱表示为$\mathcal{G}=\{(h, r, t)\}$ 的三元组集合，这是一种静态的图谱，目前针对这种形式的知识图谱补全任务，也就是预测三元组$(h, r, ?)$ 已经有大量的相关研究，包括Translation-based方法、Bilinear Model和KGAT等图神经网络的尝试。

在现实应用中，静态图谱存在一个隐蔽但关键的缺陷：知识图谱用于反映事实，而很多事实是会随着时间不断变化的。比如，奥运会每四年举办一次，每次举办的地点不一样。每年的美国总统有可能会变化。因此，一个符合直觉的思路就是在三元组的基础上，加上时间戳因子，表示这个fact在特定时间是有效的。

这时候，知识图谱变成了四元组集合，$\mathcal{G}=\{(h, r, t,\tau)\}$，最后一个因子为时间戳，也就是论文中常常看到的`timestamp`。

已有的时序知识图谱时间戳单位一般是年，因为如果以更精确的时间粒度，那同一时间发生的时间实在太少了，导致模型很难训练。

引入时间戳之后，就会有一个对应概念，叫snapshot，指的是某个具体时间点所有三元组的集合，可以类比视频中的一帧来理解。那么，时序知识图谱可以表示为一系列snapshot的集合，我们有
$$
\mathcal{TKG} := \{\mathcal{G}_1, \dots, \mathcal{G}_t, \dots, \mathcal{G}_T\}
$$

其中，$T$ 表示当前的时序图谱一共有$T$个snapshot的KG组成。

## 问题定义：时序知识图谱补全

有了时序知识图谱的概念之后，就可以根据静态知识图谱补全任务来延伸得到时序知识图谱补全的定义。

静态知识图谱补全任务：对于$\mathcal{G}=\{\mathcal{E}\times\mathcal{R}\times \mathcal{G}\}=\{(h, r, t)\}$, 给出新的三元组 $(h, r, ?)$ 预测尾部实体，或者给出$(?, r, t)$预测头部实体。在实际评估的时候，会把预测问题建模为对实体集合$\mathcal{E}$中所有实体进行打分的问题。

时序知识图谱补全任务：对于$\mathcal{TKG} := \{\mathcal{G}_1, \dots, \mathcal{G}_t, \dots, \mathcal{G}_T\}$， 给出$(h, r, ?, \tau)$ or $(?, r, t, \tau)$，预测missing entity。这是时序知识图谱补全任务的最基本形式。由于多了时间这个维度的约束，在实际paper中会出现不同的变种形式

1. 赋予模型预测未来时间的能力，也就是限制训练集与测试集的时间跨度交集为空
2. 不做限制，只预测训练集中出现过的时间戳的missing entity。

## Paper

### RTFE: A Recursive Temporal Fact Embedding Framework for Temporal Knowledge Graph Completion

来源：NAACL 2021

问题定义：对时序知识图谱补全任务的定义使用了第二种定义，也就是假设训练集和测试集的时间戳是一致的，预测missing entity

贡献：本文关注了静态KGE Model与TKGE设定之间的差异，提出了一个演进式的模型，把时间戳之间的转换建模为一个马尔可夫过程，递归的学习不同时间戳的实体表示；并且由于马尔可夫转移概率矩阵的引入，赋予了模型一定的对新时间戳三元组的预测能力。

模型：模型分为两部分，第一部分unite了所有时间戳的四元组训练一个静态KG表示，一次作为初始化状态，再每个时间戳采样四元组训练转移模型以及更新KG表示。这个训练设定有让我迷惑的地方，在训练静态KG的时候已经看到了所有时间的数据，那么在训练转移模型的时候会不会受到这个数据泄漏的影响？

## TIE: A Framework for Embedding-based Incremental Temporal Knowledge Graph Completion

来源：SIGIR 2021

链接：[ACM Page](https://dl.acm.org/doi/abs/10.1145/3404835.3462961)

对TKGC的问题定义：这篇文章关注增量TKGC问题而不是标准的TKGC，Increment TKGC的差别在于，model只能看到当前时刻及之前时刻的所有实体，而不是从一开始到最后的所有实体。
挑战：增量TKGC的设定带来了新的挑战，首先就是模型的灾难性遗忘，这是所有增量学习模型共同的关注点；第二是模型对fact变化的识别能力，第三是训练效率问题。如果根据每个新的时间戳都fine-tune时间成本会不划算。

模型：针对灾难性遗忘的问题，应用Replay机制，这里的replay是对不同时间戳重复出现的事件的replay；针对fact随时间变化的问题，提出使用将deleted fact作为负采样的方法对KG进行训练；同时还使用了正则化机制(Sec. 5.3) 应对灾难性遗忘问题

这篇文章所关注的问题和对应的方法都很有意思，后面看看能写一篇长文讲讲。

## Temporal Knowledge Graph Reasoning Based on Evolutional Representation Learning

来源：SIGIR 2021
Model： RE-GCN

对TKGC的问题定义：这篇文章关注了更具挑战性的场景——预测未来。在给出$t$时刻以及$t$时刻之前的$m$个时间窗口的KG，预测$t+1$时刻所发生的事件。

模型：模型包含两部分，第一部分是应用R-GCN学习每个时间戳的实体表示，第二部分是将不同时间戳的KG建模为序列，更新时间related的表示
