---
title: 论文阅读：Generative Adversarial Zero-Shot Relational Learning for Knowledge Graphs
date: '2021-08-02 16:32:02'
tags:
- Knowledge Graph
slug: zskgc
draft: false
---

来源：AAAI 2020
代码：[GitHub](https://github.com/Panda0406/Zero-shot-knowledge-graph-relational-learning)
关注问题：零样本关系的知识图谱补全

<!--more-->

在知识图谱补全问题中，已有研究主要放在大样本或者少样本场景，很少关注零样本关系的补全。所谓零样本是指在已有KG中完全没有这个关系相关的三元组信息。

大样本场景中，每个关系都有充分的三元组数据用于训练，在测试的时候，所有关系都是在训练过程中可以看到的；一样本/少样本场景设定中，测试阶段的关系在训练过程中不可见，只提供了K个实例作为支持集，已有模型可以从K个已知实例中挖掘信息学习关系表示。

零样本关系表示学习和对应的补全问题显然是一个更具挑战性的场景，核心问题就是如何去表示零样本关系。

本文作者创造性采用对抗训练手段试图从关系描述的文本中获得良好的关系表示。

对于背景图关系的三元组，随机采样作为真实样本实例，使用Neighbor Encoder增强表示之后，获取质心信息作为真实关系表示。

对于关系本身，每个关系提供了一定长度的文本信息，使用TF-IDF从文本中获取向量表示，加入随机生成的高斯噪声向量之后，经过Generator生成Fake的关系表示。这个生成的关系表示和上述经过实体对生成的关系表示一起送入Discriminator网络，产生判别结果。

## 模型训练

生成器训练：生成器的Loss分三部分，第一部分是Wasserstein Loss，第二部分为分类Loss，因为前面质心作为真实的关系表示，那么就可以用margin ranking loss来训练表示过程。除此之外，还包括visual pivot regularization，目标是提供足够的跨class判别能力。

判别器训练：判别器的目标是区分生成的关系向量和真实的关系向量，Loss组成包括Wasserstein Loss、分类器Loss和对输入进行二分类（用于判别是否为真实数据）的Loss以及Gradient Penalty Loss。

## 实验

针对这个问题提出了两个数据集ZS-NELL和ZS-Wiki，并在此基础上开展实验。所提出的方法是和已有的一些embedding方法兼容的（在Model一开始提到有预训练阶段获取实体的表示，应用主流的embedding方法获取）。一个值得注意的实验结果是，作者把word2vec替换为BERT，反而出现的性能下降的情况。
