---
name: ppt-outline
description: Content Agent 的 ppt-outline skill - PPT 大纲设计 + 章节内容，PPT 视觉由 Designer skill 负责。
trigger: PPT、slides、演示文稿、讲解、presentation
model: MiniMax-M2.7
---

# ppt-outline skill（Content Agent 子能力）

## 职责

PPT 创作分两阶段：

| 阶段 | 谁做 | 内容 |
|------|------|------|
| 1. 大纲设计 | **Content Agent（本 skill）** | 章节结构、每页要点、文字内容 |
| 2. 视觉生成 | **Designer skill** | 排版、配色、图表、最终 .pptx |

**Content Agent 只做「内容」，不做「设计」**。

## 触发条件

老板说：
- 「做 30 页 PPT 讲 PowerStore 缓存机制」
- 「做个客户培训 PPT」
- 「输出 PPT 大纲」

## PPT 大纲模板

```markdown
---
title: <PPT 标题>
audience: <客户 IT/内部培训/销售>
slides: <目标页数>
duration: <预计讲解时长>
created: YYYY-MM-DD
---

# PPT 大纲：<标题>

## 1. Cover（封面）
- 主标题
- 副标题
- 日期 / 作者

## 2. Agenda（目录）
- 5-7 个章节标题

## 3. Background（背景）
- 客户痛点 / 业务背景
- 1-2 页

## 4. Problem（问题）
- 当前挑战
- 数据 / 图表

## 5. Solution Overview（方案概览）
- 架构图
- 关键特性

## 6. Deep Dive 1（深入点 1）
- 多个子页
- 配图 / 命令

## 7. Deep Dive 2（深入点 2）
...

## 8. Implementation（实施）
- 步骤
- 时间线

## 9. Best Practices（最佳实践）
- 经验总结
- 注意事项

## 10. Q&A

## 11. Appendix（附录）
- 命令速查
- 参考文档
- 联系方式

---

## 每页详细要点

### Slide 1: Cover
- Title: <主标题>
- Subtitle: <副标题>
- Date: <日期>
- Author: <作者>

### Slide 2: Agenda
1. <章节 1>
2. <章节 2>
3. ...
```

## 典型场景

### 场景 1：客户技术培训

```
「做 30 页 PPT 给客户讲 PowerStore 缓存机制」
→ Content Agent 输出 ppt-outline
→ Designer skill 转 .pptx
→ 输出：~/.hermes/content/drafts/YYYYMMDD-powerstore-cache-ppt.md（大纲）
       ~/.hermes/content/drafts/YYYYMMDD-powerstore-cache-ppt.pptx（成品）
```

### 场景 2：故障复盘会

```
「把昨天 VxRail 故障做成 10 页 PPT」
→ Content Agent 输出 ppt-outline（故障时间线 + 根因 + 改进）
→ Designer skill 转 .pptx
```

### 场景 3：销售支持

```
「做个 20 页 PPT 帮销售打单」
→ Content Agent 输出 ppt-outline（客户痛点 + 方案 + ROI）
→ Designer skill 转 .pptx
```

## 与 Designer skill 的接口

Content Agent 输出 markdown 格式大纲（含每页要点），
Designer skill 调用 `powerpoint` skill（python-pptx）
按大纲生成 .pptx。

**两者解耦的好处**：
- Content Agent 不学 PPT 排版（省 token）
- Designer skill 可复用（换大纲不换工具）
- 修改大纲不影响 PPT 视觉

## 输出位置

- PPT 大纲：`~/.hermes/content/drafts/YYYYMMDD-<title>-outline.md`
- 最终 .pptx：同目录 .pptx 文件
- 客户定制版：同上，加客户行业 metadata

## Token 消耗

- PPT 大纲：~5K token
- Designer skill（生成 .pptx）：0 token（python-pptx）
- **总计 5K**，比独立 PPT Agent 节省 ~50%