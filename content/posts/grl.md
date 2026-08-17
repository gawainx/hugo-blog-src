---
title: "【论文阅读】Generalized Relation Learning with Semantic Correlation Awareness for
  Link Prediction"
date: '2021-03-01 14:31:38'
toc: false
mathjax: true
summary: 链接预测场景中一种通用的关系表示框架
categories:
- Markdown
tags:
- KGC
- NLP
slug: grl
draft: false
---

本文发表于AAAI 2021，关注了知识图谱补全任务的少样本场景问题。
<!--more-->

## 核心问题
目前大规模知识图谱普遍存在不完整的问题，需要使用链接预测技术对知识图谱进行补全。而现有的链接预测模型普遍存在两个问题：
1. 难以应对关系的不平衡性。所谓不平衡，是指不同关系的训练样本数据量级差别