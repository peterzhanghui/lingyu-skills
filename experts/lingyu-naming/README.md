# lingyu-naming · 灵玉

腾讯 WorkBuddy 专家包。中文起名顾问，按姓氏、风格与避讳生成候选姓名，逐字核查字义、普通话音韵、字形、谐音与重名热度；出处可核验才标注，不批命、不断吉凶。

由「辉哥有解」维护，背后是已上线在跑的 AI 起名产品 [灵玉起名](https://jiatt.top)。

## 目录结构

```text
lingyu-naming/
├── .codebuddy-plugin/
│   └── plugin.json          # 专家配置（人设、分类、标签、快捷提示）
├── agents/
│   └── lingyu-naming.md     # Agent 定义：身份、开场、自检、边界
├── avatars/
│   └── expert.png           # 512×512 头像
├── build.sh                 # 打包提审用的 zip
└── README.md
```

打包后会多出 `skills/create-chinese-names/`，由 `build.sh` 从仓库根目录的真源复制而来。

## 设计：技能只有一份真源

起名的领域规则全部在仓库根目录的 [`skills/create-chinese-names`](../../skills/create-chinese-names/)，**专家目录里不留副本**。

`agents/lingyu-naming.md` 只负责身份、开场、交付自检和边界，遇到实际起名任务时调用该技能执行。规则要改就改技能，改完重新打包即可，不存在两份规则各自漂移的问题。

这也意味着同一份规则同时供给两个生态：

| 产物 | 面向 | 入口 |
| --- | --- | --- |
| `skills/create-chinese-names` | Claude Code、Codex、Cursor 等支持 Skills 的 Agent | `npx skills add` |
| `experts/lingyu-naming` | 腾讯 WorkBuddy | 专家市场安装 |

## 打包

```bash
bash experts/lingyu-naming/build.sh
```

产物在 `experts/lingyu-naming/dist/lingyu-naming-v<版本>.zip`，zip 内是专家目录的内容（不含外层文件夹），可直接提交开放平台审核。

`.build/` 与 `dist/` 是构建产物，已在 `.gitignore` 中忽略。

## 能力边界

专家在对话内完成生成、核查与解释。以下三项受运行环境限制做不到，`agents/lingyu-naming.md` 要求如实说明，不假装能做：

1. **实时重名热度** —— 内置的是静态抽样数据，会随年份过时。
2. **可存档打印的书面报告** —— 对话产出的是文本方案。
3. **家族辈分与候选的长期留存** —— 会话结束即丢失，多次起名无法自动对齐。

## 待确认：提审入口与配置规范

> **本专家包尚未提交审核，`plugin.json` 的字段规范未经官方文档核实。**

当前 `plugin.json` 的 schema 是从已安装的第三方专家包（`baby-naming-master` v1.3.0）反推的，不是照官方开放平台规范写的。查到的 WorkBuddy 官方文档只覆盖安装侧（技能市场、专家中心），没有发布/提审说明。

恢复这项工作时依次确认：

- [ ] WorkBuddy 客户端里是否存在专家发布入口（本机 `~/.workbuddy/plugins/marketplaces/my-experts` 为空，说明尚未建过）
- [ ] 提审是否确为「打包目录内容为 zip、不含外层文件夹、上传开放平台」——此说法来自第三方专家包作者的 README 自述，非官方文档
- [ ] 官方 `plugin.json` 字段规范，重点核对 `skills`、`expertType`、`categoryId` 的取值与必填项
- [ ] 展示描述的字数限制（当前按 40–50 字写，依据同样是第三方包的更新日志）

字段规范若与假设不符，改 `plugin.json` 后重新 `build.sh` 即可，`agents/` 与技能真源不受影响。

## 许可证

MIT，见仓库根目录 [LICENSE](../../LICENSE)。
