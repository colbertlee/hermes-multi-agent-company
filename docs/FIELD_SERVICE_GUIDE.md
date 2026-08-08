# Hermes多 Agent 公司 · Field Service 工程师实战手册

> 企业一线 Field Engineer 通用模板 — 你在现场的所有场景，Hermes 都能帮忙。
> **本指南可定制**：把 `<DEVICE>` 替换成你的设备系列（如 VxRail/PowerStore），把 `<INDUSTRY>` 替换成你的客户行业。

---

## 一、日常场景速查（3+1 架构版）

| 场景 | 怎么调 | 谁做 | Token |
|------|--------|------|-------|
| **客户现场报修，紧急诊断** | 「VxRail 报错 XXXX」 | **Tech Agent** | ~5K |
| **写 SR 服务报告** | 「写 SR：案例是 XXX」 | **Content Agent**（sr-report skill）| ~8K |
| **写技术报告 PDF** | 「把这个案例转 PDF」 | **Designer Skill** | **0** |
| **做技术 PPT 给客户** | 「做 30 页 PPT 给客户讲」 | **Content Agent** + **Designer Skill** | 5K+0 |
| **数据统计（IOPS/容量/工时）**| 「统计这周的工作量」 | **Orchestrator**（脚本 0 token）| **0** |
| **处理文件（datasheet/log）** | 「解析这个 Excel」 | **Orchestrator** + xlsx skill | 0-3K |
| **写脚本（Python/Shell）** | 「写个脚本采集 vSAN 延迟」 | **Tech Agent**（code-script skill）| ~3K |
| **搬迁前清单** | 「列搬迁检查清单」 | **Tech Agent**（dell-sop skill）| ~5K |
| **竞品对比（销售支持）** | 「对比 PowerStore 和 NetApp」 | **Research Agent** | ~5K |
| **客户邮件/沟通草稿** | 「写英文客户邮件」 | **Content Agent**（email skill）| ~3K |
| **工时填写/Excel 报表** | 「统计工时填表」 | **Orchestrator** + xlsx | **0** |

---

## 二、按场景详细说明

### 场景 1：客户现场紧急诊断（最常用）

**你说什么**：
```
客户 VxRail E560F，节点 2 报 "vSAN 磁盘组降级"，集群还在跑，怎么处理？
```

**Hermes自动做的**：
1. 识别触发词（VxRail/vSAN）→ 派 **Tech Agent**
2. Tech Agent 输出：
   - 紧急诊断步骤（按顺序）
   - 关键命令（可直接 SSH 跑）
   - 风险评估 + 回滚方案
   - 待确认字段（如客户具体型号、版本）
3. 你在客户现场照着命令跑，5 分钟内出结论

**典型耗时**：1-3 分钟

**Token 消耗**：~5K（Tech M2.7），比单 Agent 全流程省 50%

---

### 场景 2：写 SR 服务报告

**你说什么**：
```
帮我写 SR 报告：
- 客户：金融行业
- 设备：<storage-device>
- 故障：SSD 缓存降级
- 原因：固件 bug
- 解决：升级到 3.5.0.1
- 预防：纳入变更管理
```

**Hermes自动做的**：
1. 派 **Content Agent**（`content-article` 模板）
2. Content Agent 输出：
   - 完整 SR 报告（含背景/经过/根因/解决/预防）
   - 保存到 `~/.hermes/content/drafts/YYYYMMDD-sr-powerstore.md`
   - 文件头 metadata（客户行业/设备/状态）
   - 严格脱敏（金融行业，不写客户名）
3. 你可以直接发给 Dell，也可以转 PDF 发客户

**典型耗时**：3-5 分钟

**附加选项**：
- 「转 PDF」→ Content Agent + pdf skill → `YYYYMMDD-sr-powerstore.pdf`
- 「做 PPT 给客户讲」→ Content Agent + powerpoint skill → `.pptx`
- 「英文版」→ 同样流程，输出英文

---

### 场景 3：技术报告 PDF

**触发**：「把这个报告转 PDF」「生成 PDF 技术报告」

**Hermes流程**：
```
Content Agent 写 markdown → 调 pdf skill → 输出 .pdf
```

