# jiatt-skills

这里集中维护与「简爱她」相关的可复用 AI Skills。仓库采用单仓多 Skill 结构，每个 Skill 都是 `skills/` 下可以独立安装和使用的目录。

## Skills

- [`create-chinese-names`](skills/create-chinese-names/)：根据姓氏、字数、风格和避讳条件生成、比较并解释中文个人姓名。

## 目录约定

```text
jiatt-skills/
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

将需要的 Skill 目录复制或链接到 Codex 的 Skills 目录。例如安装中文起名 Skill：

```bash
cp -R skills/create-chinese-names ~/.codex/skills/
```

许可证将在首次公开发布前确定。
