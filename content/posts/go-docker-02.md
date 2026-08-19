---
title: go docker client 使用教程（二）
date: '2018-06-01 11:05:44'
tags:
- go
- golang
- docker
slug: go-docker-02
draft: false
---
# Docker client for golang 使用教程（二）：网络

## 端口绑定

将微服务放到 docker 容器中运行的时候，端口绑定是一个无可避免的问题。在 docker 命令行中，可以通过简单的`-p 8080:80`解决问题。但在 golang client 中，问题却变得复杂起来。

首先来看创建容器的函数签名`func (cli *Client) ContainerCreate(ctx context.Context, config *container.Config, hostConfig *container.HostConfig, networkingConfig *network.NetworkingConfig, containerName string) (container.ContainerCreateCreatedBody, error)`,client 把运行配置拆分成了`container.Config` 和 `container.HostConfig` ，也就是容器内部设置和宿主机设置两项。

要实现端口绑定，首先要在容器设置中设定暴露的端口（exposed ports）。

```go
exports := make(nat.PortSet, 10)
port, _ := nat.NewPort("tcp", "80")
exports[port] = struct{}{}
// in config:
cli.ContainerCreate(ctx, &container.Config{
        ExposedPorts:exports,
}
```

然后，在 host.config 中，设置Host 端口与容器暴露出来的端口的绑定。

```go
ports := make(nat.PortMap)
pb := make([]nat.PortBinding,0)
pb = append(pb,nat.PortBinding{
    HostPort:"8080",
})
ports[port] = pb

//in Host.config
&container.HostConfig{
    PortBindings:ports,
}
```

至此，在代码中就实现了端口绑定的操作。然而，如果只执行到这一步，编译器一般会报非常诡异的类型不匹配错误。

参考[go操作docker \- 简书](https://www.jianshu.com/p/283f32fc045a)的解决方法，删除gopath里面pkg下面docker的vendor里面相应的connections包，然后运行`go get github.com/docker/go-connections/nat` ，问题解决。

## 相关链接

- [client \- GoDoc](https://godoc.org/github.com/docker/docker/client#Client.ContainerCreate)
- [go操作docker \- 简书](https://www.jianshu.com/p/283f32fc045a)