# Examples · 示例输出

> 已脱敏的样例，演示 3+1 架构产出。
> 所有客户/型号信息都是模拟，不指向真实环境。

## 目录

| 示例 | 类型 | 来源 | 大小 |
|------|------|------|------|
| [sample-sr-report.md](sample-sr-report.md) | SR 报告模板 | Content Agent | ~6KB |
| [sample-ppt-outline.md](sample-ppt-outline.md) | PPT 大纲模板 | Content Agent | ~2KB |
| [sample-chart-data.csv](sample-chart-data.csv) | 性能数据样本 | Designer Skill | <1KB |
| [sample-research-report.md](sample-research-report.md) | 调研报告模板 | Research Agent | ~4KB |

## 如何使用示例

```bash
# 1. 测试 Designer Skill
bash install/setup.sh

# 2. 用 sample 转 PDF
designer pdf -i examples/sample-sr-report.md -o /tmp/test-output.pdf

# 3. 用 sample 转 PPT
designer ppt -i examples/sample-ppt-outline.md -o /tmp/test-output.pptx

# 4. 用 sample 数据生成图表
designer chart -i examples/sample-chart-data.csv -o /tmp/test-chart.png -t line -x time -y iops
```

## 重新生成示例

```bash
# 在你自己的环境重新跑示例输出
bash examples/regenerate.sh
```

---

*所有示例均可用于演示，不含敏感信息*