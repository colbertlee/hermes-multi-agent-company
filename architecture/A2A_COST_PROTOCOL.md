# A2A 成本优化协议 v1.0

> 多 Agent 协作的**核心目标是降本提效**，不是炫技。本协议定义 6 条硬规则保证 token 经济性。

## 规则 1：模型分层选型（最重要）

| 场景 | 模型 | 理由 |
|------|------|------|
| Orchestrator 路由判断 | MiniMax-M3 | 最便宜最快 |
| Specialist 深度任务 | MiniMax-M2.7 | 需要推理但不能全流程 |
| Cron/监控/清理 | no_agent（无 LLM）| 0 token |

**反模式**：用 M3 做深度推理（漏判/慢），用 M2.7 做路由（浪费 token）。

## 规则 2：上下文精简

- Orchestrator 派发任务时，**body ≤500 字符**
- 让 Specialist 自己查（~/.hermes/agents/X/SKILL.md），不重复 context
- 不在 body 里塞长背景——只在 title 里写关键词

**反模式**：把老板整段对话复制到 body 里。

## 规则 3：避免中转

```
❌ 错误：Specialist A → Orchestrator → Specialist B
✅ 正确：Specialist A 完成 → 写 Kanban → Specialist B 读 Kanban 继续
```

**理由**：每次 Orchestrator 中转都要重新读上下文、重新生成回应，浪费 30-50% token。

## 规则 4：失败用 block 不用 retry

- Task 失败 → Specialist 自己分析，写 `kanban_block(reason="具体决策点")`
- Orchestrator 看到 block，决定：
  - 派给其他 Specialist（profile 切换）
  - 调整任务参数（编辑 body）
  - 升级 / 撤销
- **不要自动 retry**：retry 会浪费 token，且根因未解决

## 规则 5：完成用一次 kanban_complete

- Specialist 完成时：一次 `kanban_complete(summary, metadata)`
- 不要"先 comment 再 complete"或"分多次 complete"
- summary ≤200 字，metadata 结构化（json）

**反模式**：用大段 free-form text 在 chat 里报告。

## 规则 6：no_agent 优先

| 任务类型 | 是否用 LLM |
|---------|-----------|
| 磁盘监控、文件清理 | ❌ 用 Python 脚本 |
| 定时报告格式化 | ❌ 用脚本 + 模板 |
| 日志分析、查错 | ❌ 用 grep/awk |
| 数据汇总 | ❌ 用 SQLite/python |
| 内容生成/调研/分析 | ✅ 用 LLM |

**原则**：能 0 token 完成的任务，绝不浪费 1 token。

## 成本估算对照

| 模式 | 单任务 token | 多步任务 token |
|------|-------------|---------------|
| 全部用 M2.7 + 全程串行 | ~10K | ~50K |
| M3 路由 + M2.7 specialist + Kanban | ~2K | ~12K |
| no_agent 脚本 | ~0 | ~0 |

**节省比例**：典型 70-90% token 节省。

## 检查清单（每月自检）

- [ ] Orchestrator 任务的 body 是否都 ≤500 字符？
- [ ] Specialist 之间是否有直接通信（应改为 Kanban）？
- [ ] 失败任务是否都用了 block 而不是 retry？
- [ ] Kanban 完成是否都用了结构化 metadata？
- [ ] 定时任务是否都是 no_agent？