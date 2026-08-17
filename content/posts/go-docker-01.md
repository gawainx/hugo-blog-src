---
title: go docker client 使用教程（一）
date: '2018-05-29 11:05:41'
tags:
- docker
slug: go-docker-01
draft: false
---
# Docker client for golang 使用教程（一）

Docker 官方提供了适用于 golang 的 [client](https://github.com/moby/moby/tree/master/client)，可惜的是网上几乎没有完整可用的使用教程或者例子。在开发[gxd-cli](https://github.com/gawainx/gxd-cli)的过程中，需要大量使用到这个 SDK，所以便有了这个系列。

本篇涉及通过代码运行第一个容器，以及如何挂载卷。
<!--more-->

## 运行第一个容器

```go
/*
 *Gawain Open Source Project
 *Author: Gawain Antarx
 *Create Date: 2018-May-29
 *
*/

package main

import (
	"github.com/docker/docker/client"
	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/container"
	"io"
	"os"
	"context"
	"fmt"
)

func main() {
	ctx := context.Background()
	cli, err := client.NewClientWithOpts(client.WithVersion("1.37"))
	if err != nil {
		panic(err)
	}

	resp, err := cli.ContainerCreate(ctx, &container.Config{
		Image: "alpine:latest",
		Cmd:   []string{"echo","hello"},
	}, nil, nil, "")
	if err != nil {
		panic(err)
	}

	if err := cli.ContainerStart(ctx, resp.ID, types.ContainerStartOptions{}); err != nil {
		panic(err)
	}

	statusCh, errCh := cli.ContainerWait(ctx, resp.ID, container.WaitConditionNotRunning)
	select {
	case err := <-errCh:
		if err != nil {
			panic(err)
		}
	case <-statusCh:
	}

	out, err := cli.ContainerLogs(ctx, resp.ID, types.ContainerLogsOptions{ShowStdout: true})
	if err != nil {
		panic(err)
	}

	io.Copy(os.Stdout, out)
}
```

官方使用`client.NewEnvClient()`来初始化`client`，在 IDE 中提示这个接口已经过时，推荐使用`client.NewClientWithOpts()`。要注意的是，直接调用的时候一般会提示 API 版本不匹配，需要加`client.WithVersion("1.37")`作为参数传入。`1.37`部分可以根据它的错误提示自行修改。

## 绑定卷

将自己代码放入容器中运行时最基本的操作，在命令行中通过`-v {host vol}:{container vol}`实现，在 golang sdk 中，开发者却没有提供这部分的重要说明。通过查阅[issue155](https://github.com/fsouza/go-dockerclient/issues/155)以及[issue1](https://github.com/fsouza/go-dockerclient/issues/132)，得到的解决方案如下。

卷绑定通过`client.ContainerStart()`里面的参数`client.HostConfig`结构的`Binds`传入，传入的类型是`[]string`，这个字符串序列的中每个字符串的格式`{host_vol}:{com_col}`，也就是和命令行的一致。