---
title: MEMS 最小研究链路项目地图
type: project
source: D:\Code\MEMS
tags: [MEMS, Python, COMSOL, project-map]
status: active
paths:
  - D:\Code\MEMS
  - D:\Code\MEMS\pyproject.toml
  - D:\Code\MEMS\src\mems
links: []
next_actions:
  - 在合适 Python 版本环境中运行 synthetic 模式烟测。
  - 检查 COMSOL 路径和模板接口。
  - 将项目输出目录纳入知识库索引。
---

# 项目目标

项目名为 `mems-reliability-loop`，用于把 `研究总纲.md` 中的首轮主线落成可运行代码。README 描述的流程为文献先验参数库、LHS 采样、COMSOL 二维轴对称有限元批处理、Python 机电映射、GP/UQ 风险传播、图表和方法素材输出。

# 入口文件

命令行入口为 `mems-loop = mems.cli:main`。源码位于 `D:\Code\MEMS\src\mems`。

# 关键模块

主要模块包括 `cli.py`、`parameters.py`、`doe.py`、`comsol_runner.py`、`electromech.py`、`surrogate.py`、`figures.py`、`report.py`、`comsol_check.py`、`mesh_check.py` 和 `three_d_check.py`。

# 依赖与脚本

项目依赖 Python 版本范围为 `>=3.10,<3.13`，主要依赖包括 NumPy、Pandas、SciPy、scikit-learn、Matplotlib、Seaborn、PyYAML、MPh 和 JPype1。开发依赖包含 pytest。

# 测试与检查

README 给出的最小链路烟测命令为 `mems-loop run-all --mode synthetic`。COMSOL 链路检查包括 `mems-loop build-comsol-template`、`mems-loop run-all --mode comsol` 和 `mems-loop check-comsol`。

# 风险与未知项

当前 Codex 运行环境的 Python 为 3.13，超出项目声明范围，直接运行项目可能需要切换到 Python 3.11 的 conda 环境。COMSOL 相关命令依赖本机安装路径和授权状态。
