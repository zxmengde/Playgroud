# External Skills

更新时间：2026-05-04

## 安装位置

项目级 Codex skills 安装在：

```text
D:\Code\Playgroud\.codex\skills
```

全局 active 目录不再保留这批外部 skills。原全局副本已移到可回滚备份：

```text
C:\Users\mengde\.codex\skills.disabled\2026-05-04-project-level-migration
```

2026-05-03 新增 432 个外部 skills。2026-05-04 已按能力簇做精简：每个候选分类先读取同类来源 `SKILL.md`，再选出 keeper，并把重复 skill 的独特机制写回 keeper。第一版只把大量内容放进 `references`，不够；随后已把旧的泛化合并段替换为分类化合并段，并把 imported variants 内的嵌套 `SKILL.md` 改名为 `SOURCE_SKILL.md`，避免来源副本继续作为独立 skill 自动触发。重复来源完整目录仍保存在 keeper 的 imported variants 目录，并移动到 `C:\Users\mengde\.codex\skills.disabled\2026-05-04\`。没有永久删除。

2026-05-04 已把精简后的 active skills 从全局目录复制到项目级 `.codex/skills/`。项目级副本与迁移前全局 active skills 做过完整文件哈希对比，结果为 281 个 skill、0 个缺失、0 个额外、0 个哈希差异。哈希对比通过后，迁移前的全局 active skills 已移动到上方 disabled 备份目录，不再作为全局 skills 触发。

同日最终边界复核后，项目级 active skills 为 284 个。复核重点不是继续减少数量，而是修正误禁用和误重叠：原版服务适配、context-mode 子命令、UI visual verdict / visual ralph、workspace state workflow 被恢复或重建；`omx-swarm`、`omx-web-clone`、`claude-scholar-daily-coding` 这类无独立触发价值的 active 重复入口被合并或移除。

## 已安装 CLI

| 来源 | 命令 | 已安装版本 |
| --- | --- | --- |
| ui-ux-pro-max-skill | `uipro` | `uipro-cli@2.2.3` |
| oh-my-codex | `omx` | `oh-my-codex@0.15.3` |
| AI-Research-SKILLs | `ai-research-skills` | `@orchestra-research/ai-research-skills@1.6.0` |
| Trellis | `trellis`, `tl` | `@mindfoldhq/trellis@0.5.0-beta.19` |
| context-mode | `context-mode` | `context-mode@1.0.107` |

说明：`ai-research-skills --help` 会进入交互安装器，不适合作为非交互 smoke；本轮使用本地仓库副本复制 skills。`context-mode --help` 会启动 stdio MCP server 并打印运行信息。

## 当前 Skills 数量

| 指标 | 数量 |
| --- | ---: |
| 项目级 active skill 目录 | 284 |
| 项目级 active `SKILL.md` | 284 |
| 全局 active skill 目录 | 0 |
| 全局迁移备份 skill 目录 | 281 |
| 2026-05-04 禁用重复 skill | 175 |
| 2026-05-04 disabled 复判候选 | 175 |
| restored / rebuilt active 子能力 | 6 |
| removed active facade / deprecated duplicate | 3 |
| keeper synthesized insight 文件 | 105 |
| 主 `SKILL.md` 分类化合并规则 keeper | 108 |
| imported variants 内残留可自动触发 `SKILL.md` | 0 |
| active skill name 重复 | 0 |

项目级 inventory：`docs/skill-inventory-2026-05-04.json`。

精简报告：`docs/skill-consolidation-report.md`。

## 当前外部 Skills 分布

| 来源 | 前缀 | 数量 |
| --- | --- | ---: |
| AI-Research-SKILLs | `ai-research-` | 98 |
| Auto-claude-code-research-in-sleep Codex skills | `aris-skills-codex-` | 67 |
| Auto-claude-code-research-in-sleep unique base/service skills | `aris-` | 4 |
| claude-scholar | `claude-scholar-` | 33 |
| context-mode | `context-mode-` | 3 |
| oh-my-codex root skills | `omx-` | 33 |
| oh-my-codex plugin skills | `omx-plugin-` | 0 |
| Trellis | `trellis-` | 18 |
| ui-ux-pro-max-skill | `uipro-` | 7 |
| 原版服务适配 | `vibe-kanban-service`, `aris-watchdog-service` | 2 |
| 恢复的 UI 子能力 | `omx-visual-verdict`, `omx-visual-ralph` | 2 |

## Final Fit Map Roles

2026-05-04 最终收敛后，active skills 只使用以下角色：

| role | 数量 | 用途 |
| --- | ---: | --- |
| `primary` | 7 | 领域主入口，例如 coding、research、knowledge、UI/UX、office、workspace state |
| `pipeline` | 14 | 明确端到端流程 |
| `provider_variant` | 87 | 工具、模型、框架、服务、生态或实现变体 |
| `stage_specialist` | 74 | 阶段型产物或评审 |
| `domain_specialist` | 50 | 领域专门知识 |
| `service_adapter` | 2 | 原版后台/服务运行入口 |
| `command_adapter` | 49 | CLI、工具或命令型入口 |
| `output_contract` | 1 | 结构化输出契约 |

175 个 disabled 候选的复判结论：

| decision | 数量 | 处理 |
| --- | ---: | --- |
| `merged_into_keeper` | 40 | 独特机制已进入 keeper 或新短 keeper |
| `restore_active` | 2 | 恢复为独立 active 子能力 |
| `reference_only` | 1 | 只保留历史参考 |
| `platform_duplicate` | 102 | 非 Codex 平台副本 |
| `distribution_duplicate` | 30 | 分发形态或旧命名副本 |

## 主要调用示例

UI/UX：

```powershell
uipro init --ai codex --offline
```

oh-my-codex：

```powershell
omx --version
omx help
```

AI-Research-SKILLs：

```powershell
ai-research-skills
```

Trellis：

```powershell
trellis --version
tl --help
```

context-mode：

```powershell
context-mode
```

ARIS 原版后台服务仍通过仓库统一入口调用：

```powershell
.\scripts\codex.ps1 aris install
.\scripts\codex.ps1 aris watchdog start -Interval 60
.\scripts\codex.ps1 aris watchdog status
```

vibe-kanban 原版服务仍通过仓库统一入口调用：

```powershell
.\scripts\codex.ps1 vibe start -Port 3210
.\scripts\codex.ps1 vibe status
```

恢复后的项目级 skill 触发边界：

- `vibe-kanban-service`：只处理原版 Vibe Kanban 服务启动、状态、停止和回滚。
- `aris-watchdog-service`：只处理原版 ARIS watchdog 后台运行、注册、注销和停止。
- `workspace-state-workflow`：处理本地 task board、attempt、recover、research queue、review gate 和 run log。
- `context-mode-context-mode`：只处理大输出、长日志、快照、API 响应和文档索引的上下文压缩/检索，不再作为所有命令的默认主入口。
- `context-mode-command-adapters`：处理 `ctx-doctor`、`ctx-stats`、`ctx-insight`、`ctx-purge`、`ctx-upgrade`。
- `omx-visual-verdict`：截图与参考图的 JSON 判定输出契约。
- `omx-visual-ralph`：参考驱动 UI 实现循环。
- `uipro-ui-styling`：只处理 shadcn/ui、Radix、Tailwind、暗色模式和可访问组件的代码级样式实现。
- `doc`：只处理 DOCX 渲染、编辑和视觉检查；更宽的 Office 编排由 `office-workflow` 负责。
- `omx-team`：已吸收旧 `omx-swarm` facade；`swarm` 请求路由到 `omx-team`。
- `omx-visual-ralph`：已吸收旧 `omx-web-clone` 的 live-URL visual implementation 路由。
- `coding-workflow`：已吸收 `claude-scholar-daily-coding` 的普通编码检查清单；日常代码修改不再有第二个 active 入口抢触发。

## 重复与重叠能力

2026-05-03 检测到 106 个原始 skill 名称重复组。2026-05-04 已处理确定重复或高度重叠的 175 个 skill，处理方式是导入后禁用，不是永久删除；其中可保留机制已按分类写入对应 keeper 的主 `SKILL.md`。

高重复项：

| 重复区域 | 已安装项 | 建议决策 |
| --- | --- | --- |
| Trellis 多 agent 模板 | `.agents`、`.claude`、`.cursor`、`.opencode`、`.pi`、CLI templates 中的 `trellis-before-dev`、`trellis-check`、`trellis-meta` 等 | 已保留 Codex templates；非 Codex 平台副本已导入对应 keeper 后禁用。 |
| ARIS base / Codex / Gemini review / Claude review | `aris-*`、`aris-skills-codex-*`、`aris-skills-codex-gemini-review-*`、`aris-skills-codex-claude-review-*` | 已保留 `aris-skills-codex-*`；base 同名项和 review overlay 已导入 keeper 后禁用；base 独有项保留。 |
| oh-my-codex root 与 plugin | `omx-*` 与 `omx-plugin-*` 中大量同名，如 `autoresearch`、`code-review`、`plan`、`team`、`trace` | 已保留 root skills；plugin 副本已导入 root 或最终 keeper 后禁用。 |
| UI/UX | `uipro-*`、`omx-frontend-ui-ux`、`omx-visual-verdict`、`claude-scholar-ui-ux-pro-max`、`claude-scholar-frontend-design`、`claude-scholar-web-design-reviewer` | `uipro-ui-ux-pro-max` 保留为 primary；`omx-visual-verdict` 恢复为 output contract；`omx-visual-ralph` 恢复为 reference-driven stage specialist；其余重叠评审机制留在 primary。 |
| 科研写作与引用 | `aris-paper-*`、`aris-citation-audit`、`ai-research-20-ml-paper-writing-*`、`claude-scholar-ml-paper-writing`、`claude-scholar-citation-verification` | 可按论文阶段保留：构思、实验、结果、写作、引用核验。 |
| 代码评审与测试 | `omx-code-review`、`omx-review`、`omx-tdd`、`claude-scholar-code-review-excellence`、`claude-scholar-bug-detective`、已有 `coding-workflow` | 已保留 `coding-workflow` 为代码评审 keeper；`omx-tdd` 暂保留为专项 TDD。 |
| 上下文与任务管理 | `context-mode-*`、`trellis-*`、`omx-note`、`omx-trace`、`omx-pipeline`、`omx-team` | `context-mode-context-mode` 只处理大输出上下文压缩/检索；`context-mode-command-adapters` 处理 ctx 子命令；`context-mode-context-mode-ops` 只保留上游 GitHub ops；Trellis 路径化 skill 已改短名。 |

## 回滚

回滚到全局模式：把 `C:\Users\mengde\.codex\skills.disabled\2026-05-04-project-level-migration\<skill>` 移回 `C:\Users\mengde\.codex\skills\<skill>`，然后删除或移走 `D:\Code\Playgroud\.codex\skills`。

只取消本仓库项目级 skills：删除或移走 `D:\Code\Playgroud\.codex\skills`。这会让本仓库不再加载这批外部 skills，除非先按上一段恢复全局模式。

回滚 2026-05-04 精简：把目录从 disabled 移回 active：

```powershell
$disabled = 'C:\Users\mengde\.codex\skills.disabled\2026-05-04'
$active = 'C:\Users\mengde\.codex\skills'
# 示例：恢复某个被禁用 skill
Move-Item "$disabled\<category>\<skill>" "$active\<skill>"
```

回滚 2026-05-03 全量安装：删除本轮安装的前缀目录：

```powershell
$root = 'C:\Users\mengde\.codex\skills'
'uipro','omx','omx-plugin','ai-research','aris','claude-scholar','context-mode','trellis' |
  ForEach-Object {
    Get-ChildItem $root -Directory -Filter "$_-*" | Remove-Item -Recurse -Force
  }
```

全局 CLI 回滚：

```powershell
npm uninstall -g uipro-cli oh-my-codex context-mode @mindfoldhq/trellis @orchestra-research/ai-research-skills
```
