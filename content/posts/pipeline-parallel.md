+++
date = '2026-05-25T11:22:44+08:00'
draft = false
title = 'Pipeline Parallel - 流水线并行基础知识整理'
+++

## 基础概念

流水线并行把大模型按照 Layer 来切分，然后不同layer的完整权重会放到不同的 GPU 上

在实际执行时，每个GPU执行完该layer的运算之后，把运算结果交给下一层。

在流水线并行中，会把一个大batch拆分成多个 micro batch。

主要应用在训练中。

## 卡间通信或者集合通信原语

forward 阶段：每个stage的激活值、隐藏状态传递到下一个stage

backword 阶段：每个stage的激活gradient

使用到的集合通信如下：

- send: 发送tensor到目标rank
- recv: 通过buffer来接受消息

异步操作 isend 和 irecv