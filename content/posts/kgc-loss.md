---
title: 知识图谱补全任务中的Loss函数
mathjax: false
tags:
- Typora
- Markdown
date: '2021-08-11 16:39:43'
slug: kgc-loss
draft: false
---

本篇汇总知识图谱补全任务（知识图谱链接预测任务）中的损失函数。因为链接预测任务是一个排序任务，因此loss的选择会影响最后排序的规则。
<!--more-->

## Margin-based Loss

最早由TransE模型提出，之后绝大部分链接预测模型都采用这种损失函数。

基本形式

$$
\mathcal{L} = \sum_{(h,r,t) \in \mathcal{G}} \sum_{(h,r,t') \in \mathcal{G}^{'}} max(0, \gamma - (score_{(h,r,t)}-score_{(h,r,t')}))
$$

公式中，$\gamma$ 为超参数，也就是margin。$\mathcal{G}$ 为正样本， $\mathcal{G}^{'}$为负采样。在实际应用中，可以采取替换尾部实体的方法实现负采样。

在Coding方面，max函数可以使用ReLU激活函数实现。比较简洁。

```python
def margin_loss(margin, pos, neg):
    margins = pos - neg
    return torch.relu(margin - margins).mean()
```

## Softplus Loss

在ComplEx文章中提到，Margin Loss容易出现过拟合的问题，因此，引入了likelihood loss，由于实际使用softplus函数，这里把它称为softplus loss

基本形式

$$
\mathcal{L} = \sum_{r(s,o)\in \Omega} \log (1+exp(-\textbf{Y}_{sro}\phi (s,r,o;\Theta))) + \lambda \Vert \Theta \Vert ^2_2
$$

$\textbf{Y}_{sro}$ 为三元组的标签，一般来说1代表正样本，-1代表负样本。

这种loss在ComplEx、SimplE中使用，使用卷积网络的模型ConvKB也使用了这种风格的loss

代码实现（修改自ConvKB提供的版本）

```python
class ComplExLoss(nn.Module):
    """Loss from ComplEx"""

    def __init__(self, lmd):
        super(ComplExLoss, self).__init__()
        self.softplus = nn.Softplus()
        self.lamada = lmd

    def forward(self, scores, labels, regul):
        """

        :param scores: scores output
        :param labels: 1 for positive sample and -1 for negative samples
        :param regul: weight vector
        :return:
        """
        return torch.mean(self.softplus(scores * labels)) + self.lamada * regul
```

当中一个容易出bug的地方就是，scores的符号问题。ConvKB在计算score的时候，线性层输出前面加了负号作为最终输出。

## BCE / CrossEntropy Loss

这种loss将链接预测问题建模为二分类问题，并且通常使用softmax实现稳定训练。

在ConvE和KG-BERT中有使用。
