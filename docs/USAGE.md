# Hermes多 Agent 公司 · 用户使用指南

> user专用 — 1 分钟看懂怎么用这套系统。

---

## 一、什么是多 Agent 公司？

把Hermes升级成了一家「小公司」：

| 角色 | 干什么 | 适合谁调用 |
|------|--------|-----------|
| **Hermes（Orchestrator）** | 路由判断、汇总、简单问题 | 你 |
| **Tech 同事** | Dell 存储/超融合技术问题 | Tech Agent 自动接手 |
| **Content 同事** | 文章创作、文案、案例变现 | Content Agent 自动接手 |
| **Research 同事** | 竞品调研、技术选型分析 | Research Agent 自动接手 |

**好处**：
- user不用记命令，Hermes自动判断分派
- 专业问题交给专业 Agent，结果更靠谱
- Token 成本省 60-90%（便宜模型做路由，专业模型做深度）

---

## 二、3 种调用方式（由易到准）

### 方式 1：自然语言（最快）✅ 推荐

直接说，Hermes会自动判断：

| 触发词示例 | 自动派给 |
|-----------|---------|
| 「Dell 存储有问题」「PowerStore 延迟飙升」 | **Tech Agent** |
| 「写篇文章」「代写案例」「内容」 | **Content Agent** |
| 「调研」「对比」「哪个好」「竞品」 | **Research Agent** |
| 「磁盘多少？」「重启 gateway」「查状态」 | **Orchestrator 直接处理** |

**例子**：
```
你：「客户 VxRail 升级固件后性能降了 30%，怎么处理？」
Hermes：[自动识别 Tech 触发词] → 派给 Tech Agent → 给你一份诊断报告

你：「这个案例不错，帮我写篇 InfoQ 文章」
Hermes：[自动识别 Content 触发词] → 派给 Content Agent → 给你可发布草稿
```

### 方式 2：明确指令（最准）

如果不确定Hermes会路由到哪，可以明确指定：

```
「派给 Tech：PowerStore 延迟飙升怎么查」
「派给 Content：基于 VxRail 案例写文章」
「派给 Research：调研 Nutanix vs VxRail」
```

**优势**：不会路由错，100% 命中你想要的 Agent。

### 方式 3：直接 @（高级）

前缀代号强制派单：

```
「@tech PowerStore 性能问题」
「@content 写篇文章」
「@research 调研一下」
```

> 注：这个能力 v0.20.0 正在支持，目前**方式 1 + 方式 2 已可用**。

---

## 4. 每种任务的预期时长

| 任务类型 | 模型 | 预期耗时 |
|---------|------|---------|
| 简单问答/查状态 | Orchestrator（M3）| 5-10 秒 |
| 故障诊断/架构/SOP/脚本 | Tech Agent（M2.7）| 1-3 分钟 |
| SR/文章/邮件/PPT 大纲 | Content Agent（M2.7）| 2-5 分钟 |
| 调研对比 | Research Agent（M2.7）| 2-5 分钟 |
| PDF/PPT/图表生成 | **Designer Skill（0 token）**| 5-10 秒 |
| 复杂流水线（Kanban）| 多 Agent 协作 | 5-15 分钟 |

## 4.1 3+1 架构（精简版）

user不需要记每个 Agent 怎么用：

| Agent | 管什么 | 触发词 |
|-------|--------|--------|
| **Tech** | Dell 技术 + 写脚本 | Dell/PowerStore/VxRail/故障/写脚本 |
| **Content** | 写作类（SR/文章/邮件/PPT 大纲）| 写报告/写文章/邮件/PPT |
| **Research** | 调研对比 | 调研/对比/哪个好 |
| **Designer Skill** | 格式转换（PDF/PPT/图表）| 转 PDF/做图表 |

**没有独立 Developer/Analyst Agent**，这些都靠现有 Agent 兼顾 + Skill 工具。

---

## 四、任务状态如何查

Hermes会主动汇报。如果你想主动查：

```bash
# 看所有 Kanban 任务
hermes kanban list

# 看某个任务的细节
hermes kanban show <task_id>

# 看 disk 上的所有 output 文件
ls ~/.hermes/content/drafts/    # Content Agent 输出
ls ~/.hermes/research/outputs/  # Research Agent 输出
ls ~/.hermes/kanban/logs/       # 所有任务日志
```

