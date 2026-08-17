---
title: "【DEVONthink】复制item的Markdown样式脚本"
mathjax: false
tags:
- DEVONthink
- Markdown
date: '2022-05-14 17:04:29'
slug: dt-to-md
draft: false
---

DEVONthink 是苹果系统下一款很好用的知识管理工具，然而，由于DEVONthink本身更侧重于档案管理，所以通常会和其他markdown类笔记软件打组合拳。

今天分享一款直接复制DEVONthink的item link为markdown链接样式的脚本：

```AppleScript
tell application id "DNtp"
	set theMarkdownLinks to {}
	repeat with thisRecord in (selected records)
		copy ("[" & (name of thisRecord) & "](" & (reference URL of thisRecord) & ")  ") to end of theMarkdownLinks
	end repeat
	if theMarkdownLinks ≠ {} then
		display notification ((count items of theMarkdownLinks) & " Markdown links copied" as string) with title "Markdown-Link(s) kopiert"
		set the clipboard to (theMarkdownLinks as string)
	end if
end tell
```