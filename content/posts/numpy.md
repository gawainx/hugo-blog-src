---
title: numpy学习笔记（1）--ndarray类型常用属性
date: '2015-12-23 22:39:36'
tags: 
categories: 
description: 
slug: numpy
draft: false
---
# 前言
NumPy是python中用于机器学习和科学计算的常用库。opencv for python中`cv2.imread('image.jpg')`命令读取图像返回的数据类型也是ndarray。今天将`ndarray`的一些常用属性记录下来，以便以后学习时进行参考。
<!--more-->
# ndarray常用属性
1. **size**: 表示array中拥有的总元素数量。
2. **shape**: 元组类型。该属性描述了ndarray的“形状”信息。shape[0]为行信息，shape[1]为列信息。
![example](http://7xpabg.com1.z0.glb.clouddn.com/ndarray-shape.PNG)
3. **strides**: 元组数据类型该属性返回每一个维度上元素的数量。
4. **ndim**: 表示这个ndarray的维度。也可以理解为**shape**属性返回的元组的数量。
5. **T**:表示ndarray矩阵的转置。

今天使用opencv做简单的图像处理时接触到的ndarray的相关属性主要就是以上5个。以后再学习过程中遇到的更多有用的属性时会及时做补充。
