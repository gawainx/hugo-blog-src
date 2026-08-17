---
title: 新款 Mac mini 购买可行性分析
date: '2018-11-02 11:20:29'
tags:
- macOS
slug: macmini
draft: false
---
# 新款 Mac mini 购买可行性分析（持续更新）

10 月 30 号苹果的新品发布会，我望眼欲穿的Mac mini 终于在时隔四年之后迎来了“大更新”，正如之前很多 KOL 所“预言”的一样，是一次面向专业人士的一次更新，最高支援了 i7 六核处理器和 64GB 内存和 2TB 固态，还有万兆以太网接口可选。昨天也同步更新了大陆的价格信息。网络上对于这款产品的评价也是褒贬不一，到底这款产品是不是值得购买呢。
<!--more-->
## 处理器
这里只关注 i5 和 i7 版本。
![官网处理器规格表](https://antarx.cn/20181102112846_2NouDo_Screenshot.jpeg)
Apple 一般都会和英特尔有定制处理器，根据[英特尔® 产品规格](https://ark.intel.com/zh-cn#@PanelLabel122139)，查找 i5 处理器的规格表
![第八代 i5 处理器](https://antarx.cn/20181102113138_9aUiT7_Screenshot.jpeg)
从基准频率，睿频频率和 L3 缓存规格，基本可以确认，Mac mini 使用的 i5 处理器就是这款 8500B，是基于桌面版的 8500 的修改款。
同样可以找到[第八代智能英特尔® 酷睿™ i7 处理器 产品规格](https://ark.intel.com/zh-cn/products/series/122593/-i7-)，可以基本确认 Mac mini 的 i7 处理器是 8700B，是桌面版 8700（不带 k）的修改版（为了适配 Mac mini 的体积而进行散热性能的更改）。
可以看到，对比上一代的 Mac mini 使用的低压移动平台处理器，这次的升级可以说是一脚踩爆了牙膏管。
要注意的是，第八代 i5 和 i7 处理器（上面说的这两款），最大的区别是超线程支持上，也就是说只有 i7 8700B 这款处理器支持超线程，为 6C12T（6 Core 12 Thread）规格。
## 内存
内存其实没啥好说的，横跨 8GB 到 64GB。
比较有意思的是，这一代重新采用了 SO-DIMM 的可插拔内存，理论上可以买 8GB 版本回来自己扩充到 32G 内存，还能省 2000 元。具体的内存更换教程和内存条兼容性报告，等发售和测试之后再更新。
### 一点吐槽和一点疑问
官网的自定义配置上，从 8GB 内存升格到 32GB 内存居然要加四千多。问题是现在内存价格已经回落了啊！！！
官网的宣传图片和规格上说是可插拔内存插槽，是不是意味着可以买低内存版本回来自己加爆到 32*2=64G 内存呢？具体情况关注 ifixit 的拆解情况再作判断。
## 显卡/GPU
应该是这次“面向专业人士的升级”中最值得吐槽的地方。
之前微博上一直有说法，这次的 Mac mini 会选配 GTX 1050 图形处理器。
然而，然而，最后的结果是，全系列，Intel UHD630 集成图形处理器。
这个 GPU 是什么概念呢，在显卡天梯图上，这款产品的规格甚至比 2015 mid 的MacBook Pro 15 吋低配的 4770HQ 处理器内置的 Iris 5200 还要低。（能不能顺利带动我的 P2415Q 是很让我困惑的一件事，虽然官网规格说支援同时带两个 4k 显示器）
## 接口
之前一直很担心 Mac mini 更新会不会只给 Thunderbolt 3 接口，甚至连以太网接口会不会砍掉，幸好最后库克证明是我多虑了。
![Apple官网接口规格](https://antarx.cn/20181102120058_gkxv7d_Screenshot.jpeg)
四个 Thunderbolt 3 接口，两个 USB3.0 接口，还有 HDMI2.0 和千兆以太网接口（可选万兆），覆盖了日常使用的所有接口类型，总而言之，管够！
## 外接设备的可能性探讨
最重要的外接设备形式，就是自 macOS High Sierra 10.13.4 开始支援的 eGPU 了。关于 Mac 对 eGPU 原理的讨论，大别[ibuick的微博](https://weibo.com/ibuick?profile_ftype=1&is_article=1#_0)上面有篇文章讨论的非常详细，我这里就不班门弄斧。有需要的可以自行参阅研究。
总的来说，外接 eGPU 可以满足视频渲染、照片处理等重型任务的需求，对于程序员（包括我）最关心的科学计算、深度学习任务可不可以使用 eGPU 进行加速的问题，目前调查到的情况有这几点：
1. 显卡硬件方面。
    - NVIDIA Pascal 及以上架构的显卡（GTX10 开始）在 macOS Mojave 10.14 系统上还没发布驱动包（据说是还没通过苹果的审核）。
    - AMD 显卡，有[ROCm, a New Era in GPU Computing](https://rocm.github.io/index.html)方案实现 TensorFlow 调用 AMD GPU 资源进行计算加速。问题是 ROCm 到目前为止不支持 macOS。

2. 软件兼容性层。NVIDIA 有发布 CUDA 以及 CuDNN for macOS。
    - 同样的，这两个软件依然没有支持 macOS Mojave
    - TensorFlow for macOS 可以通过自编译的方式实现 GPU 支持。
    - 就算以后打通了 NVIDIA eGPU + CUDA + CuDNN + TensorFlow for macOS 的完整流程，由于 Docker for macOS 是一种虚拟机实现方案，所以也许永远不会有 Nvidia-Docker for macOS 来实现更简单的开发环境部署和 Python 环境隔离。
3. 对于 macOS High Sierra 系统和 Pascal 以下的显卡，已经有非常详细的教程[Training Your Neural Net with eGPU Acceleration on Mac with Tensorflow 1.5](https://medium.com/@jianshi_94445/training-your-neural-net-with-egpu-acceleration-on-mac-with-tensorflow-1-5-b2b729f4e408)实现 2.3 所说的完整流程。

## 其他外接设备
### 显示器
- 预算有限的，可以选 dell P2415Q，目前非 Ultrafine 荧幕里面 PPi 最接近视网膜的。接一般的 4k 荧幕（泛指所有尺寸在 27 寸及以上的 4k 荧幕），同样可以实现 HiDPI 缩放，具体判断是接入显示器之后，设置连接模式为扩展，然后打开显示器选项，选择缩放，看到的是下面这样的截图![](https://antarx.cn/images/20181103161045_fOD6Fx_Screenshot.jpeg)而不是让你选择物理分辨率。HiDPI 技术对显示效果的影响，具体来说就是两种显示器（支持 HiDPI 和普通显示器），macOS 在渲染输出的时候会采用不同的色彩空间（对于后者，在系统中会被识别成“电视”，使用 YUV），看起来会觉得后者的字体锯齿甚至比 Windows10 外接高分屏荧幕更加严重。2k 显示器可以通过软件修改的方式实现 HiDPI，缺点是每次系统升级都可能导致不能用。
- 预算充足的，直接 LG Ultrafine 系列。
### 机械键盘
ikbc G104 和阿米洛的 Mac 系列都是原生 Mac 键位支持。也可以买 Windows 键盘回来自己改键位和键帽，全凭个人喜好了。