---

## 五、典型场景示例

### 场景 1：生产环境紧急故障

```
你：「Dell PowerStore X 突然 IO 飙高，客户在催」
Hermes：[Tech Agent] 立即分析 → 给出诊断命令
```

### 场景 2：写技术变现

```
你：「今天的案例是 NetWorker 备份失败，写一篇 InfoQ」
Hermes：[Content Agent] 写文章 → 保存到 drafts/ → 给你可发布版本
```

### 场景 3：技术选型决策

```
你：「对比 Nutanix 和 VxRail，我要给客户做方案」
Hermes：[Research Agent] 调研 → 表格对比 → 选型建议
```

### 场景 4：跨多个 Agent 的复杂任务

```
你：「调研 + 写文章」组合 → 给你完整方案
Hermes：[Research 调研] → [Tech 验证] → [Content 写作]
```

---

## 六、Token 节省效果

| 任务 | 之前（全 M2.7/单 Agent）| 现在（M3 路由 + M2.7 Specialist）|
|------|---------------------|------------------------------|
| 简单问答 | 5K | 500（**-90%**）|
| 故障诊断 | 15K | 8K（**-47%**）|
| 文章创作 | 20K | 10K（**-50%**）|
| 多步流水线 | 50K | 15K（**-70%**）|

---

## 七、需要知道的事

1. **结果直接给你**：Specialist 的结果直接通过Hermes回报，不在中间堆积
2. **任务持久化**：复杂任务用 Kanban 跟踪，重启不丢
3. **失败会 block**：Specialist 遇到不确定会 block 问你，不会乱猜
4. **每个 Agent 有专属 SKILL**：在 `~/.hermes/agents/<name>/SKILL.md`

---

## 八、快速 FAQ

**Q：我怎么知道派给谁了？**
A：Hermes会主动告诉你：「已派给 Tech Agent，正在诊断...」

**Q：派错了怎么办？**
A：直接说「这个不是技术问题，让 Research 调研」，Hermes会撤回重派

**Q：能强制用某个 Agent 吗？**
A：可以，用方式 2 或方式 3（@tech / @content / @research）

**Q：怎么让 Specialist 之间协作？**
A：Kanban 流水线，Hermes自动设置依赖关系

**Q：token 真的省吗？**
A：实测省 60-90%，具体看 A2A_COST_PROTOCOL.md

---

## 九、对应文件位置

| 内容 | 路径 |
|------|------|
| 架构总纲 | `~/.hermes/agents/COMPANY_ARCHITECTURE.md` |
| 使用指南（本文件） | `~/.hermes/agents/USAGE.md` |
| A2A 成本协议 | `~/.hermes/agents/A2A_COST_PROTOCOL.md` |
| Orchestrator 协议 | `~/.hermes/agents/orchestrator/SKILL.md` |
| Tech Agent 协议 | `~/.hermes/agents/tech/SKILL.md` |
| Content Agent 协议 | `~/.hermes/agents/content/SKILL.md` |
| Research Agent 协议 | `~/.hermes/agents/research/SKILL.md` |

---

## 十、Dell Field Service 工程师专属指南

作为 Dell 一线 FSE，你最常见的工作：

| 工作 | 怎么调 |
|------|--------|
| 客户现场诊断 | 「VxRail 报错 XXXX」 |
| 写 SR 服务报告 | 「写 SR：案例是 XXX」 |
| 转 PDF 给客户 | 「把这个案例转 PDF」 |
| 做 PPT 客户培训 | 「做 20 页 PPT 讲 PowerStore」 |
| 工时/数据统计 | 「统计这周工时」（0 token）|
| 解析 datasheet | 「解析这个 datasheet」 |
| 搬迁 checklist | 「生成搬迁清单」 |
| 英文客户邮件 | 「写英文邮件给客户」 |
| 销售支持（竞品对比）| 「调研 PowerStore vs NetApp」 |

**详细实战手册**：`~/.hermes/agents/FIELD_SERVICE_GUIDE.md`

---

*最后更新：2026-08-07*
*🦞 Hermes*