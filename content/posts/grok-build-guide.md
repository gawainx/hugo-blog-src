+++
title = 'Grok Build 完整使用指南：安装、项目规则、Skills 与 MCP 集成'
date = '2025-10-12T10:30:00+08:00'
draft = false
tags = ["AI工具", "Grok", "xAI", "CLI", "生产力", "MCP"]
categories = ["工具"]
ShowReadingTime = true
ShowPostNavLinks = true
+++

Grok Build 是 xAI 推出的终端 AI 编程助手（TUI），专注于软件工程任务。它可以读取代码、执行命令、编辑文件、搜索网络，并通过扩展机制（Skills、MCP、Hooks）高度定制。

本文严格基于官方用户指南（`~/.grok/docs/user-guide/`）整理，覆盖安装、项目规则迁移、配置、Skills 自定义、Notion/MCP 集成以及自定义命令等核心使用方式。

## 1. 安装命令

### macOS / Linux

推荐使用官方安装脚本：

```bash
curl -fsSL https://x.ai/cli/install.sh | bash
```

安装特定版本：

```bash
curl -fsSL https://x.ai/cli/install.sh | bash -s 0.1.42
```

### Windows

使用 PowerShell：

```powershell
irm https://x.ai/cli/install.ps1 | iex
```

指定版本：

```powershell
$env:GROK_VERSION="0.1.42"; irm https://x.ai/cli/install.ps1 | iex
```

安装后验证：

```bash
grok --version
grok update   # 随时更新
```

### 首次启动与认证

直接运行：

```bash
grok
```

首次会打开浏览器登录 grok.com，凭证存储在 `~/.grok/auth.json`，token 有效期 7 天。

**CI/CD 或无浏览器环境** 推荐使用 API Key：

```bash
export XAI_API_KEY="xai-你的密钥"
grok
```

更多认证方式（OIDC、Device Code）详见官方 `02-authentication.md`。

常用启动参数：

- `grok --cwd ~/projects/my-app` 指定目录
- `grok --yolo` 自动批准所有工具执行（谨慎使用）
- `grok -p "你的提示"` **无头模式**（适合脚本/CI）
- `grok -c` 继续上一次会话

## 付费与使用限额（重要现实考量）

很多用户最关心的问题是：**Grok Build 的使用限额如何查看？** 是否像 Claude Code 或 Codex 那样，有清晰的“每 5 小时 / 每周”剩余额度面板？

### 当前实际情况（基于官方用户指南）

截至目前，**Grok Build CLI/TUI 没有提供类似 Claude Code 或 Codex 的账户级使用量查询命令**。

- 没有 `grok usage`、`grok quota` 或 `/usage` 这类命令
- `grok inspect`、`grok models` 等管理命令中也不包含账户额度信息
- `/context` 和 `/session-info` 只能查看**当前会话的技术指标**（上下文窗口占用、已用 token 数、对话轮次），**不代表你的账户整体剩余配额**

### 真正的限额在哪里？

Grok Build 的使用额度与你的 **grok.com 账户订阅等级**（Free / SuperGrok / xAI Premium+ 等）或 **console.x.ai API Key** 的额度绑定。

目前查看真实剩余额度的方式主要是：

