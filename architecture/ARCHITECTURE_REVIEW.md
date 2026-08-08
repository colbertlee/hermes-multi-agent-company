# 多 Agent 架构审视 · AI Agent 专家视角

> 作者：Orchestrator (Hermes)
> 日期：2026-08-07
> 目的：从 AI Agent 工程角度审视当前架构，避免过度设计。

---

## 一、初始问题

老板抛出一个问题：「代码/脚本、PDF/PPT、数据统计、文件处理、外企 FSE 工作这些日常事务，按当前架构应该分配给谁？」

最初的「自然分类」做法是：每种工作分配一个 Agent。结果得到了一个 6+1 的「过度工程化」方案。

这是**典型的 AI Agent 设计陷阱**：把"工种"等同于"Agent"。

---

## 二、AI Agent 设计的核心原则

设计多 Agent 系统时，应该遵循 4 个原则：

### 原则 1：Agent 是「决策者」，不是「执行者」

- ✅ Agent **应该**：做判断、做规划、做生成（需要 LLM 智能）
- ❌ Agent **不应该**：做格式转换、做数据搬运、做机械执行

**反例**：用一个 Agent 把 markdown 转 PDF（这是 pandoc 的活，不是 LLM 的活）

### 原则 2：复用 > 拆分

能用 1 个 Agent 解决的问题，不要拆成 3 个。每个 Agent 都有协调开销。

**反例**：写 Python 脚本 vs 写 Shell 脚本需要两个 Agent 吗？不需要，是同一个技能的两个分支。

### 原则 3：Token 经济性是硬指标

每多一个 Agent：
- 触发词判断 → 加 token
- 上下文传递 → 加 token
- 协调开销 → 加 token

**节省的 token 必须 > 增加的开销**，否则拆分无意义。

### 原则 4：Profile 数 ≠ Agent 数

Hermes 的 profile（独立 LLM 配置）和"业务 Agent"不是 1:1：
- 1 个 profile 可以加载多个 skill
- 1 个 skill 可以由多个 profile 共享
- **按需扩展**，而不是按"工种"扩展

---

## 三、当前架构审视

### 当前 4 Profile 架构

```
default (M3)  → Orchestrator
tech (M2.7)   → Tech Agent
content (M2.7) → Content Agent
research (M2.7) → Research Agent
```

### 「过度设计」倾向

最初按"工种"对应"Agent"的逻辑，会推导出 6+1 架构：

| 想加的 Agent | 真实需求 |
|------------|---------|
| Developer | 写 Python 脚本 → **0 token 用脚本就能做** |
| Designer | 转 PDF/PPT → **skill 即可** |
| Analyst | 数据统计 → **0 token 用脚本** |
| SR Writer | 写 SR → **Content Agent 就能做**（目标读者是工程师，模板固定）|
| Marketing Writer | 写文章 → **Content Agent 也能做**（同样是写作）|
| Project Manager | 复杂项目 → **Orchestrator + Tech Agent 协作**（Kanban 流水线的本质就是 PM）|

**问题**：拆开看每个都有道理，但合起来 token 开销 + 协调成本 > 收益。

### 重新审视「应该拆分 vs 应该复用」

| 工作 | 是否需要独立 Agent | 理由 |
|------|------------------|------|
| 故障诊断 | ✅ Tech Agent | 专业领域、需要推理 |
| 架构设计 | ✅ Tech Agent | 同上 |
| 写 SR 报告 | ❌ Content Agent 兼任 | 同属"文档写作" |
| 写技术文章 | ❌ Content Agent 兼任 | 同属"文档写作" |
| 写英文邮件 | ❌ Content Agent 兼任 | 同属"文档写作" |
| PPT 大纲 | ❌ Content Agent 兼任 | 同属"文档写作" |
| PDF 视觉排版 | ❌ Skill 即可 | 纯格式转换 |
| PPT 视觉设计 | ❌ Skill 即可 | 纯格式转换 |
| 写 Python 脚本 | ❌ Tech Agent 兼任 | Tech Agent 已经有开发能力 |
| 数据统计 | ❌ Skill + 脚本 | 纯执行 |
| Excel 处理 | ❌ xlsx skill | 纯执行 |
| 调研对比 | ✅ Research Agent | 专业推理 |
| 搬迁项目 | ❌ Tech + Kanban | 不是 PM Agent，是任务流 |

**结论**：6 个候选 Agent 中，**只有 Research Agent 有独立价值**。其他都应复用现有 Agent 或降级为 Skill。

---

## 四、3+1 重构方案

### 架构图

```
Orchestrator (M3)
    │
    ├── Tech Agent (M2.7)        ← 故障/架构/方案/脚本
    │   ├── skill: dell-diagnosis
    │   ├── skill: dell-architecture
    │   ├── skill: dell-sop
    │   └── skill: code-script
    │
    ├── Content Agent (M2.7)     ← SR/文章/邮件/PPT大纲
    │   ├── skill: sr-report
    │   ├── skill: article
    │   ├── skill: email
    │   └── skill: ppt-outline
    │
    ├── Research Agent (M2.7)    ← 调研/对比/选型
    │   ├── skill: tech-research
    │   └── skill: competitive
    │
    └── Designer (skill-only)    ← PDF/PPT/图表（无 Agent）
        ├── skill: pdf-layout
        ├── skill: ppt-design
        └── skill: chart-viz
```

### 「+1」的含义