**调用方式**：
```
你：「把刚才那个 PowerStore 案例转 PDF，给客户看的」
Hermes：Content Agent 调用 pdf skill → 5 分钟内出 PDF
```

---

### 场景 4：技术 PPT（客户培训/方案讲解）

**触发**：「做 PPT」「slides」「演示文稿」

**Hermes流程**：
```
Content Agent 写大纲 → 调 powerpoint skill → 输出 .pptx
```

**典型用途**：
- 客户技术培训（PowerStore 缓存机制）
- 方案讲解（VxRail 部署架构）
- 故障复盘会

**调用**：
```
你：「做 20 页 PPT 给客户讲 PowerStore 缓存机制」
Hermes：Content Agent + powerpoint skill → .pptx
```

---

### 场景 5：数据统计（工时/容量/巡检）

**触发**：纯脚本类，**0 token**

**调用方式**：
```
你：「统计这周工时」「统计客户 A 的容量趋势」
Hermes：Orchestrator 直接跑 Python/SQL → 输出表格
```

**典型场景**：
- 周/月工时统计 → 输出 Excel
- 客户环境容量趋势 → 折线图
- 巡检报告批量生成 → 自动邮件

**支持的 skill**：
- `xlsx`：Excel 读写
- `ocr-and-documents`：PDF/扫描件提取
- `nano-pdf`：PDF 简单编辑
- `pandas` / Python 标准库

---

### 场景 6：文件处理（datasheet、log、config）

**触发**：「解析这个」「提取这个表」

**调用**：
```
你：「解析这个 datasheet 提取 <storage-device> 的 IOPS 规格」
Hermes：Orchestrator + filesystem/excel skill → 输出结构化数据
```

**典型场景**：
- 解析 Dell datasheet
- 提取客户 config dump
- 解析 log 文件（grep + awk）
- PDF 数据提取

---

### 场景 7：搬迁（现场项目）

**触发**：「搬迁清单」「搬迁 checklist」

**Hermes流程**：
```
Tech Agent 生成标准搬迁 SOP + Content Agent 输出可填写模板
```

**输出**：
- 搬迁前检查清单（30+ 项）
- 搬迁中步骤（按顺序）
- 搬迁后验证（性能基线对比）
- 风险点和回滚方案

**调用**：
```
你：「生成 VxRail E560F 搬迁 checklist」
Hermes：Tech Agent 给出标准 SOP → Content Agent 输出 markdown 模板
```

---

### 场景 8：英文客户邮件

**触发**：「写英文邮件」「English email」

**Hermes流程**：
```
Content Agent 写专业英文（含 Dell 行业术语）
```

**典型场景**：
- 客户邮件沟通
- Dell SR 内部邮件
- 跨时区会议安排

**调用**：
```
你：「帮写英文邮件给客户，主题是 PowerStore 升级窗口协调」
Hermes：Content Agent → 3 分钟后专业英文版
```

---

## 三、Field Service 专属工作流

### 工作流 1：现场故障闭环

```
1. 客户报修
   ↓
2. 你：「诊断 VxRail XXXX 报错」
   Tech Agent 输出诊断步骤（1-3 min）
   ↓
3. 你照命令跑，记录结果
   ↓
4. 你：「写 SR 报告：<案例信息>」
   Content Agent 输出完整 SR
   ↓
5. 你：「转 PDF」
   pdf skill 输出 .pdf
   ↓
6. 邮件发给 Dell + 客户（自动草稿）
```

### 工作流 2：客户技术分享

```
1. 你：「调研 XXX 在金融行业的应用」
   Research Agent 输出行业洞察
   ↓
2. 你：「做 30 页 PPT 给客户讲」
   Content Agent + powerpoint skill 输出 .pptx
   ↓
3. 你：「准备 1 页摘要」
   Content Agent 输出 executive summary
```

### 工作流 3：内部技术沉淀

```
1. 你：「这个月遇到了 3 个典型案例，写成技术文章」
   Content Agent 输出 InfoQ/掘金版
   ↓
2. 你：「脱敏后存到知识库」
   Orchestrator + 文件处理
   ↓
3. 你：「下个月用这个做内部培训」
   Content Agent 转 PPT
```

