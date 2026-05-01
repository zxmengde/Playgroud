# 能力清单、当前缺口与必要复杂度

本文件只记录当前真正落地并可校验的能力，不把愿景当作能力。

## 当前能力

| 能力 | 当前状态 | 当前证据 |
| --- | --- | --- |
| active load 恢复 | 可用 | `routing-v1.yaml`、SessionStart hook、`validate-active-load.ps1`、`eval-session-recovery.ps1` |
| failure / lesson 对象系统 | 可用 | `failures/`、`lessons/`、两个历史样例、对应 validators |
| skill 路由 | 可用 | `routing-v1.yaml`、`tool-router`、`validate-routing-v1.ps1`、`eval-routing-selection.ps1` |
| 自我改进闭环 | 可用 | `failure-promoter`、`harness-log.md`、`eval-lesson-promotion.ps1` |
| 研究工程 | 可用 | `research-engineering-loop`、`research-memo-sample.md`、`eval-research-memo-quality.ps1` |
| 产品工程 | 可用 | `product-engineering-closer`、`product.md`、`eval-product-engineering-closeout.ps1` |
| UI/UX 评审 | 可用 | `uiux-reviewer`、`uiux.md`、`uiux-review-sample.md`、`eval-uiux-review-quality.ps1` |
| 本地 knowledge-first 沉淀 | 可用 | `knowledge-curator`、`knowledge.md`、`validate-knowledge-index.ps1` |
| Obsidian 外部 vault 接入 | 可用 | `obsidian` CLI、`audit-serena-obsidian-readiness.ps1`、真实读写 smoke |
| Serena 语义代码能力 | 可用 | 用户级 `config.toml`、`serena` 安装、`audit-serena-obsidian-readiness.ps1` |
| finish gate | 可用 | `finish-verifier`、Stop hook、`check-finish-readiness.ps1 -Strict` |

## 当前 MCP 结论

| 方向 | 当前处理 | 理由 |
| --- | --- | --- |
| Serena | 已可用 | 已安装并写入用户级 Codex MCP 配置；新会话可直接加载 |
| GitHub | 已可用 | 当前已有 GitHub 连接器和插件能力 |
| Browser / Web | 已可用 | 当前已有 Browser Use、web-workflow 和截图能力 |
| Obsidian | 已可用 | 已确认 vault、CLI 和读写 smoke；当前通过官方 CLI 接入 |
| Remote / long-running | interface-only | 已有来源记录与权限规则，但不默认引入重 runtime |

## 当前缺口

| 缺口 | 当前判断 |
| --- | --- |
| Serena 真实收益数据 | 仍需在真实代码仓库里积累更多跨文件重构对比样例 |
| Obsidian 精细 patch | 当前走官方 CLI；如未来需要 heading/frontmatter 级 patch，再评估 REST API 或 MCP |
| remote/chat runtime | 当前只实现接口规范和权限边界，没有安装完整 runtime |

## 必要复杂度

以下复杂度被保留，因为它们直接提供验证、恢复或防错：

- `routing-v1.yaml`
- `failures/` 与 `lessons/`
- 9 个仓库级 skills
- 5 个 validators
- 8 个 eval 脚本
- 4 个 hooks 阶段

以下复杂度仍然不保留：

- 通用 filesystem、git、memory 类 MCP
- 远程 UI、移动端工作台、kanban 平台的完整 runtime
- 没有真实任务支撑的批量外部 skill 安装