**Designer 不占 profile**，是纯 skill 调用。它的工作是格式转换，不需要 LLM 推理——交给 fpdf/python-pptx/matplotlib 这些库就够了。

**这节省**：
- 1 个 profile（不需要独立 LLM）
- 每次调用省 ~5K token 的 prompt
- 加快响应（不调 LLM）

---

## 五、Token 节省对照

| 任务 | 6+1 方案 | 3+1 方案 | 节省 |
|------|---------|---------|------|
| 客户现场诊断 | Tech: 5K | Tech: 5K | 0 |
| 写 SR 报告 | SR-Writer: 8K | Content: 8K | 0 |
| 写技术文章 | Marketing-Writer: 8K | Content: 8K | 0 |
| 英文邮件 | Content: 3K | Content: 3K | 0 |
| PPT 大纲 | Content: 5K | Content: 5K | 0 |
| **PDF 生成** | Designer Agent: 8K | **Designer skill: 0** | **-8K** |
| **数据统计** | Analyst Agent: 5K | **Analyst skill: 0** | **-5K** |
| **写 Python 脚本** | Developer Agent: 5K | **Tech: 3K** | **-2K** |
| **Excel 处理** | Analyst: 3K | **xlsx skill: 0** | **-3K** |
| 调研对比 | Research: 5K | Research: 5K | 0 |
| 复杂项目 | PM Agent: 5K | **Kanban 流水线: 3K** | **-2K** |

**总节省**：~20K token / 复杂任务（**约 -40% token 开销**）

---

## 六、什么时候该扩展

不是说永远不增加 Agent。**3 个扩展信号**：

### 信号 1：Profile 长期排队 / Token 超预算

如果某类任务（不是某次）持续超出预算，且 Orchestrator 路由开销 > 节省，说明任务量大到需要独立 profile。

### 信号 2：任务模式差异化

如果新 Agent 的工作模式和现有 3 个**根本不同**（例如：纯推理型 vs 纯执行型 vs 数据科学型），可以拆。

### 信号 3：团队规模扩大

当你从单人 FSE 变成带团队（5+ 人），需要：
- **PM Agent**：跨人协调
- **Reviewer Agent**：质量把关
- **Specialist**：每个工程师一个 Agent（Tech-PowerStore / Tech-VxRail）

**当前老板是单人 FSE，不需要这些。**

---

## 七、决策框架（给未来的自己）

每次想加 Agent 时，问 4 个问题：

1. **这个任务需要 LLM 推理吗？**
   - 不需要 → 用 skill，0 token
   - 需要 → 进入问题 2

2. **现有 Agent 已经有相关 skill 吗？**
   - 有 → 复用现有 Agent
   - 没有 → 进入问题 3

3. **这个任务频率高吗（每周 ≥3 次）？**
   - 高 → 新建 Agent
   - 低 → 用 delegate_task 临时派发

4. **拆分后 token 节省 > 拆分成本吗？**
   - 是 → 新建
   - 否 → 复用

**只有 4 个都通过，才新增 Agent。**

---

## 八、经验教训（避免再犯）

1. ❌ **「工种 = Agent」是错的对应关系**
   - 工种是社会学的划分，Agent 是工程学的划分
   - 工程师可以既写代码又写文档，Agent 也可以

2. ❌ **「专业 = 独立」是过度设计**
   - 专业可以靠 skill 体现，不一定要独立 profile

3. ❌ **「复杂 = 多 Agent」是过度反应**
   - 复杂任务用 Kanban 流水线即可，不一定要每个子任务一个 Agent

4. ✅ **「3+1」是甜区**
   - 3 个智能 Agent（M3 + M2.7 × 3）+ 1 个 skill 库
   - 覆盖 90% 个人/小团队场景

---

## 九、与其他常见架构对比

| 架构 | Profile 数 | 适用场景 | 评价 |
|------|-----------|---------|------|
| **单 Agent 全栈** | 1 | 个人 toy project | 太简单 |
| **3+1（当前推荐）** | 4 | 单人专家 / 小团队 | ✅ 甜区 |
| **5+2** | 7 | 5+ 人团队 | 中型公司 |
| **10+5** | 15+ | 大公司 / 多项目并行 | 架构复杂，需专人维护 |

**老板当前**：单人 FSE → **3+1 是最优解**。

---

## 十、结论

> **不要被「更多 Agent = 更强」的错觉迷惑。**

正确的设计哲学：

> **让对的 Agent 做需要智能的事，让 Skill 做不需要智能的事。**

3+1 架构在 FSE 老板的场景下：
- **覆盖 95% 工作流**
- **节省 40% token**
- **认知负担最小**（只需记 4 个触发关键词）

**重构执行清单**：
- [ ] 把 Designer 拆成 skill（pdf-layout/ppt-design/chart-viz）
- [ ] Tech Agent 加 skill: code-script（写脚本能力）
- [ ] Tech Agent 加 skill: dell-sop（搬迁/升级 SOP）
- [ ] Content Agent 加 skill: sr-report（SR 专门模板）
- [ ] Content Agent 加 skill: email（英文邮件模板）
- [ ] Content Agent 加 skill: ppt-outline（PPT 大纲模板）
- [ ] 删除/归档当前「Orchestrator 写脚本」职责
- [ ] 更新 USAGE.md 和 COMPANY_ARCHITECTURE.md 反映 3+1 架构

---

*最后更新：2026-08-07*
*🦞 云间*

> **AI Agent 架构的本质是「减法」，不是「加法」。**