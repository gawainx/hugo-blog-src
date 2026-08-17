---
title: Question Answering Over Temporal Knowledge Graphs
mathjax: false
tags:
- KGQA
- Temporal Knowledge
date: '2021-08-10 12:04:07'
slug: cronkgqa
draft: false
---
来源：ACL 2021
领域：KGQA
核心模型：TComplEx / TNTComplEx，BERT
🔗论文链接：[arXiv](https://arxiv.org/abs/2106.01515)
🔗代码：[GitHub](https://github.com/apoorvumang/CronKGQA)
文献依赖：
    - Improving Multi-hop Question Answering over Knowledge Graphs using Knowledge Base Embeddings

<!--more-->

## 关注问题

基于时序知识图谱的QA目前还没受到足够的关注，没有完善的数据集，没有对应的很好的模型。本文针对这个问题提出了相应的方案，包括构造了时序KGQA数据集CRON QUESTIONS，和提出一个针对时序KG数据的KGQA模型——CRONKGQA

## 时序KG的特点

文章总结了时序KGQA（Temporal KGQA）必须具备的几个特点

1. KG必须是一个时间相关的知识图谱，也就意味着最小组成单元为四元组$(h, r, t, \tau)$
2. Answer 可以为实体或者一个时间间隔（这一点和普通QA区别非常重要）
3. 也是因为第二点，需要复杂的基于时间的推理

## 数据集

基于上述分析的特点，本篇工作构建了新的数据集CRON QUESTIONS。时序KG数据来源于Wikidata，时间精确到年份。经过筛选之后，时序KG包括328k个实例，其中5k为事件性质的数据。

Question的数量：训练集350000，开发集30000，测试集30000

作者在文中对比了提出的数据集与现有的数据集的特性对比，论证了CRON QUESTIONS是包含时序facts，问题覆盖多实体多关系和时序信息（复杂推理模型可用性需要）

## 模型

![CRONKGQA Model Architecture](https://antarx.cn/images/CleanShot%202021-08-10%20at%2012.00.09@2x.jpg)

模型是基于EmbedKGQA进行两部分的修改

1. 把KGE的Model从ComplEx更换为TComplEx实现对时间戳信息的嵌入表示
2. 使用BERT对question进行编码过程，EmbedKGQA只生成了实体表示，CRONKGQA生成了问题的实体编码和时间编码（因为答案可能是时间段），concatenate之后经过Softmax得到最后的答案（评分）。
