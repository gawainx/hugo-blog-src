---
title: LeetCode 1047：删除字符串中的所有相邻重复项
mathjax: false
tags:
- LeetCode
- Python
- OJ
date: '2022-05-27 12:27:49'
slug: leetcode-1047
draft: false
---

教训记录。

## 题目描述

给出由小写字母组成的字符串 S，重复项删除操作会选择两个相邻且相同的字母，并删除它们。

在 S 上反复执行重复项删除操作，直到无法继续删除。

在完成所有重复项删除操作后返回最终的字符串。答案保证唯一。

示例：

输入：`"abbaca"`
输出：`"ca"`
解释：
例如，在 `"abbaca"` 中，我们可以删除 `"bb"` 由于两字母相邻且相同，这是此时唯一可以执行删除操作的重复项。之后我们得到字符串 `"aaca"`，其中又只有 `"aa"` 可以执行重复项删除操作，所以最后的字符串为 `"ca"`。

提示：

1. `<= S.length <= 20000`
2. S 仅由小写英文字母组成。

## 一种错误解法

自己思维的问题，看到这种题目，感觉题意很显而易见，啪的一声就想用暴力求解

1. 字符串转数组
2. 标记指针`i`，从0开始遍历，遇到俩相邻的字符就转为空，然后回头重新开始
3. 如果i的下一个是空，就往后走找第一个不是空的字符，判断是否相等

代码写好了：

```python
class Solution:
    def removeDuplicates(self, s: str) -> str:
        if len(s) == 1:
            return s
        lt = list(s)
        ln = len(lt)
        i = 0
        while i < ln - 1:
            if lt[i]:
                # not an empty char
                j = i + 1
                while j < ln and not lt[j]:
                    j += 1
                if j == ln:
                    i += 1
                    continue
                if lt[i] == lt[j]:
                    lt[i] = ''
                    lt[j] = ''
                    i = 0 
                    continue
                elif j == ln - 1 and lt[i] != lt[j]:
                    i += 1
                    continue
                else:
                    i += 1
                    continue
            else:
                i += 1
        return ''.join(lt)
```

写得非常丑陋，分类讨论了多种边界情况，测试通过。一提交，超时了。

超时原因也不难理解，每次替换一次就回头重新开始遍历，效率低到没朋友。

忍无可忍看参考答案，解题思路就一个字：栈。

茅塞顿开，五分钟得到第二版方案

```python
class Solution:
    def removeDuplicates(self, s: str) -> str:
        stk = []
        for c in s:
            if stk:
                tp = stk[-1]
                if c == tp:
                    stk.pop()
                    continue
                else:
                    stk.append(c)
            else:
                stk.append(c)
        return ''.join(stk)
```
执行时间非常快，因为只需要过一遍字符串就可以了。思想就是：

1. 每个字符，比较该字符与栈顶元素
    1. 如果相等，把栈顶元素干掉，往后走
    2. 不相等，元素入栈，继续往后走
2. 把最后留在栈中的元素concat然后输出

### 运行结果

```
Accepted
106/106 cases passed (68 ms)
Your runtime beats 77.08 % of python3 submissions
Your memory usage beats 79.87 % of python3 submissions (15.9 MB)
```

