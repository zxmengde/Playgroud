# GitHub 与 Git 代理诊断

本文件记录 GitHub 网络失败时的诊断顺序。目标是减少重复试错，并避免把“设置 Git 代理”当作唯一原因。

## 当前已知状态

2026-04-25 在本仓库检查到 `.git/config` 已包含：

```text
http.proxy=http://127.0.0.1:7897
https.proxy=http://127.0.0.1:7897
```

但 `git ls-remote --heads origin` 仍失败，错误为 `failed to open socket: Unknown error 10106 (0x277a)`；`curl.exe --proxy http://127.0.0.1:7897 https://github.com` 无法连接代理端口；当前 Codex 子进程中未观察到 `:7897` 监听项。`CheckNetIsolation LoopbackExempt -s` 输出中未看到 OpenAI.Codex 包名。

因此，本轮问题不是简单缺少 `git config http.proxy http://127.0.0.1:7897`。更可能的原因包括：Clash/Mihomo 实际未监听 7897、本进程无法访问 loopback、Windows 打包应用需要 loopback exemption，或当前 shell 的网络栈初始化异常。

后续进一步诊断显示：Clash Verge 配置文件中存在 `mixed-port: 7897`，Windows 用户级系统代理也指向 `127.0.0.1:7897`，但 `curl.exe --proxy http://127.0.0.1:7897 https://github.com` 仍无法连接。`clash_verge_service` 服务处于运行状态，但普通 Codex 进程尝试重启服务时返回 `Access is denied`。`CheckNetIsolation` 对推断的 Codex 包名添加 loopback exemption 失败，且 Codex 包使用 `runFullTrust`，loopback exemption 不是可靠主路径。

2026-04-26 再次运行 `scripts/test-git-network.ps1 -Proxy http://127.0.0.1:7897 -Remote origin` 显示代理 TCP 端口已经可达，但 `curl` 和 `git ls-remote` 均在 Schannel TLS 握手阶段失败，错误为 `schannel: failed to receive handshake, SSL/TLS connection failed`。因此当前主要问题已从“代理端口不可达”转为“代理链路可建立 CONNECT，但 TLS 握手失败”。后续应优先检查 Clash/Mihomo 节点、规则、证书拦截、Git TLS 后端、系统时间和普通终端中同一命令的表现。

## 诊断脚本

优先运行：

```powershell
.\scripts\test-git-network.ps1 -Proxy http://127.0.0.1:7897 -Remote origin
```

脚本会检查 Git 代理配置、远程地址、代理端口可达性、curl 代理访问和 `git ls-remote`。失败时根据具体阶段判断下一步。

## 判断路径

若代理端口不可达，先在普通 PowerShell 或终端中运行：

```powershell
netstat -ano | findstr :7897
```

没有监听时，应在 Clash Verge 中确认端口设置、Mixed Port/HTTP 代理是否启用、Mihomo 是否运行，并重启 Clash Verge 或内核。

若 Clash Verge 界面显示系统代理已开启，但端口不可达，优先在 Clash Verge 中执行以下操作：

1. 关闭系统代理，再重新开启系统代理。
2. 重启 Clash 内核或重启 Clash Verge。
3. 若使用服务模式，以管理员身份重启 `clash_verge_service`。
4. 重新运行 `netstat -ano | findstr :7897` 和 `curl.exe -I --proxy http://127.0.0.1:7897 https://github.com`。

管理员 PowerShell 可尝试：

```powershell
net stop clash_verge_service
net start clash_verge_service
```

若服务重启后仍无监听，检查 Clash Verge 的端口设置是否实际启用了 mixed port，或临时启用单独 HTTP 端口后把 Git 代理指向该端口。

若普通 PowerShell 能连接代理，但 Codex 中不能连接，优先考虑 Windows 打包应用 loopback 限制。可在用户确认后，用管理员 PowerShell 尝试为 Codex 包增加 loopback exemption。包名通常可从安装路径推断为：

```powershell
CheckNetIsolation LoopbackExempt -a -n=OpenAI.Codex_2p2nqsd0c76g0
```

该操作会改变系统级网络访问配置，执行前必须确认。执行后重新运行诊断脚本。

若代理端口可达但 `curl` 或 Git 在 TLS 握手失败，先在普通 PowerShell 中复现：

```powershell
curl.exe -I --proxy http://127.0.0.1:7897 https://github.com
git ls-remote --heads origin
```

若普通终端同样失败，优先检查 Clash/Mihomo 当前节点、规则模式、证书相关配置和系统时间。若普通终端成功而 Codex 失败，再考虑 Codex 进程网络隔离或 TLS 后端差异。

若代理端口可达但 Git 失败，检查 Git 配置和环境变量：

```powershell
git config --show-origin --get-regexp "^(http|https)\..*proxy|^http\.proxy|^https\.proxy"
```

本仓库可使用本地配置：

```powershell
git config http.proxy http://127.0.0.1:7897
git config https.proxy http://127.0.0.1:7897
```

若希望所有仓库都使用该代理，需经用户确认后再设置 `--global`。全局配置可能影响其他项目。

## 替代路径

若 Codex 内部仍无法访问 GitHub，但普通终端可访问，可在普通 PowerShell 中完成 Git 同步：

```powershell
cd D:\Code\Playgroud
git status
git pull
git push
```

若普通终端也无法访问，先修复 Clash 端口监听，再处理 Git。若只需要读取或操作 GitHub PR/Issue，可临时使用 GitHub 连接器或网页路径；但本地提交、拉取和推送仍需要本机 Git 网络恢复。

若希望绕过 Windows 当前网络栈，可考虑安装并配置 WSL 后在 WSL 中执行 Git；当前机器检测到没有可用 WSL 发行版，因此这不是现成路径。

## 权限边界

Codex 可直接运行只读诊断和仓库本地 Git 配置检查。修改全局 Git 配置、系统 loopback exemption、Clash 配置、TUN 模式或长期网络服务前需要用户确认。
