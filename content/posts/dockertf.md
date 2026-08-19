---
title: TensorFlow For Docker 初体验
date: '2017-12-06 21:30:22'
tags:
- TensorFlow
- Docker
- ML
slug: dockertf
draft: false
---

---

TensorFlow 是一套开源的机器学习工具。一般来说只用 TensorFlow 的话配置运行环境什么的并没有特别坑的地方，但如果想用到 GPU 加速计算的话配置起来就要费好大一番力气了，还经常遇到各种版本不兼容、找不到依赖关系等问题，让人头疼。而 Docker 刚好是解决开源软件各种依赖关系的神物，NVIDIA 刚好又有工具能让容器用上 GPU 进行计算。

下面分享配置过程。

测试环境是 GTX850M+Ubuntu16.04.3+CUDA9.0+GeForce 384.00

驱动及 CUDA 安装过程参考即将到来的另一篇文章。

<!--more-->

# 安装 Docker

可以用`curl -sSL https://get.daocloud.io/docker | sh`这条命令快速安装 Docker，不过，这个安装脚本默认会安装最新版本的 Docker（当前是17.11.0 docker-ce），而 NVIDIA Docker 并不支持这个新版本（跪

所以要进行一下卸载再降级操作...

```shell
# uninstall docker
sudo apt-get purge docker-ce
# 查看软件库中可用的历史版本
sudo apt-cache policy docker-ce
# install docker-ce 17.09
sudo apt-get install -y docker-ce=17.09.0~ce-0~ubuntu
```

值得一提的是17年的某个版本开始，docker 的软件包统一到 docker-ce（社区）和 docker-ee（付费企业版）上面来了，开发使用的主要以 docker-ce 为主，网上很多教程（尤其是2016年、2016年的）说到安装 docker 的软件包名叫例如 lxc-docker docker.io 等的都是老旧版本的。

# 安装 NVIDIA-docker

[Nvidia-Docker](https://github.com/NVIDIA/nvidia-docker)是老黄提供的一套在 Docker 上制造跑核弹的工具（。

简单来说，这套工具提供了一个运行时，用来连接 Docker 容器和物理设备的 GPU 资源，使得 Docker 容器可以直接访问、调用物理机的 GPU 资源进行密集型计算操作。

安装步骤如下：

```shell
# Add the package repositories 添加软件仓库
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
```

在 Ubuntu16.04测试通过。

# 安装 TensorFlow 的 Docker 镜像

TensorFlow 官方提供了 for Docker 的镜像，里面集成了完整的依赖关系，免去了用`pip`安装各种包的烦恼。

镜像包含很多 tag，常用的有下面几个：

- tensorflow/tensorflow:latest，运行环境是 python2.7，仅支持 CPU
- tensorflow/tensorflow:latest-gpu，运行环境是 python2.7，支持 GPU 计算
- tensorflow/tensorflow:latest-py3，运行环境是 python3.5，仅支持 CPU
- tensorflow/tensorflow:latest-gpu-py3，运行环境是 python2.7，支持 调用GPU

我自己用的是最后一个。

首先下载镜像下来。

```shell
docker pull tensorflow/tensorflow:latest-gpu-py3
```

然后跑个 python3交互环境试试水

```shell
docker run --runtime=nvidia --rm -it tensorflow/tensorflow:latest-gpu-py3 python3
```

在交互环境下输入`import tensorflow as tf`，如果没提示依赖库错误则说明安装成功。

上面的`—runtime=nvidia`为调用 nvidia-docker 工具包（运行时）而不是标准运行时来运行镜像，只有加了这个选项才能调用 GPU。

最后跑一下多重感知机训练手写数字识别。输出显示调用 GPU:0进行计算，说明配置一路顺风了。