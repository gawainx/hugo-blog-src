---
title: "【李宏毅机器学习课程笔记】Transformer Decoder"
date: '2021-04-15 15:34:45'
tags: 
slug: decoder
draft: false
---

最近要用Transformer相关的模型，刚好李宏毅的机器学习课更新了相关内容，就看了一下，整理一下笔记草稿。

## Encoder Decoder 结构
首先是Encoder-Decoder结构。Encoder结构将输入数据编码得到向量表示，具体结构在对应的上一节课已经有说了，大体来说就是Self-Attention + 多头。输出可以是和输入相同shape的向量表示或者是一个向量表示，取决于任务场景。

## Decoder
Decoder的作用是根据encoder结果生成信息。Decoder输入的第一个符号肯定是`<BOS>` Begin of Sentence，告诉Deocder需要进行内容生成了。最传统的Decoder会将当前时刻以前所有的生成数据当作当前时刻输入数据。

### Cross Attention
Decoder的内部结构和Encoder差别在于Cross Attention机制。所谓的Cross Attention就是Decoder输出与Encoder的最后一层的输出之间的交互。以Decoder的输出作为query，Encoder的输出作为key 和 Value，同样是应用注意力机制。

### 输出
Decoder产生的向量接Softmax得到最后的输出。也就是说把生成问题建模成了分类问题，以翻译来举例就是当前时刻是某一个char或者word的概率是多少。类别总数就是词表的大小。

### WHEN STOP
因为生成的内容长度不是固定的，所以机器需要知道什么时候才能停止。引入特殊符号`<EOS>` end of sentence 作为句子的结束。如果句子碰到这个符号，那就不要在继续生成新的内容了。

## Teacher Force Decoder