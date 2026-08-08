# Hermes Profile Configuration Templates
#
# 这些是 Hermes profile 的 YAML 配置模板。
# 复制到你的 ~/.hermes/profiles/<name>/ 目录下使用。
#
# 重要：API key 必须从 .env 加载，不要 hardcode 在 config.yaml 中。

---

## 1. Orchestrator (default) - M3

**用途**: 路由、汇总、简单问答
**模型**: MiniMax-M3（最便宜最快的模型）
**适用**: 所有从用户来的输入

```yaml
# ~/.hermes/profiles/default/config.yaml
model:
  provider: minimax      # 你的 provider 名
  default: MiniMax-M3    # 路由用 M3，最便宜

# 加载以下 skill（默认安装之外）
skills:
  - multi-agent-routing       # 自动加载，触发词路由
  - kanban-task-templates     # 任务创建模板
  - core-framework            # 云间核心运行框架

# Kanban 配置（dispatcher 在 gateway 内运行）
kanban:
  dispatch_in_gateway: true
  dispatch_interval_seconds: 30
  failure_limit: 2
```

**`.env (default profile)`**:
```bash
# ~/.hermes/profiles/default/.env
# NEVER commit real keys! Use placeholders.
MINIMAX_API_KEY=<your-api-key-here>
MINIMAX_BASE_URL=<your-provider-base-url>
HERMES_HOME=$HOME/.hermes
```

---

## 2. Tech Agent - M2.7

**用途**: Dell 技术诊断、架构、脚本、SOP
**模型**: MiniMax-M2.7（强推理）
**适用**: 触发词 Dell/PowerStore/VxRail/故障/写脚本

**创建命令**:
```bash
hermes profile create tech --clone \
  --description "Dell 技术问题诊断 Specialist"
```

**配置** (`config.yaml`):
```yaml
model:
  provider: minimax
  default: MiniMax-M2.7  # 推理用 M2.7

skills:
  - tech-agent             # 主协议
  - dell-engineer-daily-brief
  - boss-collaboration-mode
```

**`.env (tech profile)****:
```bash
# Tech profile 可以用同一个 API key，也可单独配
MINIMAX_API_KEY=<your-tech-key-here>
MINIMAX_BASE_URL=<your-provider-base-url>
```

**可选 sub-skill**（手动复制）:
- `code-script-SKILL.md` — 写脚本能力
- `dell-sop-SKILL.md` — 搬迁/升级 SOP

---

## 3. Content Agent - M2.7

**用途**: SR、文章、邮件、PPT 大纲
**模型**: MiniMax-M2.7
**适用**: 触发词 写文章/写报告/邮件/PPT

**创建命令**:
```bash
hermes profile create content --clone \
  --description "内容创作 Specialist"
```

**配置** (`config.yaml`):
```yaml
model:
  provider: minimax
  default: MiniMax-M2.7

skills:
  - content-agent
  - content-writer
  - humanizer
```

**`.env (content profile)`**:
```bash
MINIMAX_API_KEY=<your-content-key-here>
MINIMAX_BASE_URL=<your-provider-base-url>
```

---

## 4. Research Agent - M2.7

**用途**: 调研、对比、选型
**模型**: MiniMax-M2.7
**适用**: 触发词 调研/对比/哪个好

**创建命令**:
```bash
hermes profile create research --clone \
  --description "调研/竞品分析 Specialist"
```

**配置** (`config.yaml`):
```yaml
model:
  provider: minimax
  default: MiniMax-M2.7

skills:
  - research-agent
  - grounded-citations
```

---

## 创建脚本 (一次性)

```bash
#!/bin/bash
# install/setup-profiles.sh
set -e

echo "Creating 3 Specialist profiles..."

hermes profile create tech --clone \
  --description "Dell 技术 Specialist"

hermes profile create content --clone \
  --description "内容创作 Specialist"

hermes profile create research --clone \
  --description "调研对比 Specialist"

# Set model per profile
for prof in tech content research; do
  hermes -p $prof config set model.default MiniMax-M2.7
done

echo "✅ Profiles created:"
hermes profile list
```

---

## 配置 Profile 的 5 条原则

1. **每个 profile 独立的 API key**：隔离用量统计
2. **Provider URL 放 .env**：不放 config.yaml（避免泄露）
3. **Description 必填**：Kanban 路由依赖它
4. **Skills 通过 hermes skills install 安装**：不要手动复制
5. **State/cache 自动隔离**：每个 profile 有独立的工作目录

---

## 验证 Profile 工作

```bash
# 看所有 profile
hermes profile list

# 测试某个 profile
hermes -p tech --help

# 跑一个简单任务
echo "测试" | hermes -p tech chat --no-restore-cwd
```

---

*注：本文件为模板，使用时请根据你的实际 provider 和模型替换*