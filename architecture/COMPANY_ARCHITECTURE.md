# 云间 Agent 公司 · 架构文档 v1.1（3+1 重构版）

> **3+1 架构**：3 个智能 Agent + 1 个 Skill 工具库

---

## 1. 核心变化（vs 1.0）

| 维度 | 之前（4 Profile） | 现在（3+1） |
|------|-----------------|------------|
| Profile 数 | 4 | **3（不变）** |
| 智能 Agent | 4 | **3（合并写作类）** |
| Skill 调用 | 0 | **+Designer（格式转换）** |
| Token 成本 | 中 | **降 ~40%** |

**关键变化**：
- ❌ 删除独立的 Developer/Designer/Analyst Agent 设想
- ✅ Designer 降级为 Skill（纯工具，0 token）
- ✅ Tech Agent 扩展承接 code-script + dell-sop
- ✅ Content Agent 扩展承接 sr-report + email + ppt-outline

---

## 2. 成员清单（最终版）

| 角色 | 模型 | Profile | 职责 | Token |
|------|------|---------|------|-------|
| **Orchestrator（云间）** | MiniMax-M3 | default | 路由 + 汇总 + 简单问答 | <1K |
| **Tech Agent** | MiniMax-M2.7 | tech | 故障诊断、架构、SOP、脚本 | 3-10K |
| **Content Agent** | MiniMax-M2.7 | content | SR、文章、邮件、PPT 大纲 | 3-10K |
| **Research Agent** | MiniMax-M2.7 | research | 调研、对比、选型 | 5-10K |
| **Designer Skill** | — | — | PDF/PPT/图表生成 | **0** |

---

## 3. 协作拓扑

```
                老板
                  │
                  ▼
           ┌─────────────┐
           │ Orchestrator│ ← M3（路由）
           │   (云间)    │
           └──────┬──────┘
                  │
       ┌──────────┼──────────┐
       ▼          ▼          ▼
   ┌───────┐ ┌─────────┐ ┌─────────┐
   │ Tech  │ │ Content │ │Research │
   │ (M2.7)│ │ (M2.7)  │ │ (M2.7)  │
   └───────┘ └─────────┘ └─────────┘
       │          │          │
       └──────────┴──────────┘
                  │
                  ▼
           ┌─────────────┐
           │  Designer   │ ← Skill（0 token）
           │   (skill)   │   PDF/PPT/图表
           └─────────────┘
```

---

## 4. 调用方式（3 层入口）

### 入口 1：自然语言触发

| 触发词 | 派给 |
|--------|------|
| Dell, PowerStore, VxRail, 故障, 报错, 固件, 升级, 扩容, 搬迁, 写脚本, 采集 | **Tech** |
| 写文章, 写报告, 写 SR, 写邮件, PPT, 演示, 大纲 | **Content** |
| 调研, 对比, 哪个好, 竞品, 分析, 推荐 | **Research** |
| 转 PDF, 做图表, 可视化 | **Designer Skill**（Orchestrator 直调）|
| cron, 定时, 备份, 监控 | **Scheduler**（no_agent）|
| 其他 | **Orchestrator 自处理** |

### 入口 2：明确指令

```
「派给 Tech：PowerStore 延迟飙升怎么查」
「派给 Content：基于案例写篇文章」
「派给 Research：Nutanix vs VxRail」
```

### 入口 3：@ 前缀（高级）

```
「@tech <任务>」
「@content <任务>」
「@research <任务>」
```

---

## 5. Orchestrator 决策树

```
收到老板输入
    │
    ├─ 简单问答/查状态/单步操作
    │   └→ Orchestrator 直接答（M3，<500 token）
    │
    ├─ 触发词匹配 Agent 领域
    │   └→ 派对应 Agent（M2.7）
    │       └→ Agent 输出后，可能调 Designer Skill 生成成品
    │
    └─ 多步骤/需持久化/多角色协作
        └→ Kanban 流水线
```

### 决策示例

| 老板说 | 决策 |
|--------|------|
| 「VxRail 报错 X」 | → Tech Agent |
| 「VxRail 报错 X，写 SR」 | → Tech 诊断 + Content 写 SR + Designer 转 PDF |
| 「VxRail 报错 X，做 PPT 给客户讲」 | → Tech 诊断 + Content 出 ppt-outline + Designer 转 PPTX |
| 「VxRail 报错 X，调研对比 Nutanix」 | → Tech + Research 并行 |
| 「转 PDF 这个报告」 | → Designer Skill（直调） |

---

## 6. 完整 Skill 清单

### Orchestrator（我）

- `multi-agent-routing`（默认加载，触发词路由）
- `kanban-task-templates`（任务创建模板）

### Tech Agent

- `dell-diagnosis`（故障诊断，主能力）
- `dell-architecture`（架构设计）
- `dell-sop`（搬迁/升级 SOP）
- `code-script`（Python/Shell 脚本）

