---
name: kanban-task-templates
description: 4个标准Kanban模板让Orchestrator快速创建tech/content/research任务。
model: MiniMax-M3
---

# Kanban 任务模板 v1.0

## 核心目标

让 Orchestrator（云间/M3）能用**最短 prompt + 最低 token** 创建结构化任务。

每个任务结构：
- **id**：uuid8（自动）
- **assignee**：profile 名
- **title**：「<agent>: <任务简述>」
- **body**：json.dumps({"instructions": "..."})
- **status**："todo"

## 模板分类

| 模板 ID | 适用场景 | 默认 assignee |
|---------|---------|---------------|
| `tech-debug` | 故障诊断、技术问答 | tech |
| `tech-design` | 架构设计、配置方案 | tech |
| `content-article` | Dell 案例→技术文章 | content |
| `content-outline` | 文章大纲、标题优化 | content |
| `research-compare` | 竞品对比、技术选型 | research |
| `research-investigate` | 行业调研、技术趋势 | research |
| `general-simple` | 单步任务，Orchestrator 自己处理 | default |

## 4 个标准模板（精简版）

### 模板 A：tech-debug（故障诊断）

```python
body = json.dumps({
    "instructions": f"""你是 Tech Agent (MiniMax-M2.7)。

任务：{user_query}

输出格式：
1. 事实清单（已验证 / 推测）
2. 详细分析
3. 行动建议（编号，可执行）
4. 待确认字段（unknown 标注）

完成时：print 到 stdout"""
})
title = f"tech-debug: {short_desc}"
```

### 模板 B：content-article（文章创作）

```python
body = json.dumps({
    "instructions": f"""你是 Content Agent (MiniMax-M2.7)。

任务：基于以下 Dell 案例撰写可发布文章。

案例信息：{case_info}

输出：
- 保存到 ~/.hermes/content/drafts/YYYYMMDD-{slug}.md
- 文件头加 metadata（type/platform/equipment/status）
- <3000 字，技术准确，unknown 标注

完成时：print 文件路径和字数"""
})
title = f"content-article: {title_slug}"
```

### 模板 C：research-compare（竞品对比）

```python
body = json.dumps({
    "instructions": f"""你是 Research Agent (MiniMax-M2.7)。

调研主题：{topic}
对比对象：{compare_list}

要求：
1. 每个对象：定位、架构特点、优劣势
2. 客观事实，引用来源
3. 数字/价格 unknown 标注
4. 选型建议表

输出：markdown <1000 字，保存到 ~/.hermes/research/outputs/{slug}-YYYYMMDD.md"""
})
title = f"research-compare: {topic}"
```

### 模板 D：general-simple（Orchestrator 自处理）

```python
body = json.dumps({
    "instructions": f"""Orchestrator (M3) 直接处理：{task_desc}

无需派发 Specialist，直接执行或查询。"""
})
title = f"orchestrator: {task_desc}"
```

## 快速创建函数（Orchestrator 调用）

```python
import sqlite3, json, uuid
from datetime import datetime

def create_kanban_task(title, body_md, assignee="default"):
    db = "$HOME/.hermes/kanban.db"
    conn = sqlite3.connect(db)
    cur = conn.cursor()
    task_id = uuid.uuid4().hex[:8]
    body = json.dumps({"instructions": body_md})
    cur.execute(
        "INSERT INTO tasks (id,title,body,assignee,status,created_at) VALUES (?,?,?,?,?,?)",
        (task_id, title, body, assignee, "todo", datetime.now().isoformat())
    )
    conn.commit()
    return task_id
```

## Kanban 任务 vs delegate_task 选择

| 场景 | 选 Kanban | 选 delegate_task |
|------|-----------|-----------------|
| 需持久化 / 跨 session | Kanban | 否 |
| 多步骤依赖链 | Kanban（用 task_links） | 否 |
| 人类需中途介入 | Kanban（block/comment） | 否 |
| 一次性短任务 | 否 | delegate_task |
| 简单直接回报 | 否 | delegate_task（同步） |

## Token 节省要点

- **Orchestrator 不重复派发**：已 ready 的任务不再创建副本
- **不传递长 context**：body 控制在 <500 字符，让 Specialist 自己查
- **结果不二次加工**：Specialist 直接回报，不经过 Orchestrator 中转
- **失败用 block 替代 retry**：避免重试浪费 token

## 触发示例

老板说：派给 Tech：PowerStore 延迟飙升怎么查

→ Orchestrator 选模板 A（tech-debug）
→ title: "tech-debug: PowerStore 延迟飙升诊断"
→ body: 用模板 A，填入 user_query
→ 创建任务（assignee=tech）
→ 30 秒内 dispatcher 捡起执行

老板说：调研 Nutanix vs VMware

→ Orchestrator 选模板 C（research-compare）
→ title: "research-compare: Nutanix vs VMware HCI 选型"
→ body: 填入 topic + compare_list
→ assignee=research