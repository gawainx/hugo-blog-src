---
title: 博客迁移腾讯云小记
date: '2018-05-11 17:30:58'
tags:
- hexo
slug: hexossl
draft: false
---
# 博客迁移腾讯云实战记录

源于年初的一次突发奇想，将博客站点迁移到了腾讯云，五月份终于完成了备案，然后添加了 HTTPS 支援，并完成容器化。在这里把折腾的过程记录下来。

<!--more-->

## 转移腾讯云

原来的博客是放到 github page 上面，访问 **antarx.com** 是通过 CNAME 文件解析到 gawainx.github.io，只需要在`config.yaml`配置好，写完直接`hexo d -g`完事。

迁移到腾讯云之后，还想每次部署都这么方便，就免不了完成一些相关工作。

### 资源准备

这里准备的资源主要就是服务器的购入，可以根据自己博客的规模需要选择合适的套餐。如果是学生党记得使用学生优惠。
买完服务器就是装系统的事，根据自己的使用习惯自行选择，我用的是 ubuntu16.04.
如果想容器化的话需要安装 Docker。

### 安装 git

```shell
sudo apt-get install git
```

### 新建 git 裸仓库

```shell
sudo mkdir /var/repo/
sudo chown -R $USER:$USER /var/repo/
sudo chmod -R 755 /var/repo/

cd /var/repo/
git init --bare hexo_static.git
```

### 创建存放 hexo 生成的网页的文件夹

```shell
sudo mkdir -p /var/www/hexo
sudo chown -R $USER:$USER /var/www/hexo
sudo chmod -R 755 /var/www/hexo
```

这两步要注意的是文件夹的 owner 问题，要实现自动部署的话一般新建一个 git 账户然后全权接管部署网页的相关工作，那么上面创建的两个文件夹在后期的 owner 记得要变更为 git 用户。

### 创建 git 钩子

在`hexo_static.git`文件夹的 hooks 目录下面新建钩子文件并写入如下代码，然后将文件变更成可执行文件。

```shell
vim /var/repo/hexo_static.git/hooks/post-receive

# post-receive file content

#!/bin/bash
git --work-tree=/var/www/hexo --git-dir=/var/repo/hexo_static.git checkout -f

chmod +x /var/repo/hexo_static.git/hooks/post-receive
```

### 自动部署

所谓自动部署，就是在每次部署的时候不需要键入密码。
在自己电脑上，创建公钥，复制到剪贴板

```shell
ssh-keygen -t rsa -C "xx@xx.com"
pbcopy < ~/.ssh/id_rsa.pub
```

服务器上，切换到 git 用户（没有的话请新建），输入

```shell
su git
cd ~
mkdir .ssh
vim .ssh/authorized_keys
#粘贴自己电脑的 公钥，然后保存
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

### 本地 hexo-git 配置

在`config.yaml`键入

```YAML
deploy:
    type: git
    repo: git@CVM 云服务器的IP地址:/var/repo/hexo_static
    branch: master
```

## 添加 SSL 证书并容器化 Nginx

Linux 配置软件向来复杂，所以毫不犹豫选用 docker 容器进行 Nginx 部署。
输入`docker pull nginx`拉取 Nginx 镜像。

首先基于镜像运行一个 nginx 容器，然后将容器里面的`/etc/nginx/`目录拷贝出来。
这里顺带一提 Nginx 的两个配置文件，`nginx.conf`和`deafult.conf`，一般而言修改`nginx.conf`然后把`deafult`里面的内容注释掉会比较妥当。

### 添加 SSL 证书

在拷贝出来的`nginx.conf`文件，在`http`的选型里面，加入以下内容

```shell
server {
        listen 443;
        server_name 你的站点名称; #填写绑定证书的域名
        ssl on;
        ssl_certificate /cert/你的证书.crt;
        ssl_certificate_key /cert/你的私钥.key;
        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; #按照这个协议配置
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;#按照这个套件配置
        ssl_prefer_server_ciphers on;
        location / {
            root   /blog; #站点目录
            index  index.html index.htm;
        }
    }
```

如果强制使用 HTTPS，还要加上以下配置，将80端口的流量重定向到443端口。

```shell
server {
        listen 80;
        server_name antarx.com;
        rewrite ^(.*)$ https://${server_name}$1 permanent;
    }
```

这两个 server 是独立的，都加到`http`的配置里面。
顺带一提 Nginx 要求的证书是 PEM 格式。

运行博客容器

```shell
docker run -d -p 443:443 -p 80:80 -v `pwd`:/etc/nginx -v /var/www/hexo:/hexo -v "$PWD/cert":/cert --name ng nginx
```

这里注意到的是三个挂载卷，分别是配置文件，博客网页文件和证书文件。

容器运行之后，在腾讯云的域名管理里面添加 DNS 记录，OK，大功告成。

## 相关链接

[在 Ubuntu 14.04 服务器上部署 Hexo 博客](https://cloud.tencent.com/developer/article/1004587)
[Hello Hexo之静态博客搭建+自动部署](https://cloud.tencent.com/developer/article/1004839)
[证书安装指引](https://cloud.tencent.com/document/product/400/4143)
[Nginx 容器教程（可能无法访问）](http://www.ruanyifeng.com/blog/2018/02/nginx-docker.html)