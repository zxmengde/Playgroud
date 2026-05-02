# Hook Risk Stdin Smoke

`scripts/lib/commands/codex-hook-risk-check.ps1` 读取 Codex hook event JSON 的标准输入。它不是参数式 CLI。

安全命令示例：

```powershell
'{"tool_input":{"command":"git status --short"}}' | powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 hook risk
```

预期：无输出，退出码为 0。

危险命令示例：

```powershell
'{"tool_input":{"command":"git reset --hard"}}' | powershell -NoProfile -ExecutionPolicy Bypass -File scripts\codex.ps1 hook risk
```

预期：返回 `permissionDecision` 为 `deny` 的 JSON。

人工 smoke 时不要写成：

```powershell
scripts\codex.ps1 hook risk --Command "git reset --hard"
```

该参数式调用不是当前 hook 输入模型。
