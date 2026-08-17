---
title: iOS 开发笔记（二）—— 继承类的JSON处理
date: '2019-02-18 19:29:49'
tags:
- iOS
- Swift
slug: swiftjson
draft: false
---

JSON 是非常常用的数据编码格式，在`swift4`当中引入了`Codable`协议，使得JSON数据的处理变得前所未有的方便。然而当涉及继承的时候，还是踩了不少的雷区。所以想写个文章分享一下。
<!--more-->

## 基本操作
直接将 `class` 或者 `struct` 转 `JSON` 的话只需要继承 `Codable` 接口，然而如果想自定义编码之后在 `JSON` 中的键的名字的话（比如类成员 `name` 我想编码成 `Student_Name`），就需要引入 `CondingKeys` 这么一个枚举的内嵌类型。
```swift
enum CodingKeys: String,CodingKey{
    case name="Student_Name"
}
```
到这里还是十分方便的，然而，在代码设计中如果引入了继承，问题就来了。

## 问题
假设这么一个场景，手头上有一堆不同类型的传感器，每个传感器定期汇报自己收集的数据和所有的地理位置信息，那么这些传感器的 Model 中，都会有经度、纬度、名字，Id 这些共同的成员，也会有每个传感器自己特定的数据类型。
自然的，我们就想到了把经纬度信息抽象成`landmark`父类

```swift
class landmark: Codable{
     var latitude: String?
     var longitue: String?
}
```

后端传输信息的时候可能想偷懒一波，把 latitude 缩写成了 lat，把 longitude 缩写成了 lon，这对于任何一个有代码洁癖的人来说显然是无法忍受的，我还想在自己的代码里面用完成的名字，于是我们想到了`CodingKeys`，来给经纬度父类起个别名吧！

```swift
class Landmark: Codable{
     var latitude: String?
     var longitue: String?
    enum CodingKeys: String,CodingKey{
        case longitude = "lon"
        case letitude = "lat"
    }
}

```
这样我们就可以在自己的代码里面继续使用全名而不是别扭的缩写。
这时候我们开始对传感器建模了，比如有个广告牌传感器，
```swift
class Billboard: Landmark{
    var addedDate: String?
    var logo: String?
}
```
这里出现了第一个容易被初学者忽略的地方，就是如果继承的父类已经继承了` Codable` 协议，那么在设计子类的时候就不需要重复声明。
然后，根据`CodingKeys`的要求，进行`decode`的时候只会对`enum`中声明的字段进行编码和解码，所以这时候把广告牌数据解码到 `Billboard` 实例中会发现广告牌特有的两个字段都是`nil`
那么就需要为广告牌添加`CodingKeys`
```swift
class Billboard: Landmark{
    var addedDate: String?
    var logo: String?
    enum CodingKeys: String,CodingKey{
        case addedDate
        case logo
    }
}
```

然后编译，运行，发现想获取`logo`信息的话还是返回`nil`，只有经纬度字段正确的被解码了。

## 解决方案

## 参考链接
[Encoding and Decoding Custom Types \| Apple Developer Documentation](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types)