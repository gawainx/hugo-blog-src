---
title: click——Python 命令行开发工具包
mathjax: false
tags:
- Typora
- Markdown
date: '2021-08-15 17:18:45'
slug: click01
draft: false
---

这是一个官方宣称比Argparser更好用的Python命令行开发工具包。

<!--more-->

## 基本功能

- 嵌套命令
- 自动生成help页面
- 子命令的懒加载

## 基础使用

[Document](https://click.palletsprojects.com/en/8.0.x/quickstart/)

从一个简单的example入手

```python
import click
@click.command()
@click.option('--count', default=1, help='number of greetings')
@click.argument('name')
def hello(count, name):
    for x in range(count):
        click.echo(f"Hello {name}!")
```

`import click` 之后，使用修饰器的方式将一个函数和对应的命令进行绑定。

`@click.command()` 表示接下来修饰的函数是一个命令。

使用`@click.option('--count', default=1, help='number of greetings')`添加可选参数，第一个位置为对应的参数名称，默认值由`default=` 字段指定一个默认值，`help=` 给出对应的帮助文档；使用`@click.argument('name')` 添加argument，也就是没带默认值的参数。

这里可以看到，比起`Argparser`，好玩的地方在于可以直接和函数的参数绑定。

另外例子里使用了 `click.echo(f"Hello {name}!")`，这是官方为了兼容不同 python版本而内置的一个函数，实现print功能。

## 多个Command

实际使用的时候肯定会添加多个命令。因此，click引入了`group`功能，意思就是把多个命令组织起来。

Example Code

```python
@click.group()
def cli():
    pass

@cli.command()
def initdb():
    click.echo('Initialized the database')

@cli.command()
def dropdb():
    click.echo('Dropped the database')
    
cli.add_command(initdb)
cli.add_command(dropdb)
```

`@click.group()` 注册一个空载函数`cli`.

定义command之后，调用函数`cli.add_command(initdb)` 把命令加进组里。

## 程序入口

```python
if __name__ == '__main__':
    cli()
```

非常简洁，只需要把定义的`group`或者`command`运行起来就可以了。

## 与setuptools的绑定

使用Python开发命令行工具包，最终目的都是完成分发。click的作者非常贴心考虑到这一点，并且提供了方便的融入`setuptools`的方法

```python
from setuptools import setup

setup(
    name='yourscript',
    version='0.1.0',
    py_modules=['yourscript'],
    install_requires=[
        'Click',
    ],
    entry_points={
        'console_scripts': [
            'yourscript = yourscript:cli',
        ],
    },
)
```

将`yourscript.py` 以及 `setup.py` 放在同一个目录下。关键就在于

```python
entry_points={
        'console_scripts': [
            'yourscript = yourscript:cli',
        ],
    },
```

这部分，`console_scripts` 字段每一行是一个控制台命令，等号左边是命令的名字也就是要在终端输入的部分，等号右边分两段，冒号左边的是文件的名字，右边是`cli` 函数的名字

[文档原文](https://click.palletsprojects.com/en/8.0.x/setuptools/#setuptools-integration)
