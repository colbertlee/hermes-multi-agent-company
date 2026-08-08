---
name: email
description: Content Agent 的 email skill - 专业英文邮件写作，含 Dell 行业术语和客户沟通模板。
trigger: 写邮件、英文邮件、English、客户邮件、SR 邮件
model: MiniMax-M2.7
---

# email skill（Content Agent 子能力）

## 职责

老板需要写**专业英文邮件**给：
1. Dell 客户（升级协调、故障沟通）
2. Dell 内部团队（跨区域协调、SR 升级）
3. 第三方厂商（备份软件、网络设备）

## 触发条件

老板说：
- 「写英文邮件给客户，主题是 PowerStore 升级窗口」
- 「给 Dell 美国 team 写 SR 升级邮件」
- 「帮我回这封客户邮件」

## 行为规范

### 邮件结构

```
Subject: <简洁明确，不超过 70 字符>

Hi <Name>,

<第一段：一句话点明目的>
- 推荐 1-2 句话
- 包含「为什么写这封邮件」

<第二段：背景/上下文>
- 必要的细节
- 引用 SR 编号、设备型号等

<第三段：具体请求/行动>
- 明确需要的行动
- 期望时间

<第四段：下一步>
- 我会做什么
- 期望对方做什么

Best regards,
<你的英文名>
Dell Technologies
```

### 风格要求

- ✅ **简洁**：3-5 段，每段不超过 5 行
- ✅ **专业**：用 Dell 行业术语
- ✅ **明确 action item**：每封邮件要有「具体做什么」
- ✅ **时间敏感**：明确时间（避免「尽快」「ASAP」）
- ❌ **避免**：「I hope this email finds you well」开场（除非是纯问候）
- ❌ **避免**：长篇大论（>200 字）

### 模板

#### 模板 A：升级窗口协调

```
Subject: PowerStore Upgrade Window Confirmation — <Customer Name>

Hi <Customer IT Lead>,

Following our call on <date>, I'm proposing the firmware upgrade window for the PowerStore cluster.

Proposed window: <Date>, <Time> - <Time> (UTC+8)
Estimated downtime: 30 minutes
Impact: Brief I/O pause during rolling upgrade, no service interruption

Could you confirm by <date> if this works? If adjustments are needed, please let me know and we'll find an alternative.

I'll send the pre-upgrade checklist 48 hours before the window.

Best regards,
<Name>
Dell Technologies
```

#### 模板 B：SR 升级到 Dell 美国

```
Subject: SR <Number> Escalation — <Device> Performance Regression

Hi <Dell's US Team>,

Escalating SR <Number> regarding <device model> firmware upgrade performance regression.

Issue summary:
- Customer: <Industry> customer, production environment
- Device: <Model>, firmware upgraded <date>
- Symptom: <X>% performance drop in <metric>
- Root cause hypothesis: <brief>

Customer impact: <brief description>

Request:
1. Engineering review of firmware bundle <version>
2. Confirmation of compatibility with <previous version>
3. Recommended rollback version if needed

Attached: iDRAC version report, fio baseline, customer logs.

Please respond by <date> UTC.

Best regards,
<Name>
Dell Technologies | Field Service
```

#### 模板 C：客户故障响应（中文/英文双语）

```
Subject: Incident Update — <Issue Type> Investigation Progress

Hi <Customer>,

Quick update on the <issue> we're investigating:

Current status:
- [X] Identified: <what we found>
- [X] In progress: <what we're doing>
- [ ] Pending: <what's next>

No data loss risk at this point. Estimated resolution: <time>.

I'll update you in <interval>.

Best regards,
<Name>
```

## 防幻觉规则

- 禁止编造客户名称、人名、SR 编号
- 禁止编造时间、日期
- 禁止编造具体技术参数
- unknown 字段标注 `[TBD by <sender>]`

## 输出位置

- 邮件草稿：直接 print 给老板复制
- 模板库：`~/.hermes/content/templates/email/`

## Token 消耗

- 单封邮件：~3K token
- 比独立 Email Agent 节省 ~40%