1. 浏览器登录 [grok.com](https://grok.com) 或 [x.ai](https://x.ai) 账户后台查看
2. 使用 API Key 时，到 [console.x.ai](https://console.x.ai) 查看对应 Key 的使用情况
3. 在高强度使用过程中，模型可能会主动提示你已接近限额

### 建议

- 如果你主要用于重度开发工作，建议提前了解自己账户的订阅等级对应的速率限制和重置周期。
- 目前这部分信息在 Grok Build 终端内尚不透明，这是与 Claude Code、Codex 等工具在使用体验上的明显差异。
- 未来版本是否会增加 `/usage` 或类似命令，建议关注官方更新或 release notes（可用 `/release-notes` 查看）。

这个现实情况值得在开始大量使用前就了解清楚。

## 2. 在项目中开始工作 + 迁移 CLAUDE.md 等 Instructions

进入项目目录后直接运行 `grok`，Grok 会自动理解当前代码库。

### 自动加载项目规则（最重要）

Grok 会扫描以下文件并将其内容作为系统提示的一部分注入：

- `Agents.md`
- `Claude.md`
- `AGENT.md`
- `AGENTS.md`

**发现顺序与优先级**（越深优先级越高）：

1. 全局 `~/.grok/AGENTS.md`
2. Git 仓库根目录到当前目录之间的所有层级
3. 当前工作目录（CWD）

**Claude.md 兼容**：如果你之前使用 Claude Code 或类似工具写了很多 `CLAUDE.md`，可以**直接重命名为 `Claude.md` 或 `AGENTS.md`**，Grok 会自动识别并加载，无需额外配置。

推荐做法：

- 把现有的 `CLAUDE.md` 内容迁移到项目根目录的 `AGENTS.md`（语义更清晰）
- 或者保留 `Claude.md` 实现兼容

Grok 还支持 `--rules "额外指令"` 在单次会话中追加规则（不修改文件）。

## 3. 如何配置 Grok 自己的类似 CLAUDE.md 内容

除了 `AGENTS.md` 系列，Grok 还提供了更结构化的项目级配置目录：

```
项目根目录/
├── AGENTS.md                 # 主要规则（推荐）
└── .grok/
    ├── config.toml           # 项目级 MCP 服务器配置（仅此 section 有效）
    ├── skills/               # 项目专用技能
    ├── hooks/                # 项目生命周期钩子
    └── plugins/              # 项目插件
```

**关键规则**：

- `.grok/config.toml` 中**只支持 `[mcp_servers]`** 部分，其他配置以用户全局 `~/.grok/config.toml` 为准。
- 项目级文件优先级高于全局。
- 每个 `AGENTS.md` 文件有 10,000 字符上限，建议保持简洁。

示例 `AGENTS.md` 内容：

```markdown
# 开发规范

- 所有函数必须有文档字符串
- 提交信息必须遵循 Conventional Commits
- 复杂任务（3 步以上）必须先写设计文档 + 开发计划
```

这样配置后，每次在该项目启动 Grok 时，这些规则都会自动生效。

## 4. 技能（Skills）使用：创建、管理、修改

**Skill 是 Grok 最强大的自定义机制**。一个 Skill 就是一个可复用的工作流程包，创建后会自动变成可通过 `/技能名` 调用的命令。

### Skill 存放位置（优先级从高到低）

- `./.grok/skills/`（当前目录）
- `<repo_root>/.grok/skills/`（仓库级，推荐团队共享）
- `~/.grok/skills/`（用户全局）

### 创建 Skill 的两种方式

**推荐方式（最简单）**：

```bash
/skillify
```

或

```bash
/create-skill
```

Grok 会：
- 分析你当前会话中刚完成的工作流（From-session 模式），或
- 引导你从零描述流程（From-scratch 模式）

完成后会生成完整的 `SKILL.md`（含 YAML frontmatter），你可以预览并确认后再写入磁盘。

**手动创建**：

在对应目录下创建文件夹和 `SKILL.md`，例如：

```
.grok/skills/new-post/
└── SKILL.md
```

`SKILL.md` 示例结构：

```markdown
---
name: new-post
description: 为 Hugo 博客快速创建符合规范的新文章。Use when user wants to add a new blog post.
---

# 创建新文章步骤

1. 询问文章标题、标签、分类
2. 生成标准 frontmatter（含 date、draft=false 等）
3. 在 content/posts/ 下创建文件
4. 打开文件供用户编辑
```

### 管理与使用

- `/skills` 查看所有可用技能
- `/skills new-post` 将该技能注入当前上下文
- 直接输入 `/new-post` 即可触发（如果名称唯一）
- `grok inspect` 可查看所有技能来源和路径

**最佳实践**：
- 描述要具体（这决定了是否自动触发）
- 每个技能只做一类事
- 项目技能提交到仓库

## 5. 如何接入 Notion（读取、修改、创建文档）

Grok **本身不内置 Notion 功能**，而是通过 **MCP (Model Context Protocol)** 进行扩展。

### 基本接入流程

1. 在 `~/.grok/config.toml`（或项目 `.grok/config.toml`）中配置 MCP 服务器：

```toml
[mcp_servers.notion]
command = "npx"
args = ["-y", "@some/notion-mcp-server"]
env = { NOTION_TOKEN = "secret_xxx" }
enabled = true
```

或使用 HTTP/SSE 方式（推荐托管服务）：

```toml
[mcp_servers.notion]
url = "https://mcp.notion.example.com/mcp"
enabled = true
```

2. 重启 Grok 或在 TUI 中使用 `/mcps` 管理面板启用服务器。

3. 在会话中使用两个内置工具发现和调用：

- `search_tool`：搜索可用的 MCP 工具
- `use_tool`：调用具体工具（如 `notion__create_page`）

**注意**：官方用户指南中目前没有提供现成的 Notion MCP 配置示例。你需要自行寻找或搭建符合 MCP 标准的 Notion 服务器（社区已有多个实现）。

## 6. 如何使用自定义命令

Grok 的“自定义命令”主要通过以下机制实现：

### 1. 内置 Slash Commands（开箱即用）

常用示例：

- `/new`（或 `/clear`）新建会话
- `/compact` 压缩上下文
- `/plan` 进入 Plan Mode（只读规划）
- `/model grok-build` 切换模型
- `/imagine 提示词` 生成图片
- `/loop 5m 检查构建状态` 定时循环任务
- `/skills`、`/plugins`、`/mcps`、`/hooks` 各类管理面板

### 2. 用户创建的 Skills（最推荐的自定义命令）

如第 4 节所述，创建的 Skill 会自动成为 `/命令名`。

### 3. Hooks（事件驱动自动化）

在 `.grok/hooks/` 下放置 JSON 文件，可在 `SessionStart`、`PreToolUse`、`PostToolUse` 等生命周期事件执行自定义脚本或 HTTP 请求。

典型用途：自动格式化代码、发送通知、危险命令拦截等。

### 4. Plugins（打包分发）

把 Skills、Hooks、MCP 配置、LSP 配置打包成一个插件目录，通过 `grok mcp` 或配置文件安装，实现团队级自定义命令分发。

### 5. 其他扩展方式

- MCP 工具（外部服务能力）
- 自定义模型（`[model.xxx]` 配置）
- `/loop` 定时执行任意提示词

---

## 总结

Grok Build 的强大之处在于**极强的可扩展性**：

- 用 `AGENTS.md` / `Claude.md` 注入项目规范
- 用 **Skills** 把重复工作流变成一键命令
- 用 **MCP** 把 Notion、GitHub、数据库等外部系统接入
- 用 **Hooks + Plugins** 实现团队级自动化

对于 Hugo 博客作者来说，可以快速打造专属工作流，例如：

- `/new-post` 一键生成规范文章
- `/hugo-check` 构建前 lint + 链接检查
- Notion MCP 实现“写作灵感 → 草稿 → 发布”全流程打通

**建议下一步**：

1. 在你的 Hugo 项目根目录创建 `AGENTS.md`，写入你的写作/构建规范
2. 尝试运行 `/skillify`，把你最常做的“写新文章”流程固化成技能
3. 根据需要配置感兴趣的 MCP 服务器

所有信息均来源于 `~/.grok/docs/user-guide/` 下的官方文档，实际使用以你安装版本的最新文档为准。

欢迎在评论区分享你用 Grok Build 打造的自定义工作流！
