---
title: 论文阅读：Rethinking Positional Encoding In Language Pre-Training
date: '2021-07-26 22:24:58'
tags:
- Transformer
slug: tupe
draft: false
---

出处：ICLR 2021
代码链接：https://github.com/guolinke/TUPE

<!--more-->

本文讨论了Transformer结构的位置编码（Position Encoding）问题。

## 动机
作者首先指出，现有的Transformer模型在处理位置编码的时候，通常将word embedding与位置编码信息直接相加，然后送入Multi-Head Attention结构中。这种做法让两种信息相互干扰，引入噪声信号。

其次，在序列分类任务中，会在句首附加 `[CLS]` 用于捕捉全局信息并将其用于分类。然而，将[CLS]直接放在句首的做法无法真正捕捉到全局的信息，因为作者认为，`[CLS]`是和普通词汇完全不一样的符号，如果`[CLS]`享有和其他词汇一样的位置编码信息，则难以满足出发点（捕获全局信息）。

## 方法
由这两个出发点，本文做了两点针对性的贡献。

第一，将位置编码与词汇编码分离，单独训练Query矩阵和Key矩阵进行映射和乘积，然后加到word 的Q、K相乘之后的结果中（可以认为是一个偏置项）。

第二，全局化`[CLS]`的贡献，在其他模型的设计中，`[CLS]` 到其他 token 的权重以及其他token到 `[CLS]` 的权重有区别的，本文使用了统一权重。也就意味着，`[CLS]` 到其他 token 的权重是同一个参数$\theta_1$，其他token到 [CLS] 的权重是同一个参数$\theta_2$。

## 代码实现
这篇文章的代码已经开源，两个方法在实现细节上代码如下
```python
seq_len = x.size(0)
# 0 is for other-to-cls 1 is for cls-to-other
# Assume the input is ordered. If your input token is permuted, you may need to update this accordingly
weight = self.pos_ln(self.pos.weight[:seq_len + 1, :])
pos_q =  self.pos_q_linear(weight).view(seq_len + 1, self.num_attention_heads, -1).transpose(0, 1) * self.pos_scaling
pos_k =  self.pos_k_linear(weight).view(seq_len + 1, self.num_attention_heads, -1).transpose(0, 1)
abs_pos_bias = torch.bmm(pos_q, pos_k.transpose(1, 2))
# p_0 \dot p_0 is cls to others
cls_2_other = abs_pos_bias[:, 0, 0]
# p_1 \dot p_1 is others to [CLS]
other_2_cls = abs_pos_bias[:, 1, 1]
# offset 
abs_pos_bias = abs_pos_bias[:, 1:, 1:]
abs_pos_bias[:, :, 0] = other_2_cls.view(-1, 1)
abs_pos_bias[:, 0, :] = cls_2_other.view(-1, 1)
```

首先是位置编码在取的时候去了`L + 1`长度，在乘法出来之后变成 $L+1 \times L+1$ 的矩阵`abs_pos_bias`，刚好比常规的$L \times L$多了四个元素，`[0][0]`和`[1][1]`分别用来表示[CLS] to others 和others to [CLS]。

把原来的矩阵切割掉第一行第一列然后填充回去。


