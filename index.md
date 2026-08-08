---
layout: default
title: Home
nav_order: 0
---

# Hermes Multi-Agent Company

> A 3-Agent + 1-Skill-kit architecture for personal AI agent systems.

## 🎯 What is this?

A production-tested multi-agent architecture for [Hermes Agent](https://hermes-agent.nousresearch.com):

```
                    User
                      │
                      ▼
              ┌──────────────┐
              │ Orchestrator │  ← MiniMax-M3 (cheap, fast routing)
              └──────┬───────┘
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
   ┌────────┐  ┌─────────┐  ┌──────────┐
   │  Tech  │  │ Content │  │ Research │
   │ (M2.7) │  │  (M2.7) │  │  (M2.7)  │
   └────────┘  └─────────┘  └──────────┘
        │            │            │
        └────────────┴────────────┘
                     │
                     ▼
              ┌──────────────┐
              │  Designer    │  ← Pure skill kit (0 token, no LLM)
              │  Skill Kit   │     PDF / PPT / Charts
              └──────────────┘
```

**Token savings**: 40-90% vs single-agent pipelines.

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Architecture](architecture/COMPANY_ARCHITECTURE.md) | Full v1.1 spec |
| [Expert Review](architecture/ARCHITECTURE_REVIEW.md) | Why 3+1 (not 6+1) |
| [Cost Protocol](architecture/A2A_COST_PROTOCOL.md) | 6 token-saving rules |
| [ADR-0001](architecture/decisions/0001-3plus1-architecture.md) | Architecture decision |
| [Usage Guide](docs/USAGE.md) | How to use |
| [Field Service Guide](docs/FIELD_SERVICE_GUIDE.md) | Field Engineer guide |
| [Blog](docs/blog/) | Articles & case studies |

## 🚀 Quick Start

```bash
git clone https://github.com/colbertlee/hermes-multi-agent-company.git
cd hermes-multi-agent-company
bash install/setup.sh           # Install designer deps
bash install/install-skills.sh  # Install skills
bash install/validate.sh        # Verify installation
```

## 🔗 Links

- **GitHub**: https://github.com/colbertlee/hermes-multi-agent-company
- **Release v1.1.0**: https://github.com/colbertlee/hermes-multi-agent-company/releases/tag/v1.1.0
- **Hermes Agent**: https://hermes-agent.nousresearch.com

## 📊 Performance

| Task | Single Agent | 3+1 Architecture | Savings |
|------|--------------|------------------|---------|
| Simple Q&A | 5K tokens | 0.5K | -90% |
| Tech diagnosis | 15K | 5K | -67% |
| PDF generation | 15K | 5K + 0 | -67% |
| Complex pipeline | 50K | 12K | -76% |

---

🦞 Hermes Multi-Agent Company v1.1.0