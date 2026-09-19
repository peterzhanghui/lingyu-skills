# lingyu-skills

> 中文起名的可复用 AI Skill 与 Agent 专家包。把姓名当作语言与文化选择来处理，逐字核查音、形、义、谐音与重名热度；出处可核验才标注，不批命、不断吉凶。

由「**辉哥有解**」维护。这套规则背后是已上线在跑的 AI 起名产品 [**灵玉起名 · jiatt.top**](https://jiatt.top)——仓库里公开的是完整的起名方法论，不是精简版。

## 产物

同一份规则，两种分发形态：

| 产物 | 面向 | 安装 |
| --- | --- | --- |
| [`skills/create-chinese-names`](skills/create-chinese-names/) | Claude Code、Codex、Cursor 等支持 Skills 的 Agent | `npx skills add`（见下） |
| [`experts/lingyu-naming`](experts/lingyu-naming/) | 腾讯 WorkBuddy 专家「灵玉」 | 专家市场安装 |

专家包不复制规则，打包时从 `skills/` 的真源取，改一次两边生效。

## 目录约定

```text
lingyu-skills/
├── README.md
├── LICENSE
├── skills/
│   └── create-chinese-names/
│       ├── SKILL.md                  # 核心工作流
│       ├── agents/openai.yaml
│       └── references/               # 领域规则
│           ├── naming-rules.md       # 音、形、义与风险判定
│           ├── popularity-data.md    # 爆款字与重名风险
│           ├── examples.md           # 分析示范
│           └── output-example.md     # 方案输出格式
└── experts/
    └── lingyu-naming/
        ├── .codebuddy-plugin/plugin.json
        ├── agents/lingyu-naming.md   # 身份、开场、自检、边界
        ├── avatars/expert.png
        └── build.sh                  # 打包提审用 zip
```

每个 Skill 的核心工作流放在 `SKILL.md`，详细领域规则按需放在 `references/`，确定性工具才放在 `scripts/`。不要在 Skill 内复制线上服务的密钥、私有词库或客户数据。

## 能做什么 / 不做什么

**能做**：按姓氏、字数、风格、辈分与避讳生成候选；逐字分析字义、普通话声调与连读、字形书写、常见谐音；比较已有候选并指出各自风险；判断爆款字与模板化重名风险。

**不做**：预测性格、健康、财富、婚姻或命运；以八字、生肖、五行下确定性结论或作吉凶保证；替代商标检索与户籍登记核验。用户主动提供生辰时，五行只作**选字参考**，不批命、不强制配字。

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

## WorkBuddy 专家「灵玉」

在 WorkBuddy 专家市场搜索「灵玉」安装即可，无需本仓库。

自行打包提审：

```bash
bash experts/lingyu-naming/build.sh
```

产物在 `experts/lingyu-naming/dist/`，zip 内为专家目录内容（不含外层文件夹）。详见 [experts/lingyu-naming/README.md](experts/lingyu-naming/README.md)。

## 许可证

[MIT](LICENSE)。可自由使用、修改、再分发与商用，保留版权与许可声明即可。
