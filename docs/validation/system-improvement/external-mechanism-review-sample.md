# External Mechanism Review Sample

## Question

是否应为跨文件重构任务引入 Serena。

## Candidates

- Serena

## Mechanisms

- 符号级导航
- 引用查找
- 只读定位与编辑阶段分离

## Source Evidence

- commit: `serena-readiness-local`
- path: `C:\Users\mengde\.codex\config.toml`
- line: `[mcp_servers.serena]` 使用本机 `serena` 命令启动 MCP。
- path: `scripts/lib/commands/audit-serena-obsidian-readiness.ps1`
- line: 该脚本检查 `serena --version` 并启动本地 MCP 端口 smoke。

## Fit Decision

- 采用：只读符号导航、引用查找和上下文定位。
- 延后：编辑阶段必须依赖真实代码任务、测试和人工可审查 diff。

## Minimum Implementation

- 用户级 Codex MCP 配置使用本机 `serena`。
- 路由中保留只读阶段与编辑阶段边界。

## Risks

- 语义工具可能扩大修改范围。
- 新会话前工具面板可能未热更新。

## Re-evaluation

- 若三个真实代码任务中没有降低定位步骤或引用误判，则降级为按需工具。
