---
title: gorequest中文文档(非官方)
date: '2018-05-05 19:19:43'
tags:
- go
slug: gorequest-doc
draft: false
---
# Gorequest指南

[gorequest](https://github.com/parnurzeal/gorequest)为 golang 程序提供了极为简便的方式发起 HTTP 请求。网上关于这个库的中文教程不多，因此把官方的 README 文件翻译过来，结合自己的一些使用经验，希望能为各位 Gopher 提供一些帮助。
<!--more-->

![GopherGoRequest](https://raw.githubusercontent.com/parnurzeal/gorequest/gh-pages/images/Gopher_GoRequest_400x300.jpg)

## 特性

- 支持发送Get/Post/Put/Head/Delete/Patch/Options 请求
- 建议的请求头设置
- JSON 支持：以 JSON 格式字符串作为函数参数的方式简化传输 JSON 的步骤。
- 分段支持：分段请求（Multipart Request）的方式发送数据或传输文件
- 代理：支援通过代理的方式发送请求。
- Timeout：为请求设置时间限制
- TLS(传输层安全协议)相关设定。
    > TLSClientConfig - taking control over tls where at least you can disable security check for https
- 重定向策略
- Cookie：为请求添加 cookie
- CookieJar - automatic in-memory cookiejar
- 基本的权限认证。

## 安装

```shell
$ go get github.com/parnurzeal/gorequest
```

## 文档

参阅[Go Doc](http://godoc.org/github.com/parnurzeal/gorequest)
后续我会根据自己在开发中使用经验将文档翻译过来。

## 使用 GoRequest 的一万个理由？

通过 GoRequest 可以使工作变得更简单，使可以发起 HTTP 请求这件事更加优雅而充满乐趣。

不使用本库发起简单 GET 请求：

```go
resp, err := http.Get("http://example.com/")
```

使用 GoRequest

```go
request := gorequest.New()
resp, body, errs := request.Get("http://example.com/").End()
```

如果你不想重用`request`，也可以写成下面这样

```go
resp, body, errs := gorequest.New().Get("http://example.com/").End()
```

如果你需要设定 HTTP 头，设定重定向策略等，使用标准库会瞬间使事情变得异常复杂，在发起仅仅一个 __GET__ 请求的过程，你就需要一个 `Client`，通过一系列不同的命令来设定 HTTP 头（`HTTP Headers`）。

```go
client := &http.Client{
  CheckRedirect: redirectPolicyFunc,
}

req, err := http.NewRequest("GET", "http://example.com", nil)

req.Header.Add("If-None-Match", `W/"wyzzy"`)
resp, err := client.Do(req)
```

现在，你有更加美妙的方式来完成这件事

```go
request := gorequest.New()
resp, body, errs := request.Get("http://example.com").
  RedirectPolicy(redirectPolicyFunc).
  Set("If-None-Match", `W/"wyzzy"`).
  End()
```

发起 __DELETE__, __HEAD__, __POST__, __PUT__, __PATCH__ 请求的过程和发起 __GET__ 请求类似。

```go
request := gorequest.New()
resp, body, errs := request.Post("http://example.com").End()
// PUT -> request.Put("http://example.com").End()
// DELETE -> request.Delete("http://example.com").End()
// HEAD -> request.Head("http://example.com").End()
// ANYTHING -> request.CustomMethod("TRACE", "http://example.com").End()
```

### 处理 JSON

用标准库发起 __JSON POST__ ，你需要先将 `map` 或者 `struct`格式的数据包装（__Marshal__）成 JSON 格式的数据，将头参数设定为'application/json'（必要时还要设定其他头），然后要新建一个`http.CLient`变量。经过这一系列的步骤，你的代码变得冗长而难以维护

```go
m := map[string]interface{}{
  "name": "backy",
  "species": "dog",
}
mJson, _ := json.Marshal(m)
contentReader := bytes.NewReader(mJson)
req, _ := http.NewRequest("POST", "http://example.com", contentReader)
req.Header.Set("Content-Type", "application/json")
req.Header.Set("Notes","GoRequest is coming!")
client := &http.Client{}
resp, _ := client.Do(req)
```

至于 GoRequest， JSON 支持是必须的，所以，用这个库你只需要一行代码完成所有工作

```go
request := gorequest.New()
resp, body, errs := request.Post("http://example.com").
  Set("Notes","gorequst is coming!").
  Send(`{"name":"backy", "species":"dog"}`).
  End()
```

另外，它同样支持结构体类型。所以，你可以在你的请求中发送不同的数据类型（So, you can have a fun __Mix & Match__ sending the different data types for your request）。

```go
type BrowserVersionSupport struct {
  Chrome string
  Firefox string
}
ver := BrowserVersionSupport{ Chrome: "37.0.2041.6", Firefox: "30.0" }
request := gorequest.New()
resp, body, errs := request.Post("http://version.com/update").
  Send(ver).
  Send(`{"Safari":"5.1.10"}`).
  End()
```

Not only for `Send()` but `Query()` is also supported. Just give it a try! :)

## 回调（Callback）

此外，GoRequest 支持回调函数，这让你可以更加灵活的使用这个库。
下面是回调函数的一个例子

```go
func printStatus(resp gorequest.Response, body string, errs []error){
  fmt.Println(resp.Status)
}
gorequest.New().Get("http://example.com").End(printStatus)
```

## Multipart/Form-Data

你可以将请求的内容类型设定为`multipart`来以`multipart/form-data`的方式发送所有数据。这个特性可以帮助你发送多个文件。
下面是一个例子

```go
gorequest.New().Post("http://example.com/").
  Type("multipart").
  Send(`{"query1":"test"}`).
  End()
```

如果感兴趣可以在文档中查看`SendFile`函数部分获取更多。

## 代理（Proxy）

需要使用代理的时候，可以用 GoRequest Proxy Func 很好的处理。

```go
request := gorequest.New().Proxy("http://proxy:999")
resp, body, errs := request.Get("http://example-proxy.com").End()
// To reuse same client with no_proxy, use empty string:
resp, body, errs = request.Proxy("").Get("http://example-no-proxy.com").End()
```

## 基本认证

添加基本的认证头信息

```go
request := gorequest.New().SetBasicAuth("username", "password")
resp, body, errs := request.Get("http://example-proxy.com").End()
```

## 超时处理（Timeout）

与 `time` 库结合可以设置成任何的时间限制。

```go
request := gorequest.New().Timeout(2*time.Millisecond)
resp, body, errs:= request.Get("http://example.com").End()
```

`Timeout` 函数同时设定了连接和 IO 的时间限制。

## 以字节方式处理返回体（EndBytes）

```go
resp, bodyBytes, errs := gorequest.New().Get("http://example.com/").EndBytes()
```

## 以结构体的方式处理返回体

假设 URL **http://example.com/** 的返回体`{"hey":"you"}`。

```go
heyYou struct {
  Hey string `json:"hey"`
}

var heyYou heyYou

resp, _, errs := gorequest.New().Get("http://example.com/").EndStruct(&heyYou)
```

## 连续重复请求（Retry）

假设你在得到 BadRequest 或服务器内部错误（InternalServerError）时进行连续三次，间隔五秒的连接尝试

```go
request := gorequest.New()
resp, body, errs := request.Get("http://example.com/").
                    Retry(3, 5 * time.Second, http.StatusBadRequest, http.StatusInternalServerError).
                    End()
```

## 重定向

> Redirects can be handled with RedirectPolicy which behaves similarly to net/http Client's [CheckRedirect function](https://golang.org/pkg/net/http#Client). Simply specify a function which takes the Request about to be made and a slice of previous Requests in order of oldest first. When this function returns an error, the Request is not made.

```go
request := gorequest.New()
resp, body, errs := request.Get("http://example.com/").
                    RedirectPolicy(func(req Request, via []*Request) error {
                      if req.URL.Scheme != "https" {
                        return http.ErrUseLastResponse
                      }
                    }).
                    End()
```

## Debug 模式

> For debugging, GoRequest leverages `httputil` to dump details of every request/response. (Thanks to @dafang).You can just use `SetDebug` or environment variable `GOREQUEST_DEBUG=0|1` to enable/disable debug mode and `SetLogger` to set your own choice of logger.Thanks to @QuentinPerez, we can see even how gorequest is compared to CURL by using `SetCurlCommand`.

## 注意

`gorequest.New()`函数应该一次调用，对返回的实例尽可能多次使用。

## Credits

* Renee French - the creator of Gopher mascot
* [Wisi Mongkhonsrisawat](https://www.facebook.com/puairw) for providing an awesome GoRequest's Gopher image :)

## License

GoRequest is MIT License.