### 工作流 4：每周/月工作汇报

```
1. 你：「统计这周我处理的工单数、平均响应时间、客户满意度」
   Orchestrator（脚本）→ 表格
   ↓
2. 你：「生成可视化图表」
   xlsx skill → Excel + 图表
   ↓
3. 你：「写周报总结」
   Content Agent → markdown 周报
```

---

## 四、外企员工特别加分项

### 4.1 跨文化沟通

**触发**：「写英文」「English」「印度同事」「老外客户」

**Hermes能力**：
- 英文邮件草稿
- 跨时区会议安排建议
- 文化敏感度提醒（如印度同事节假日、欧美客户偏好）

### 4.2 多语言支持

**触发**：「日语」「韩语」「中文简繁」

**Hermes**：自动切换输出语言

### 4.3 工时管理（外企硬要求）

**触发**：「填工时」「这周干了啥」「worklog」

**Hermes流程**：
```
Orchestrator 调用 Salesforce API / 内部工时系统
or 读取你的 notes → 自动填表
```

### 4.4 客户关系管理（CRM）

**触发**：「客户 A 最近的工单」「客户 B 的部署情况」

**Hermes**：
- 读取内部 CRM（如果有权限）
- 或基于你提供的 notes 整理
- 输出客户画像 + 历史交互

### 4.5 销售支持（Field Service 常做）

**触发**：「客户想加扩容」「客户考虑竞品」

**Hermes**：
- Research Agent 调研竞品方案
- Tech Agent 设计扩容方案
- Content Agent 写客户提案 PPT
- 全流程 5-15 分钟

---

## 五、Token 经济性总结

| 任务 | 方案 | Token |
|------|------|-------|
| 客户现场诊断 | Tech Agent | ~5K |
| SR 报告 | Content Agent | ~8K |
| PDF/PPT 生成 | Content Agent + skill | ~10K |
| 数据统计 | 脚本（no_agent）| **0** |
| 文件解析 | Orchestrator + skill | ~2K |
| 英文邮件 | Content Agent | ~3K |
| 跨 Agent 流水线 | Kanban | ~15K |

**核心原则**：能用脚本的不用 LLM，能用 LLM 的用最便宜的。

---

## 六、典型一天的 AI 协作

```
08:00  客户 A 报修 VxRail
       → Tech Agent 5 分钟诊断
       
10:00  客户 B 协调升级窗口
       → Content Agent 写英文邮件
       
12:00  工时统计
       → Orchestrator 脚本（0 token）

14:00  客户 C 案例写成技术文章
       → Content Agent 输出 InfoQ 版

16:00  销售支持：客户 D 调研 Nutanix
       → Research Agent + Tech Agent

17:00  周报
       → Content Agent 自动生成
       
18:00  下周准备：3 个搬迁清单
       → Tech Agent × 3 并行
```

---

## 七、必备引用

| 内容 | 路径 |
|------|------|
| user使用指南 | `~/.hermes/agents/USAGE.md` |
| 架构总纲 | `~/.hermes/agents/COMPANY_ARCHITECTURE.md` |
| A2A 协议 | `~/.hermes/agents/A2A_COST_PROTOCOL.md` |
| Tech Agent 协议 | `~/.hermes/agents/tech/SKILL.md` |
| Content Agent 协议 | `~/.hermes/agents/content/SKILL.md` |
| Research Agent 协议 | `~/.hermes/agents/research/SKILL.md` |
| Kanban 模板 | `~/.hermes/skills/kanban-task-templates/SKILL.md` |
| PDF 生成 | skill: `pdf` |
| PPT 生成 | skill: `powerpoint` |
| Excel 处理 | skill: `xlsx` |
| OCR/文档 | skill: `ocr-and-documents` |
| 默认提醒 | skill: `multi-agent-routing` |

---

*最后更新：2026-08-07 · Field Service 实战版*
*🦞 Hermes*

> **user，你是 Dell 一线 FSE，你最懂客户需要什么。Hermes是放大器 — 让你的专业能力乘以 AI 的效率。**