---
title: 使用动态规划求解字符串编辑距离问题(C#实现）
date: '2015-12-07 22:41:52'
tags:
- 算法
categories:
- 算法
description: 
slug: dp
draft: false
---
# 前言
上次提到会在后续通过实际例子更加深入的谈谈对解释四种[四种基本算法设计模式](http://antarx.com/2015/11/16/%E5%9B%9B%E7%A7%8D%E5%9F%BA%E6%9C%AC%E7%9A%84%E7%AE%97%E6%B3%95%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F/)的理解。今天说到的,是利用动态规划思想求解两个字符串的编辑距离。
<!--more-->
# 正文
## 问题背景
>我们将两个字符串的相似度定义为：将一个字符串转换为另一个字符串时需要付出的代价。转换方法包括插入，删除和替换三种编辑方式。使用对字符串的编辑次数定义为转换的代价。最小的字符串编辑次数就是字符串的编辑距离。                             --《算法的乐趣》

## 问题分析
要使用动态规划思想解决这个问题，首先我们需要对问题进行阶段划分，确定边界条件，定义无后效性的几个子状态并且确定状态之间的转移关系，才能在每个子状态中寻找最优解最后得到原问题的解。

寻找子问题：在本问题中，假设原字符串为`source`，长度为m，目的字符串为`target`，长度为n。则问题可以描述为求解`source[1..m]`转换为`target[1..n]`所需要的最小编辑次数。注意到，当`source`的前i个字符和`target`的前j个字符之间的编辑距离确定之后，不会在后续求解中发生改变，因此此问题的子问题即可定义为求解`source`的前i个字符和`target`的前j个字符之间的编辑距离。

边界条件的确定：当source字符串长度为0时，编辑长度为target的字符串长度n（插入n个字符串）。当target的字符串长度为0时，编辑长度为source的字符串长度（删去m个字符串）。

关于“备忘录”：动态规划问题的一个特点是使用类似”备忘录“的”表“记录每个状态的相关信息。本问题中用`d[i,j]`定义为`source`的前i个字符和`target`的前j个字符之间的编辑距离，作为每个状态的标志。

状态之间的转换：以`d[i-1,j]+1`为删除字符时转移的状态,`d[i,j-1]+1`为插入字符时转移额状态，`d[i-1,j-1]+1`为替换字符串时转移的状态。

子问题的最优解：字符串之间的转换方式并不是唯一的，通过操作若干次添加字符，删除字符，替换字符操作都可以实现字符串转换，每次转换状态时，将三种操作方式中的距离的最小值作为`d[i,j]`，可以保证每个子问题的解都是最优的，从而保证整个问题的解是最优解。

## 具体代码
使用C\#语言实现。

    using System;

	namespace EditDistance
	{
    	class Program
    	{
        	public static int MAX_STR_LEN = 100;//initialize the max length of string
        	static void Main(string[] args)
        	{
				//test code
            	Console.WriteLine("Please input Source string:");
            	String src = Console.ReadLine();
            	Console.WriteLine("Please input Target string:");
            	String dist = Console.ReadLine();
            	Console.WriteLine(EditDistance(src, dist));
        	}
        	private static int EditDistance(string src, string dist)
        	{
            	int i, j;
            	int[,] d = new int[MAX_STR_LEN,MAX_STR_LEN];
				//initialize the margin condition
            	for (i = 0; i <= src.Length; i++)
            	    d[i, 0] = i;
            	for (j = 0; j <= dist.Length; j++)
                	d[0, j] = j;
            	for(i = 1;i<=src.Length;i++)
            	{
                	for(j=1;j<=dist.Length;j++)
                	{
                    	if(src[i-1]==dist[j-1])
                    	{
                        	d[i, j] = d[i - 1, j - 1];
                    	}
                    	else
                    	{
                        	int edIns = d[i, j - 1] + 1;
                        	int edDel = d[i - 1, j] + 1;
                        	int edRep = d[i - 1, j - 1] + 1;
                        
                        	d[i,j]=Math.Min(Math.Min(edIns,edDel),edRep);
                    	}
                	}
            	}
            	return d[src.Length, dist.Length];
        	}
    	}
	}

运行结果：

# 后记
求解字符串的编辑距离问题应该是动态规划的最典型案例，体现了动态规划问题的基本特点。适合用动态规划解决的问题，一般都是可以划分多多个子状态的，每个子状态之间存在状态转移关系，每个状态的解一旦确定，就会用类似“备忘录”的表储存起来。在后续求解时，将会直接使用该状态的解，而且，**不会再回溯子状态的时候改变该状态的解**。

另外，边界条件的确定是问题求解时的一个重要步骤。如果忽略了边界条件，或者在求解时没有正确初始化边界条件（比如在本题中对`d[i,0]`和`d[0,j]`需要初始化为i和j），将得不到正确的解。