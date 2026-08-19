---
title: 论文阅读：Improving Multi-hop Question Answering over Knowledge Graphs using Knowledge
  Base Embeddings
mathjax: true
tags:
- KGQA
- KGE
date: '2021-08-09 16:29:12'
slug: embedkgqa
draft: false
---

来源：ACL 2020
领域：KGQA
模型：EmbedKGQA
核心模型：ComplEx；BERT/RoBERTa
代码：[GitHub](https://github.com/malllabiisc/EmbedKGQA)

## 关注问题

多跳KGQA中，KG的不完整性带来独特的挑战。现有解决方案中包括使用文本，但文本不一定存在；KGE可以解决补全问题，但还没有研究将两者结合在一起，本文是这方面的一次尝试。

## Model

模型分为三个核心模块：KG Embedding Module，Question Embedding Module，Answer Selection Module。

- KG Embedding Module：和现有KGE模型的目的一致，生成实体的表示向量。本文使用ComplEx作为KGE模型。
- Question Embedding Module：生成问题的表示。使用预训练模型RoBERTa生成question的表示向量，然后经过4层全连接网络生成实数部分和虚数部分的表示向量$e_q$（用于后续使用ComplEx进行评分）

### Answer Selection Module

答案选择器用于生成最后的实体选择。首先，使用ComplEx的打分函数生成分数$\phi (e_h, e_q, e_{a'})$，这种方式在候选实体很少的时候是适用的，但有些KG候选实体非常多。因此，引入pruning机制进行实体筛选打分。

$$
h_q = \text{RoBERTa}(q') \\
S(r, q) = \text{sigmoid}(h_q^Th_r)
$$

筛选$S(r, q)$ 大于0.5的关系集合$\mathcal{R}\_a$, 以及最短路径关系集合$\mathcal{R}_{a'}$, 得到一个关系分数

$$\text{RelScore}_{a'}=\vert \mathcal{R}_a \cap  \mathcal{R}_{a'} \vert$$

最终分数$e_{ans} = \text{argmax}(\phi (e_h, e_q, e_{a'})) + \gamma * \text{RelScore}_{a'}$

## 延伸

写作的时候遇到行内数学公式渲染错误的问题，Follow了[这个Post](https://m3df.xyz/2021/06/25/b63b2b2d/)的解决方案。
