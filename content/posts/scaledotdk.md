---
title: 为什么Scale-Dot Attention的分母是根号d
mathjax: true
tags:
- Transformer
- NLP
date: '2021-08-27 19:07:49'
slug: scaledotdk
draft: false
---

今天跟朋友讨论的一道有趣的面试问题：为什么Transformer中Scale-dot attention计算 $Attn = \text{Softmax}(\frac{QK^T}{\sqrt{d_k}})V$，缩放因子一定是$\sqrt{d_k}$ 而不是d_k或者其他形式？
