# Serena 与 Obsidian 接通记录

## 摘要

本次将 Serena 从 candidate 接为用户级 Codex MCP，将 Obsidian 从 knowledge-first candidate 接为官方 CLI 可用能力。两者都已完成本机安装或命令接通、用户级配置写入、基本 smoke test 和仓库内能力登记。

## Serena

- 安装方式：`uv tool install -p 3.13 serena-agent@latest --prerelease=allow`
- 初始化：`serena init -b LSP`
- 用户级配置：`C:\Users\mengde\.codex\config.toml`
- 用户级 Serena 配置：`C:\Users\mengde\.serena\serena_config.yml`
- MCP 入口：

```toml
[mcp_servers.serena]
type = "stdio"
startup_timeout_sec = 30
command = "serena"
args = ["start-mcp-server", "--project-from-cwd", "--context=codex"]
```

- 验证：
  - `serena --help`
  - `serena start-mcp-server --help`
  - `scripts/lib/commands/audit-serena-obsidian-readiness.ps1` 启动 streamable-http 模式并检查端口
  - `project_serena_folder_location` 已改为用户目录下的集中位置，避免在仓库根目录生成 `.serena/`

## Obsidian

- 本机应用：`C:\Users\mengde\AppData\Local\Programs\Obsidian\Obsidian.exe`
- CLI redirector：`C:\Users\mengde\AppData\Local\Programs\Obsidian\Obsidian.com`
- 已识别 vault：
  - `790d1fd6473f4a93` -> `C:\Users\mengde\OneDrive\笔记`
  - `530512f0c6c3c99b` -> `D:\Code\obsidian`

- 验证：
  - `obsidian version`
  - `obsidian vaults total`
  - `obsidian vault=790d1fd6473f4a93 files total`
  - `obsidian vault=790d1fd6473f4a93 search query="Zotero" total`
  - 在 `D:\Code\obsidian` vault 中创建并读取 `Codex/obsidian-cli-smoke.md`

## 边界

- Serena 当前已接通，但真实收益仍需在实际代码仓库里继续积累样例。
- Obsidian 当前走官方 CLI，不做 frontmatter/heading 级精细 patch；若后续需要，再评估 REST API 或 MCP。
- remote / long-running 仍未接通完整 runtime。
