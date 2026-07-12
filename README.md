# lingyu-skills

这里集中维护与「灵玉」相关的可复用 AI Skills。仓库采用单仓多 Skill 结构，每个 Skill 都是 `skills/` 下可以独立安装和使用的目录。

## Skills

| Skill | 说明 |
| --- | --- |
| [`create-chinese-names`](skills/create-chinese-names/) | 根据姓氏、字数、风格和避讳条件生成、比较并解释中文个人姓名 |

## 目录约定

```text
lingyu-skills/
├── README.md
└── skills/
    └── create-chinese-names/
        ├── SKILL.md
        ├── agents/
        │   └── openai.yaml
        └── references/
            └── naming-rules.md
```

每个 Skill 的核心工作流放在 `SKILL.md`，详细领域规则按需放在 `references/`，确定性工具才放在 `scripts/`。不要在 Skill 内复制线上服务的密钥、私有词库或客户数据。

## 安装

推荐优先使用 [Skills CLI](https://skills.sh/) 安装。它会自动识别当前 Agent，并把 Skill 写入对应的全局或项目目录。

### 全局安装（推荐）

安装本仓库中的全部 Skill：

```bash
npx -y skills add peterzhanghui/lingyu-skills -g --all
```

只安装某一个 Skill：

```bash
npx -y skills add peterzhanghui/lingyu-skills --skill create-chinese-names -g -y
```

安装前可先查看仓库里有哪些 Skill：

```bash
npx -y skills add peterzhanghui/lingyu-skills -l
```

### Codex、Claude Code、Cursor 与其他支持 Skills 的 Agent

上面的 `npx skills add` 命令会按当前环境自动写入对应目录。也可以显式指定目标 Agent：

```bash
# 安装到 Codex
npx -y skills add peterzhanghui/lingyu-skills -g --all -a codex

# 安装到 Claude Code
npx -y skills add peterzhanghui/lingyu-skills -g --all -a claude-code

# 安装到 Cursor
npx -y skills add peterzhanghui/lingyu-skills -g --all -a cursor

# 安装到 Hermes Agent
npx -y skills add peterzhanghui/lingyu-skills -g --all -a hermes-agent

# 安装到 OpenClaw
npx -y skills add peterzhanghui/lingyu-skills -g --all -a openclaw
```

常见全局 Skills 目录如下：

| Agent | CLI 标识 | 全局目录 |
| --- | --- | --- |
| Codex | `codex` | `~/.codex/skills/` 或 `$CODEX_HOME/skills/` |
| Claude Code | `claude-code` | `~/.claude/skills/` |
| Cursor | `cursor` | `~/.cursor/skills/` |
| Hermes Agent | `hermes-agent` | `~/.hermes/skills/` |
| OpenClaw | `openclaw` | `~/.openclaw/skills/` |
| 通用 Agents | — | `~/.agents/skills/` |

更多 Agent 的目录映射见 [Skills CLI 支持列表](https://github.com/vercel-labs/skills#supported-agents)。

### Hermes、OpenClaw 等自定义 Agent

如果 Agent 已支持 Skills 目录，优先用上面的 `-a` 参数安装。需要手动处理时，把 Skill 目录复制或软链接到对应目录即可。以中文起名 Skill 为例：

```bash
# 先克隆仓库到稳定路径
git clone https://github.com/peterzhanghui/lingyu-skills.git ~/Developer/lingyu-skills

# Hermes Agent
ln -sfn ~/Developer/lingyu-skills/skills/create-chinese-names ~/.hermes/skills/create-chinese-names

# OpenClaw
ln -sfn ~/Developer/lingyu-skills/skills/create-chinese-names ~/.openclaw/skills/create-chinese-names

# Codex
ln -sfn ~/Developer/lingyu-skills/skills/create-chinese-names ~/.codex/skills/create-chinese-names
```

如果 Agent 没有独立的 Skills 目录，可在其系统提示词或 `CLAUDE.md` / `AGENTS.md` 中显式引用 `SKILL.md` 路径，例如：

```text
@~/Developer/lingyu-skills/skills/create-chinese-names/SKILL.md
```

### 手动安装

不想使用 CLI 时，也可以直接把 Skill 目录复制到目标 Agent 的全局目录：

```bash
# Codex
cp -R skills/create-chinese-names ~/.codex/skills/

# Claude Code
cp -R skills/create-chinese-names ~/.claude/skills/

# Cursor（个人全局）
cp -R skills/create-chinese-names ~/.cursor/skills/

# 通用 Agents
cp -R skills/create-chinese-names ~/.agents/skills/
```

更推荐用软链接，便于后续 `git pull` 更新：

```bash
ln -sfn "$(pwd)/skills/create-chinese-names" ~/.codex/skills/create-chinese-names
```

### 项目级安装

只想在当前仓库内使用时，去掉 `-g` 即可：

```bash
npx -y skills add peterzhanghui/lingyu-skills --all
```

Skill 会安装到当前项目的 Agent 目录，例如 `.cursor/skills/` 或 `.agents/skills/`。

## 使用

安装完成后，直接描述需求即可触发对应 Skill。例如：

```text
帮我给姓张的孩子起几个三字名，风格温润，避开“浩”“轩”这类爆款字。
```

也可以显式点名 Skill：

```text
使用 create-chinese-names，为姓李的女孩生成 8 个候选名，要求典雅、好写、普通话读音顺口。
```

## 更新

重新运行全局安装命令即可更新到最新版本：

```bash
npx -y skills add peterzhanghui/lingyu-skills -g --all
```

如果之前是软链接到本地仓库，进入克隆目录执行 `git pull` 即可。

## 许可证

许可证将在首次公开发布前确定。
