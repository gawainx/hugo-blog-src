---
title: redis的杂七杂八
date: '2018-02-25 23:09:10'
tags:
- Redis
- golang
- Java
slug: redis
draft: false
---

Redis 是目前应用比较广泛的数据库。最近的实验室项目中用到它作为实时数据库。把这个过程中学到的一些东西记录下来，权且作为小白的入门参考吧
<!--more-->

## 基本概念

Redis 是一种基于内存的数据库，这意味着在使用过程中的所有数据都是存放在内存当中的，省去硬盘读写的过程使得对数据库的操作会非常的快，很适合并发。

Redis 的基本储存单位是`key-value`，比 mongodb 中的“文档”的概念有着更细的粒度。`key`部分一般是字符串类型，`value`部分可以有以下五种类型：

1. string。字符串类型
2. hash。一系列`k-v`的集合，适合用来储存对象实例或者 JSON
3. list。简单的字符串列表，也就是说可以通过 list 数据结构在一个`key`对应的`value`字段储存多个字符串。这多个字符串是有序排列的。“序”指的是插入的顺序（可以选从头部或者尾部插入）
4. set。String 类型的无序集合。满足唯一性。
5. 有序集合。set 的有序版本

## 命令行操作

### 服务器（server 端）

安装 Redis 之后，在命令行窗口输入`redis-server`即可在本机运行一个radis 的 server 端，默认的端口是6379.

### Docker

Redis 服务器端和其他主流数据库一样可以很方便的放到 Docker 容器里运行。

下载 Redis 镜像

```shell
sudo docker pull redis
```

基于 redis 镜像运行容器

```shell
sudo docker run --name redis-server -p 6379:6379 -d redis
```

镜像内部已经设置了运行`redis-server`和监听6379端口，所以不需要额外的设置项，只需要在运行容器时将端口暴露出来（与宿主机的6379端口或者自己指定的端口绑定）就可以了

### client 端

shell 界面下输入`redis-cli -h 127.0.0.1 -p 6379`启动 redis-client。其中，`-h`指定服务器的地址，`-p`指定服务器的端口。

#### 基本操作命令

注意到，命令的操作字段是不区分大小写的。

1. value 为 String 类型时。`set key value`用于为 key 设置值为 value。 `get key`用于获取键为 key 的值。
2. value 为 list类型时。`lpush key value1 [value2]…`用于将一个或者多个值。 `LPOP key`可以移出并获取列表的第一个元素。这两个操作换成`rpush`和`rpop`可以向列表尾部插入元素。`LLEN key`可以获取 key 对应的列表的长度。`LRANGE key start stop`用于获取特定key 的指定范围的元素，特别地，`LRANGE key 0 -1`可以用来遍历列表。

更加详细的命令教程可以参考[Redis教程-菜鸟教程](http://www.runoob.com/redis/redis-tutorial.html)

## 编程语言支持

### Java

在 Java 中主要通过 jedis 数据库驱动实现对 Redis 数据库的操作。

安装依赖

```xml
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>2.9.0</version>
</dependency>
```

#### JedisPool和 JedisClient

jedis 使用 JedisPool 作为一个Redis连接池，用于解决对Redis进行并发访问时会发生连接超时、数据转换错误、阻塞、客户端关闭连接等问题。

连接池初始化代码如下

```java
public static JedisPool getPool(String host, int port){
        if(pool == null){
            JedisPoolConfig config = new JedisPoolConfig();
            
			//设置最大连接数
            config.setMaxTotal(100);

            config.setMaxIdle(5);

            if(host == null){
                pool = new JedisPool(config, "127.0.0.1", port);
            }else{
                pool = new JedisPool(config, host, port);
            }
        }
        return pool;
    }
```

要使用Client 时，使用`pool.getResource()`方法获取单个JedisClient实例，在此基础上对 Redis 数据库进行操作。

### Golang

Go 语言中用来连接 Redis 数据库的库五花八门，主要分两个派系，将对 Redis 的操作封装成方法的，开发者通过调用库的方法实现对 Redis 数据库的操作；另一派是直接将 Redis 命令作为字符串提供给库来实现各种操作的。

这里以`"github.com/garyburd/redigo/redis"`为例。

安装依赖

```shell
go get github.com/garyburd/redigo/redis
```

获取 redis pool实例

```go
redis.Pool{
		MaxIdle:10,
		MaxActive:15,
		IdleTimeout:240*time.Second,
		Dial: func() (redis.Conn, error) {
			c, err := redis.Dial("tcp", redisURL)
			if err != nil{
				return nil, err
			}
			return c, err
		},
	}
```

从 pool 中获取 Client 实例

```go
rClient := redisPool.Get()
```

执行操作

```go
rClient.Do("LPUSH","key", "value")
```

Do 方法用于执行对 Redis 数据库的操作命令。方法的第一个参数字符串命令（就是在 shell 交互时的各种命令。

