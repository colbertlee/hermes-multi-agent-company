---
name: designer-skill
description: Designer skill（无 Agent）— 纯格式转换：Markdown → PDF / PPT 大纲 → PPTX / 数据 → 图表。0 token 调用。
trigger: 转 PDF、做 PPT、生成图表、PDF 生成、可视化
model: none（无 LLM，纯工具调用）
---

# Designer Skill v1.0

> 这是 **「+1」部分** — 不是 Agent，是 Skill 调用链。
> 目标：用纯工具替代 LLM 做格式转换，节省 token。

## 职责

把 Content Agent 生成的**内容**变成**成品文件**：

| 输入 | 输出 | 工具 | Token |
|------|------|------|-------|
| Markdown | PDF | `pdf` skill（python fpdf） | 0 |
| PPT 大纲 | PPTX | `powerpoint` skill（python-pptx） | 0 |
| 数据表 | Excel | `xlsx` skill（openpyxl） | 0 |
| 数据 | 图表 PNG | matplotlib + pandas | 0 |
| Markdown | Word docx | pandoc | 0 |

## 为什么不做成独立 Agent

- ❌ LLM 转 PDF：浪费 token（5-10K）+ 不可控
- ✅ python-pptx 转 PDF：精确控制 + 0 token + 工业级稳定

**Designer skill 不调 LLM**，由 Orchestrator 直接调起工具。

## 触发条件

老板说：
- 「转 PDF」「生成 PDF 报告」
- 「做 PPT」「slides」
- 「生成图表」「可视化数据」
- 「转 Excel」

## 调用流程

```
老板：「把这个 SR 报告转 PDF」
    ↓
Orchestrator（我）：
    1. 找到 markdown 文件
    2. 调用 pdf skill
    3. 输出 .pdf
    ↓
老板：「这是成品 PDF，存到 ~/.hermes/content/drafts/」
```

## 3 个核心转换

### 转换 1：Markdown → PDF

**触发**：「转 PDF」

**调用**：
```python
# Orchestrator 直接调
from hermes_tools import terminal
result = terminal("python3 ~/.hermes/scripts/md_to_pdf.py --input ~/.hermes/content/drafts/20260807-sr.md --output 20260807-sr.pdf")
```

**支持的 skill**：Herme s 内置 `pdf` skill（`pdf:create`）

### 转换 2：PPT 大纲 → PPTX

**触发**：「做 PPT」「slides」

**调用**：
```python
# Content Agent 先生成 ppt-outline.md
# Designer skill 调 python-pptx 生成 .pptx
result = terminal("python3 ~/.hermes/scripts/outline_to_pptx.py --input outline.md --template dell --output deck.pptx")
```

**支持的 skill**：Hermes 内置 `powerpoint` skill

### 转换 3：数据 → 图表

**触发**：「图表」「可视化」「生成 PNG 图表」

**调用**：
```python
# Designer skill 用 matplotlib 生成图表
result = terminal("python3 ~/.hermes/scripts/data_to_chart.py --csv data.csv --type line --output chart.png")
```

## 实现位置

```
~/.hermes/scripts/designer/
├── md_to_pdf.py           # Markdown → PDF
├── outline_to_pptx.py     # 大纲 → PPTX
├── data_to_chart.py       # 数据 → 图表
├── table_to_xlsx.py       # 表格 → Excel
└── templates/
    ├── dell_ppt_template.pptx   # Dell 风格 PPT 模板
    └── sr_pdf_template.tex      # SR 报告 LaTeX 模板
```

## Token 经济性

| 任务 | Agent 方案 | Designer Skill | 节省 |
|------|-----------|---------------|------|
| 转 PDF | Designer Agent: 8K | **0 token** | -8K |
| 做 PPT | PPT Agent: 10K | **0 token**（大纲 5K）| -5K |
| 生成图表 | Chart Agent: 5K | **0 token** | -5K |

**对比原 6+1 方案**：单任务节省 5-10K token。

## 与 Content Agent 的协作

```
Content Agent（生成内容）
    ↓ 输出 markdown
Orchestrator（路由判断）
    ↓ 检测到「需要格式转换」
Designer Skill（执行转换）
    ↓ 输出成品
Orchestrator（回报给老板）
```

**Content Agent 不需要懂 PDF/PPTX 工具**，专注写内容。

## 典型场景

### 场景 1：SR 报告一键 PDF

```
老板：「把 SR 报告转 PDF」
Orchestrator：
  1. 找到最新的 .md SR 报告
  2. 调 md_to_pdf.py
  3. 输出 .pdf
  4. 回报：「PDF 已生成，路径 XXX」
```

### 场景 2：客户培训 PPT

```
老板：「做 30 页 PPT 讲 PowerStore 缓存」
Orchestrator：
  1. 派 Content Agent 生成 ppt-outline.md
  2. 调 outline_to_pptx.py + Dell 模板
  3. 输出 .pptx
```

### 场景 3：性能对比图

```
老板：「画个 vSAN 升级前后 IOPS 对比图」
Orchestrator：
  1. 找到两份 csv 数据
  2. 调 data_to_chart.py --type line
  3. 输出 chart.png
```

## 未来扩展

- 加入 Word docx 生成（pandoc）
- 加入 Excel 模板填充
- 加入 HTML 单页报告（self-contained）
- 加入 SVG 架构图（auto-generate）

## 不做什么

- ❌ 不做内容生成（这是 Content Agent 的事）
- ❌ 不做技术决策（这是 Tech Agent 的事）
- ❌ 不调研（这是 Research Agent 的事）
- ✅ 只做「格式转换」和「视觉生成」