### Content Agent

- `sr-report`（Dell SR 服务报告）
- `article`（技术文章，InfoQ/掘金）
- `email`（英文邮件）
- `ppt-outline`（PPT 大纲）

### Research Agent

- `tech-research`（技术调研）
- `competitive-analysis`（竞品分析）

### Designer Skill（无 LLM）

- `pdf`（Markdown → PDF）
- `powerpoint`（大纲 → PPTX）
- `xlsx`（数据 → Excel）
- `chart`（数据 → 图表 PNG）

---

## 7. 文件组织

```
~/.hermes/
├── agents/                              # 多 Agent 公司档案
│   ├── COMPANY_ARCHITECTURE.md          # 架构总纲（本文件 v1.1）
│   ├── ARCHITECTURE_REVIEW.md           # 专家审视（重构依据）
│   ├── USAGE.md                         # 老板使用指南
│   ├── FIELD_SERVICE_GUIDE.md           # FSE 实战手册
│   ├── A2A_COST_PROTOCOL.md             # A2A 成本协议
│   ├── orchestrator/SKILL.md            # Orchestrator 协议
│   ├── tech/                            # Tech Agent
│   │   ├── SKILL.md
│   │   ├── code-script-SKILL.md
│   │   └── dell-sop-SKILL.md
│   ├── content/                         # Content Agent
│   │   ├── SKILL.md
│   │   ├── sr-report-SKILL.md
│   │   ├── email-SKILL.md
│   │   └── ppt-outline-SKILL.md
│   ├── research/SKILL.md                # Research Agent
│   └── designer/                        # Designer Skill（无 Agent）
│       └── SKILL.md
│
├── profiles/                            # Hermes profiles
│   ├── default/                         # Orchestrator（M3）
│   ├── tech/                            # Tech Agent（M2.7）
│   ├── content/                         # Content Agent（M2.7）
│   └── research/                        # Research Agent（M2.7）
│
├── scripts/designer/                    # Designer 工具脚本
│   ├── md_to_pdf.py
│   ├── outline_to_pptx.py
│   └── data_to_chart.py
│
├── content/drafts/                      # Content Agent 输出
├── research/outputs/                    # Research Agent 输出
└── kanban.db                            # Kanban SQLite
```

---

## 8. Token 经济性（重构前后对比）

| 任务 | 4 Agent (v1.0) | 3+1 (v1.1) | 节省 |
|------|---------------|-----------|------|
| 简单问答 | 0.5K | 0.5K | 0 |
| 故障诊断 | 5K | 5K | 0 |
| 写 SR 报告 | 8K | 8K | 0 |
| 写技术文章 | 8K | 8K | 0 |
| 英文邮件 | 3K | 3K | 0 |
| **PDF 生成** | Designer Agent: 8K | **0K** | **-8K** |
| **PPT 生成** | Designer Agent: 10K | **0K** | **-10K** |
| **数据统计** | Analyst Agent: 5K | **0K** | **-5K** |
| **Excel 处理** | Analyst: 3K | **0K** | **-3K** |
| **写脚本** | Developer Agent: 5K | Tech: 3K | **-2K** |
| 调研对比 | 5K | 5K | 0 |
| 复杂流水线 | 15K | 12K | -3K |

**总计**：覆盖 95% 工作流，**节省 ~40% token**。

---

## 9. 什么时候该扩展

不是永远不增加 Agent。**3 个扩展信号**：

### 信号 1：Profile 长期排队 / Token 超预算

某类任务持续超出预算 → 拆出独立 profile。

### 信号 2：任务模式差异化

新 Agent 的工作模式与现有 3 个**根本不同**（如：纯推理 vs 纯执行）。

### 信号 3：团队规模扩大

5+ 人团队 → 需要 PM Agent、Reviewer Agent。

**当前老板是单人 FSE，不需要这些**。

---

## 10. 绝对禁止

1. ❌ Specialist 之间互相调用
2. ❌ Orchestrator 做深度推理
3. ❌ 在简单任务上浪费 M2.7 token
4. ❌ Specialist 向老板直接提问
5. ❌ 编造数据（KB/SKU/编号 → unknown）
6. ❌ 把 Skill 工作错配成 Agent（浪费 token）

---

## 11. 决策框架（给未来的自己）

每次想加 Agent 时，问 4 个问题：

1. 这个任务**需要 LLM 推理吗**？不需要 → 用 skill，0 token
2. 现有 Agent **已有相关 skill 吗**？有 → 复用
3. 这个任务**频率高**吗（每周 ≥3 次）？低 → delegate_task
4. 拆分后 token 节省 **>** 拆分成本？是 → 新建；否 → 复用

**只有 4 个都通过，才新增 Agent**。

---

*最后更新：2026-08-07 · 云间 Multi-Agent Company v1.1（3+1 重构版）*
*🦞*