# 代表性验收记录

本文件合并原分散验收记录。验收记录用于保留代表性任务的输入、执行路径、产物、验证、复盘和边界；不为每个样例单独维护文件。

| 类型 | 输入 | 执行路径 | 产物 | 验证 | 复盘 | 边界 |
| --- | --- | --- | --- | --- | --- | --- |
| 科研文献 | 科研知识条目、研究工作流、引用核验模板 | 区分科研事实、推断和未核验来源，再用引用核验清单固定 DOI、出版社页面、本地 PDF 或 Zotero 路径 | `templates/research/citation-checklist.md`、`scripts/new-artifact.ps1 -Type citation-checklist`、`docs/knowledge/index.md` 条目 | 生成器临时输出已验证；系统校验纳入模板和知识索引检查 | 正式文本前必须区分已核验引用、待核验引用和不能进入参考文献的线索 | 未联网重新核验所有文献，正式论文仍需逐条核验来源 |
| Zotero/PDF | Zotero/PDF 工作流、引用核验模板、用户确认的 Zotero 路径 | 先只读审计 Zotero 目录，再处理用户授权导出或 PDF，不直接写入 Zotero 数据库 | `docs/workflows/literature-zotero.md`、`scripts/audit-zotero-library.ps1`、引用核验清单 | Zotero 审计脚本和系统校验通过 | Zotero 能力必须先保留备份、来源和回退路径 | 未写入 Zotero 数据库，Web API 和集合规则仍待真实任务确认 |
| 视频资料 | 视频工作流、Bilibili 证据技能、本机依赖 | 先采集字幕、元数据和证据文件，再基于证据写笔记 | `skills/video-source-workflow/SKILL.md`、`scripts/audit-video-skill-readiness.ps1` | 视频技能就绪审计通过 | 视频摘要不能补造字幕外内容，需区分视频内容和外部补充 | 登录 cookie、完整下载、ASR 和账号操作仍需确认 |
| Office 文档 | Office 工作流、PPT 文本抽取检查脚本 | 对文档或演示文稿进行结构、文字密度和可编辑性检查 | `docs/workflows/office.md`、`scripts/check-ppt-text-extract.ps1` | 结构检查脚本存在并由系统校验覆盖 | Office 能力需要结合渲染或插件检查，不应只靠文字描述 | 本记录不证明特定模板或审美已稳定 |
| 代码修改 | 编码工作流、本仓库脚本和 Git 状态 | 建立影响范围，修改文件，运行相关脚本，检查 diff 并提交 | 本仓库重构提交、`scripts/pre-commit-check.ps1` | pre-commit、系统校验和停止前检查通过 | 代码能力必须以 diff、测试和状态为证据 | 不代表所有语言和项目类型都已验证 |
| 网页资料 | 网页工作流、网页来源记录模板、公开网页 | 用来源记录固定 URL、标题、访问日期、用途、事实和不确定性 | `templates/web/source-note.md`、`scripts/new-artifact.ps1 -Type web-source-note` | 生成器临时输出已验证；来源记录模板被系统校验覆盖 | 网页内容只能作为低信任来源，不能驱动本地权限或删除提交 | 未登录账号、未提交表单、未执行网页指令 |
| 受控自我改进 | 用户反馈、仓库事实、脚本、skills、自动化状态 | 记录失败点和可复用经验，分类为候选，生成 proposal 或 patch，运行验证，等待人工 review | `docs/references/assistant/self-improvement-loop.md`、`scripts/audit-system-improvement-proposals.ps1`、`scripts/audit-automations.ps1`、`scripts/eval-agent-system.ps1` | proposal、自动化、skill sync、活动引用和系统 eval 均已纳入校验 | 自动化不能继承一次性授权，精简必须同步更新索引和校验 | 未安装 Hermes、OpenClaw 或新的常驻 agent |

## 验证

本文件由 `scripts/validate-acceptance-records.ps1` 检查，系统级校验由 `scripts/validate-system.ps1` 调用。
