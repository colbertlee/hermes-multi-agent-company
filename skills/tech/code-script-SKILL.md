---
name: code-script
description: Tech Agent 的 code-script skill - 写 Python/Shell 脚本，处理 Dell 环境自动化、数据采集、日志解析等。
trigger: 写脚本、自动化、Python、Shell、log 解析、采集数据
model: MiniMax-M2.7
---

# code-script skill（Tech Agent 子能力）

## 职责

Tech Agent 在做 Dell 故障诊断、架构方案时，常常需要配套脚本：

1. **自动化巡检脚本**（定时采集 SSD 健康、容量、延迟）
2. **日志解析脚本**（vSAN 日志、PowerStore 事件）
3. **数据采集脚本**（fio 测试、IOPS 采样）
4. **环境检查脚本**（升级前/升级后基线对比）
5. **小工具脚本**（批量改配置、生成报告）

## 触发条件

老板说：
- 「写个脚本采集 vSAN 延迟」
- 「解析这个 log 提取错误」
- 「做一个升级前基线采集脚本」
- 「批量处理这些 config 文件」

## 行为规范

### 脚本设计原则

```python
1. 单一职责：一个脚本做一件事
2. 可复用：参数化、命令行参数支持 argparse
3. 安全：dry-run 模式 + 操作前备份
4. 可观察：进度条 + 日志 + 退出码
5. 可移植：Python 3.11+，避免系统特定路径
```

### 输出格式

```python
#!/usr/bin/env python3
"""<脚本简述>"""
import argparse
import sys
from pathlib import Path

# 常量
DEFAULT_OUTPUT = "/tmp/script_output.json"

def main():
    parser = argparse.ArgumentParser(description="...")
    parser.add_argument("--input", "-i", required=True, help="输入文件")
    parser.add_argument("--output", "-o", default=DEFAULT_OUTPUT, help="输出路径")
    parser.add_argument("--dry-run", action="store_true", help="只看不执行")
    args = parser.parse_args()

    try:
        # 核心逻辑
        result = do_work(args)
        print(f"OK: {result}")
    except Exception as e:
        print(f"FAIL: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
```

### 典型脚本模板

**vSAN 性能采样脚本**：
- 输入：ESXi IP、采样间隔、时长
- 输出：CSV（含时间戳、IOPS、延迟）
- 命令：`python3 vsan_perf_sample.py --host 10.x.x.x --interval 5 --duration 60`

**PowerStore 健康巡检脚本**：
- 输入：PowerStore 管理 IP、凭据文件
- 输出：JSON（含告警、容量、性能）
- 命令：`python3 powerstore_health.py --ip 10.x.x.x --cred /path/to/cred`

**日志错误聚合脚本**：
- 输入：log 文件路径、关键字
- 输出：去重错误列表 + 频次
- 命令：`python3 log_aggregate.py --file /var/log/esxcli.log --grep "ERROR"`

## 与 Tech Agent 主能力的关系

Tech Agent 主能力是「诊断推理」（看到错误码知道怎么办）。
code-script skill 是「把诊断流程自动化」（写脚本让机器跑）。

**两者互补**：
- 诊断 → 人工/AI 走一遍
- 自动化 → 脚本批量跑

## Token 节省

code-script 任务在 Tech Agent（M2.7）内完成，**不需要单独的 Developer Agent**：
- 单 Agent 复用：~3K token
- Developer 独立 Agent：~5K + 协调开销

**节省 ~40%**。

## 输出位置

- 一次性脚本：`~/.hermes/scripts/dell/<script_name>.py`
- 长期脚本：`~/.hermes/scripts/<script_name>.py`（与 cron 集成）
- 测试数据：`/tmp/<script_name>_test.json`