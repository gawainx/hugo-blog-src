---
title: 计算字符串的最短编辑距离（Python版本）
mathjax: false
tags:
- Python
- 动态规划
date: '2022-07-27 20:18:52'
slug: stredit-python
draft: false
---

## 问题描述

*Levenshtein* 距离，又称编辑距离，指的是两个字符串之间，由一个转换成另一个所需的最少编辑操作次数。许可的编辑操作包括将一个字符替换成另一个字符，插入一个字符，删除一个字符。编辑距离的算法是首先由俄国科学家 Levenshtein 提出的，故又叫 Levenshtein Distance 。

例如：
字符串A: `abcdefg`
字符串B: `abcdef`
通过增加或是删掉字符 ”g” 的方式达到目的。这两种方案都需要一次操作。把这个操作所需要的次数定义为两个字符串的距离。
要求：
给定任意两个字符串，写出一个算法计算它们的编辑距离。

## 代码

```python
if __name__ == '__main__':
    src = input().strip()
    target = input().strip()
    # 注意下标，因为字符串长度是len(src)，因此下标要+1
    lns, lnt = len(src) + 1, len(target) + 1
    # 初始化动态规划表格
    table = [[0 for _ in range(lnt)] for _ in range(lns)]
    # target为空串的时候，编辑距离为i次删除操作
    for i in range(lns):
        table[i][0] = i
    # source为空串的时候，那么从source到target的编辑距离为j次插入操作
    for j in range(lnt):
        table[0][j] = j
    # 因为0已经做了，所以从1开始
    for i in range(1, lns):
        for j in range(1, lnt):
            if src[i - 1] == target[j - 1]:
                table[i][j] = table[i - 1][j - 1]
            else:
                # 通过插入获得target的距离，插入为一次操作，递归回来到长度i到长度j-1需要的操作
                ins_dist = table[i][j - 1] + 1
                del_dist = table[i - 1][j] + 1
                # why ?
                rep_dist = table[i - 1][j - 1] + 1
                table[i][j] = min(ins_dist, del_dist, rep_dist)
    print(table[-1][-1])
```