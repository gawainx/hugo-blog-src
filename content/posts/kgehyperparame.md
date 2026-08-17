---
title: 知识图谱补全模型与超参数整理
mathjax: true
tags:
- Knowledge Graph
- Embedding
date: '2021-08-24 21:24:16'
slug: kgehyperparame
draft: false
---
本篇整理几种常见的知识图谱补全模型的原理以及对应的超参数。

<!--more-->

## RESCAL

论文出处：A three-way model for collective learning on multi- relational data, ICML 2011

这是一种基于张量分解方法的嵌入模型。发表的年份非常早。原文中并没有提及学习率等超参数。

## TransE

论文出处：Translating Embeddings for Modeling Multi-relational Data

TransE模型算是最经典被使用最多的基于嵌入技术的知识图谱补全模型。基本假设也非常优美，以$\Vert h+r-t \Vert_p$ 作为评分函数。如果$(h, r,t)$ 能够成为三元组，那么这个评分应该足够低。

可调超参数：

- 学习率：在原文中，学习率对数据集Wordnet, FB15k, FB1M 均为0.01。
- KG向量的维度
- margin：因为TransE使用了margin ranking loss，因此margin是一个重要超参数。原文给出的搜索范围是$\{1, 2, 10\}$
- p：使用范数作为打分函数，那么使用1范数还是2范数这也是一个可以调整的超参数


## DistMult

论文出处：[Embedding Entities And Relations For LearnIng And Inference In Knowledge Bases](https://arxiv.org/pdf/1412.6575.pdf)

这是一种双线性模型。将头尾实体表示成向量之后，把关系表示成一个对角矩阵，并且有对应的打分函数$s = \textbf{y}_{e1}^T\textbf{M}_{r} \textbf{y}_{e2}$

依然使用MarginLoss来优化。

超参数：

- Learning Rate：0.1
- Optimizer: AdaGrad
- L2正则化因子：0.0001
- Training Epoch：300 for WordNet，100 for FB15k and FB15k-401

## ComplEx

论文出处：Complex Embeddings for Simple Link Prediction

ComplEx将实体和关系嵌入到复数空间中，并且开发了一个相应的打分函数。同时，提出了一个基于Softplus和$L_2$正则化的Loss函数

$$
min\sum_{r(s, o)\in \Omega} \log(1+\exp(-\textbf{Y}_{rso}(\phi(s, r, o;\Phi))))+\lambda\Vert\Theta\Vert_2^2
$$

$\lambda$ 作为两部分loss的平衡因子。原文在$\{0.1, 0.03, 0.01, 0.003, 0.001, 0.0003, 0.00001, 0.0\}$ 之间进行调整。

在模型训练方面，使用SGD优化器，但并没有提供相应的学习率信息。

## SimplE

论文出处：[SimplE Embedding for Link Prediction in Knowledge Graphs](https://arxiv.org/pdf/1802.04868.pdf)

这是一种基于CP分解（Canonical Polyadic (CP) decomposition）的嵌入模型。

训练的Loss和ComplEx类似

超参数

- Epoch：1000
- batch size：100
- Learning Rate：0.1 for WN18 and 0.05 for FB15k
- Optimizer: AdaGrad
- Embedding Size: 200 for WN18RR, FB15k
- $\lambda$ search from $\{0.1, 0.001, 0.03\}$

## RotatE

论文出处：[Rotate: Knowledge Graph Embedding By Relational Rotation In Complex Space](https://arxiv.org/pdf/1902.10197.pdf)

这是一种将头尾实体之间的关系建模为旋转操作的KGE模型

训练loss形式：

$$
\mathcal{L} = -\log\sigma(\gamma-d_r(v_h, v_t))-\sum p(h'_{i}, r, t'_i)\log\sigma (d_{r}(v_{h'}, v_{t'})-\gamma)
$$

超参数主要跟loss有关系：

- Embedding Dimension: $\{125, 250, 500, 1000\}$
- Batch Size: $\{512, 1024, 2048\}$
- self-adversarial sampling temperature $\alpha \in \{0.5, 1.0\}$
- margin $\gamma \in \{3, 6, 9, 12, 18, 24, 30\}$
