---
name: dell-sop
description: Tech Agent 的 dell-sop skill - 标准化操作流程：搬迁、升级、扩容、新建集群。生成可执行的 checklist。
trigger: 搬迁、升级、扩容、新建、checklist、SOP、流程
model: MiniMax-M2.7
---

# dell-sop skill（Tech Agent 子能力）

## 职责

Dell 设备的**重复性操作**都需要 SOP：

1. **搬迁**（客户机房搬迁、跨站点迁移）
2. **固件升级**（VxRail/PowerStore/NetWorker）
3. **扩容**（添加节点、扩容存储）
4. **新建集群**（首次部署）
5. **健康巡检**（每月/季度）

## 触发条件

老板说：
- 「生成 VxRail 搬迁 checklist」
- 「PowerStore 升级 SOP」
- 「新建集群步骤」
- 「扩容方案 + 风险点」

## 行为规范

### SOP 模板结构

```markdown
# <操作类型> SOP
**设备**：<VxRail/PowerStore/NetWorker>
**风险等级**：<低/中/高>
**预估耗时**：<X 小时>
**维护窗口**：<必需>

## 前置条件
- [ ] <条件1>
- [ ] <条件2>

## 风险评估
| 风险点 | 概率 | 影响 | 缓解措施 |
|--------|------|------|---------|
| ... | ... | ... | ... |

## 详细步骤（按顺序）

### Phase 1：准备（升级前 24h）
1. ...
2. ...

### Phase 2：执行（维护窗口）
1. ...
2. ...

### Phase 3：验证（升级后 1h）
1. ...
2. ...

## 回滚方案
- ...

## 沟通模板
- 客户通知模板
- Dell SR 升级邮件
```

### 常见 SOP 模板（Tech Agent 可复用）

**VxRail E 系列固件升级 SOP**：
- vLCM Compliance 报告预演
- 升级前 fio 基线采集
- 升级中节点分批（先非生产节点）
- 升级后性能回归对比
- 失败回滚到上一稳定版本

**<storage-device>-9000 升级 SOP**：
- Pre-upgrade health check
- N-1 版本兼容矩阵确认
- 滚动升级 vs 集群升级选择
- 升级后 SmartFlash Cache 验证
- 失败处理

**VxRail 搬迁 SOP**：
- 搬迁前清单（30+ 项）
- 网络/电源/机柜预检
- 数据备份策略
- 运输要求（抗震/温湿度）
- 新机房环境验收
- 搬迁后性能验证

## 输出位置

- SOP 文档：`~/.hermes/agents/tech/sops/<device>-<operation>-sop.md`
- 客户定制版：`~/.hermes/content/drafts/YYYYMMDD-<customer>-<operation>.md`

## Token 节省

dell-sop 在 Tech Agent 内完成，**不需要 PM Agent**：
- 单 Agent：~5K token
- PM Agent 独立：~5K + Kanban 协调开销

**节省 ~30%**，且 SOP 本身是「标准模板+定制」两段式，不需要复杂的项目管理逻辑。

## 风险提示

- SOP 不是「万能模板」，客户环境千差万别
- 必须在 SOP 中明确标注「需根据 <unknown> 调整」
- 重大操作建议 Tech Agent + Content Agent 协作（生成 SOP + 客户通知）