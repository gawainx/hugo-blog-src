+++
date = '2026-09-29T21:52:20+08:00'
draft = true
title = '打造以DEVONthink为中心的Agent文档系统'
+++

# 打造以DEVONthink为中心的Agent文档系统

> Agentic 时代，我们需要怎样引导Agent去记录？

很久之前，我在公众号写过一篇文章，给自己挖了一个大坑，想要介绍 Devonthink 这款优秀的档案管理软件如何助力自己的科研。然而，写完第一篇之后，这个系列就彻底冬眠了。

背后的原因并不是我三分钟热度之后彻底荒废这个软件。我使用下来发现我最多也就是把它当成了论文管理的入口，而论文管理这个狭窄的领域，Zotero 才是真正的王者，那自然我就看不到我继续写作的价值。

然后五年过去了，我们迎来了 Agent 时代。

Vibe Coding 刚兴起的时候，如何通过文档规范来约束 agents 的行为是一个被广泛讨论和实践的主题。SpecKit，Superpowers 都是那个时代的优秀作品。

我自己也维护了自己的一套 antarx-dev-skills ，将需求澄清，设计，开发计划制定和项目进度跟踪流程制度化。这套流程帮我很好写出来 arXivArcher 这款应用。今天看 Codex 的用量统计，发现这一套技能系统在 skills 调用次数上荣登榜首。
![Codex 用量统计](https://img.antarxly.com/landscape/webp/20260929-606e6e82.webp)

在 Opus 4.6 以及 GPT 5.6 时代开始，模型开始更关注长程任务，开发活动的 Harness 有了新的变化。开发者逐渐发现冗长的规格说明和技能反而局限了模型的发挥，体感是降智。网路上甚至有“把所有 skills 删掉”的主张。我自己在切换 Terra 作为主力模型之后，第一件事也是把我曾经最引以为豪的技能包进行了清理，只保留了最核心的需求澄清等少数技能。我陷入了思考。在模型开始自动化执行长程任务的时候，文档体系的作用还应该是什么？更加准确的命题是，在 Agentic 时代，我们应该如何整理和记录？

这个时候，devonthonk 4.4 带着它完整的 MCP 服务重新进入了我的视线。在工作的两个项目验证之后我惊喜地发现，Sol 和 Astra 对 devonthink MCP 服务的相性意外的完美，只需要把 dt link 直接告诉模型，模型就非常自然能够检索和写入内容。

于是经过了探索打磨，我之前困扰的问题有了新的答案，就是以 dt 为中心打造文档系统。

## Quick Setup

首先自然是要安装DEVONthink Pro，然后在 设置 -> AI 中，开始MCP，并且勾选自动安装到最常用的Agent服务中，也可以复制JSON然后添加到比如 DeepSeek Harness 等自定义 Agent Framework。

![pasted-image-2026-09-29T13-23-01-541Z.png](https://img.antarxly.com/landscape/webp/20260929-cd8589cd.webp)

当然，为了更流畅的运作，配置自动登陆也是必不可少的。另外一个可以自定义的地方就是，如果家里有Mac mini想作为一个统一中心，不希望所有Mac都安装DEVONthink，也可以开了TLS+Bearer Token之后，写到远程的Mac中。但考虑到DEVONthink本身的iCloud/webDAV同步已经做得非常优秀，而且89刀本身也有两个seats，这一步参考意义也不是很大。

## 如何写入：DEVONthink Skills

Agent 最核心的特点就应该是“自动化”，也就是自动归档自动记录。只把MCP启用并不能达到这一点。因此，借助强大的Astra，我开发了一套DEVONthink技能包，用于配置自动化记录流程。

| 技能 | 用途 |
| --- | --- |
| dt-source-capture | 用于捕捉PDF和HTML DEVONthink数据库 |
| dt-writing-research-report | 开展调研、审核报告大纲，编写、修订和保存调研报告 |
| dt-writing-project-documents | 创建、修订和保存需求澄清、设计文档、开发计划、复盘与实验结果记录。支持HTML和Markdown格式 |
| dt-progress-recorder | 记录项目进度和关键决策 |

要使用这套技能，只需要：

```bash
npx skills add https://github.com/gawainx/awesome-devonthink/tree/v1.0.0/using-dt-skills --global --skill '*'
```

### 配置写入路径

技能默认按照如下优先级来渐进式发现不同路径的 AGENTS 文件：

1. 用户Prompt中直接提供的有效 DEVONthink URL 来源
2. 当前会话历史中提及的有效来源
3. 项目目录的 `AGENTS.*.md`，例如 `AGENTS.env.md`、`AGENTS.local.md`
4. 项目目录的 `AGENTS.md`
5. 系统提供的 `~/.codex/AGENTS.*.md` 文档
6. 系统全局 `~/.codex/AGENTS.md` 文档

因此，安装完技能后，只需要在项目目录的 `AGENTS.*.md` 文件写入你需要保存的DEVONthink Group 路径，例如：`[dt-harness](x-devonthink-item://34567890102)`。这里有两个地方可以注意：

1. DEVONthink 的 x-item link 是数据库唯一的，你可以把它配置成 markdown 格式，方便直接点击。
2. 可以按需把 `AGENTS.*.md` 加入到全局的 .gitignore 中，避免信息泄漏

## 如何…“检索”？

任何对记忆系统有了解的同学可能已经想到了，一个完善的知识库，不仅应该有储存，还应该要能够被检索，这样知识才有可能产生价值。在打算开发 dt-search 技能用于专门搜索之前，我让 Astra 直接裸跑 DEVONThink MCP 的搜索接口，对已经沉淀的文档做了一个有趣的尝试：

| 验证 | 实际结果 |
| --- | --- |
| 按标题搜索 `name:需求`，`limit: 5` | 返回 2 条：一份项目复盘，以及 DeepSeek V4.1-Flash KV Cache 与容量规划需求澄清 |
| 全文搜索 `text:"KV Cache" kind:markdown`，`limit: 5` | 总计命中 106 条，本页返回 5 条、vLLM 调参、llm-d 调研、昇腾 A3 PD 分离优化和成本估算 |
| 按项目名搜索，`sort: modified`，`limit: 6` | 总计命中 7 条，本页包含日报、复盘、项目 group、MoE 节点卡数拓扑准入 bugfix 和设计文档 |
| 使用 `group_uuid` 限定项目 group，再按需求编号搜索 | 返回 5 条：对应需求澄清、设计、开发计划、项目索引及另一需求的 MoE 拓扑准入 bugfix |
| 用 `extract_record_content` 读取需求文档 | 返回需求理解、范围确认、验收标准和后续文档等章节；其中明确要求 Engram 主机卸载方案扣减 GPU 常驻权重，并计算主机内存需求，避免重复计量 |
| 用 `extract_record_content` 按 `Engram,卸载` 提取内容 | 返回需求理解、范围确认、验收标准三个章节的相关片段 |
| 用 `get_record_text` 读取同一文档 | 返回完整 Markdown 源文，包括正文及链接目标 |
| 用 `find_similar_records` 查找相似记录，`limit: 3` | 依次返回同一需求的开发计划、设计，以及另一需求的 Qwen3.8-Flash-Next 模型准入文档 |
| 用 `get_record_links` 读取出链 | 返回设计和开发计划两条 item link，均带关联记录 UUID |
| 将完整问题 `DeepSeek V4.1 容量规划之前确认了哪些需求` 直接传给 `search_records` | 仅命中 1 篇日报，没有返回上述需求澄清文档 |

这个搜索过程很有意思，它表明我并不需要开发专用的 dt-search 技能来教会模型怎么搜索，模型用 DEVONThink MCP 的搜索接口，就像调用 web search 一样自然方便。真正需要做的只是让模型知道有这么一个数据源。

大概你只需要在全局提示词中加入：

> 将 DEVONthink 知识库、项目源码和互联网资料作为常规信息来源，根据任务主动检索相关内容；涉及已有项目的需求、设计和历史决策时，先读取知识库中的相关记录，并结合当前源码及外部资料作出判断。

## Beyond

Agent Harness 其实是一套很私人化、各花入各眼的事情。工作中我发现很多我自己用得行云流水的skills，share给同事之后让他们的agents一头雾水。所以，DEVONthink 也可能是我自己探索过程中的一种版本答案。背后其实还有一个我想讨论很久，却不知道如何开始的问题——我们应该如何和 Agent 去更好相处？




