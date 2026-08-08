---
name: sr-report
description: Content Agent 的 sr-report skill - Dell 服务请求报告（SR）专业写作，Dell 内部合规格式。
trigger: 写 SR、SR 报告、服务请求、Dell 内部报告
model: MiniMax-M2.7
---

# sr-report skill（Content Agent 子能力）

## 职责

Dell SR（Service Request）是内部标准服务报告文档，需要：

1. **结构标准化**（Dell 内部模板）
2. **技术准确**（错误码、SKU、命令输出必须真实）
3. **客户脱敏**（金融/制造/IDC 行业泛化）
4. **结论明确**（根因 + 解决 + 预防）
5. **可追溯**（时间线、命令记录、附件）

## 触发条件

老板说：
- 「写个 SR：XXX 案例」
- 「把这个故障写成 SR 报告」
- 「生成 SR 报告模板」

## SR 报告模板

```markdown
---
type: dell-sr-report
device: <VxRail/PowerStore/NetWorker>
version: <vSAN/OS/固件版本>
incident_id: <SR 编号或 unknown>
severity: <P1/P2/P3>
status: closed
customer_industry: <金融/制造/IDC>
created: YYYY-MM-DD
engineer: 脱敏
---

# Dell SR Report — <设备型号> <故障简述>

## 1. Incident Summary
- **SR Number**：[unknown] / 已提供
- **Severity**：P1/P2/P3
- **Status**：Closed
- **Resolution Time**：<X 小时>
- **Root Cause**：<一句话>

## 2. Customer Environment
| 项目 | 值 |
|------|-----|
| 客户行业 | 金融行业 |
| 设备型号 | VxRail E-series（具体型号 [待核实]）|
| 配置 | 2 节点 vSAN 集群 |
| 软件版本 | vSAN 6.7 U3 |
| 业务负载 | Oracle RAC |
| 客户影响 | 性能降 30% |

## 3. Timeline
- **WeekDay HH:MM** — Dell 推送固件升级
- **WeekDay HH:MM** — 业务告警触发
- **WeekDay HH:MM** — 客户报修
- **WeekDay HH:MM** — 现场诊断完成
- **WeekDay HH:MM** — 根因定位
- **WeekDay HH:MM** — 固件回滚
- **WeekDay HH:MM** — 性能恢复验证

## 4. Root Cause Analysis
### Direct Cause
<直接原因，含 Dell 错误码>

### Trigger
<触发条件>

### Root Cause
<根本原因>

### Contributing Factors
<其他因素>

## 5. Resolution
### Immediate Action
<紧急处置>

### Permanent Fix
<永久解决方案>

### Verification
<验证方法>

## 6. Preventive Measures
- [ ] 升级前基线采集 SOP
- [ ] 升级后 24h 性能监控
- [ ] ...（预防清单）

## 7. Customer Communication
<客户通知记录>

## 8. Attachments
- fio 测试报告 [文件名]
- 升级前后性能对比图 [文件名]
- iDRAC 固件版本清单 [文件名]

## 9. Lessons Learned
- L1：<团队层面>
- L2：<流程层面>
- L3：<工具层面>

---
*SR 完成 — 由 Content Agent 协助生成*
```

## 防幻觉规则（SR 特别严格）

- ❌ 禁止编造：SR 编号、KB 编号、客户名称、具体人名
- ❌ 禁止编造：具体数字（延迟/IOPS），未知标注 `[unknown]`
- ❌ 禁止编造：Dell 错误码（如确实没有则用「无可识别错误码」）
- ✅ 必须：所有命令输出引用真实日志或标注 `[需补充]`
- ✅ 必须：客户名称泛化为「金融行业」「某 IDC」

## 与 content-article 的区别

| 维度 | SR Report | Article |
|------|-----------|---------|
| 目标读者 | Dell 内部 + 客户 IT | 技术社区（InfoQ/掘金）|
| 风格 | 严谨、专业 | 流畅、有故事性 |
| 合规 | Dell 内部规范 | 平台规范 |
| 信息密度 | 高 | 中 |
| Hook | 不需要 | 必须 |

**Content Agent 根据目标自动切换风格**。

## 输出位置

- SR 报告：`~/.hermes/content/drafts/YYYYMMDD-sr-<device>-<issue>.md`
- 转 PDF：`~/.hermes/content/drafts/YYYYMMDD-sr-<device>-<issue>.pdf`（Designer skill）
- 提交给 Dell：直接上传到 SR 系统

## Token 消耗

- SR 生成：~8K token
- 复用 Content Agent，不需要独立 SR Writer Agent
- **节省 ~50%**