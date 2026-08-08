# Hermes Multi-Agent Company · 3+1 Architecture

> A 3-Agent + 1-Skill-kit architecture for personal AI agent systems.
> Designed for solo experts / small teams who want AI collaboration without enterprise overhead.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version: v1.1.0](https://img.shields.io/badge/version-v1.1.0-blue.svg)](architecture/decisions/0001-3plus1-architecture.md)
[![Hermes: 0.20+](https://img.shields.io/badge/hermes-0.20+-green.svg)](https://hermes-agent.nousresearch.com)

## What's Inside

A production-tested multi-agent architecture for [Hermes Agent](https://hermes-agent.nousresearch.com):

```
                    User
                      │
                      ▼
              ┌──────────────┐
              │ Orchestrator │  ← MiniMax-M3 (cheap, fast routing)
              │              │
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
              │  Designer    │  ← Pure skill (0 token, no LLM)
              │  Skill Kit   │     PDF / PPT / Charts
              └──────────────┘
```

**Token savings**: 40-90% vs single-agent pipelines.

## Quick Start

```bash
# 1. Clone
git clone https://github.com/YOUR_USER/hermes-multi-agent-company.git
cd hermes-multi-agent-company

# 2. Install Hermes
pip install hermes-agent  # or install via your platform

# 3. Install designer dependencies
./install/setup.sh

# 4. Copy profile templates to your Hermes home
cp profiles/*.yaml ~/.hermes/profiles/

# 5. Install skills
./install/install-skills.sh
```

## What's Included

### 🏗️ Architecture (architecture/)

- [COMPANY_ARCHITECTURE.md](architecture/COMPANY_ARCHITECTURE.md) — Full v1.1 spec
- [ARCHITECTURE_REVIEW.md](architecture/ARCHITECTURE_REVIEW.md) — Expert review of 6+1 vs 3+1
- [A2A_COST_PROTOCOL.md](architecture/A2A_COST_PROTOCOL.md) — 6 cost-saving rules
- [decisions/0001-3plus1-architecture.md](architecture/decisions/0001-3plus1-architecture.md) — Why 3+1?

### 🤖 Profiles (profiles/)

Four Hermes profile templates (M3 + 3 × M2.7):
- `default.yaml` — Orchestrator
- `tech.yaml` — Technical work
- `content.yaml` — Content creation
- `research.yaml` — Research & analysis

### 🛠️ Skills (skills/)

11 skills organized by agent:
- Orchestrator: routing, kanban templates
- Tech: diagnosis, SOP, code scripts
- Content: SR reports, articles, emails, PPT outlines
- Research: tech research, competitive analysis
- Designer: PDF/PPT/chart skill-kit (no LLM)

### 🐍 Scripts (scripts/)

Three Python tools for designer skill-kit (0 token):
- `md_to_pdf.py` — Markdown → PDF
- `outline_to_pptx.py` — PPT outline → .pptx
- `data_to_chart.py` — CSV → chart PNG

### 📚 Docs (docs/)

- [USAGE.md](docs/USAGE.md) — How to use
- [FIELD_SERVICE_GUIDE.md](docs/FIELD_SERVICE_GUIDE.md) — Domain-specific guide
- [EXAMPLES.md](docs/EXAMPLES.md) — Real examples

## Why 3+1?

| Approach | Profiles | Token Cost | Cognitive Load |
|----------|----------|------------|----------------|
| Single agent | 1 | High | Low |
| **3+1 (this)** | **3 + skills** | **Low** | **Low** |
| 6+1 (over-engineered) | 7+ | Medium | High |
| 10+5 (enterprise) | 15+ | Low | Very high |

**Insight**: AI agents should make *decisions*; skills should do *format conversion*.
Putting format conversion in an LLM agent wastes 5-10K tokens per task.

See [ARCHITECTURE_REVIEW.md](architecture/ARCHITECTURE_REVIEW.md) for the full analysis.

## Cost Comparison

| Task | Single Agent | 3+1 Architecture | Savings |
|------|--------------|------------------|---------|
| Simple Q&A | 5K | 0.5K | -90% |
| Tech diagnosis | 15K | 5K | -67% |
| PDF generation | 15K | 5K (Content) + 0 (Designer) | -67% |
| Complex pipeline | 50K | 12K | -76% |

## Contributing

PRs welcome. Please:

1. Add an ADR (architecture/decisions/NNNN-title.md) for any structural change
2. Update affected SKILL.md files
3. Test with `bash install/validate.sh`
4. Use conventional commits (`feat:`, `fix:`, `docs:`, `arch:`)

## License

MIT — see [LICENSE](LICENSE).

## Acknowledgments

Built on top of [Hermes Agent](https://hermes-agent.nousresearch.com) by Nous Research.

---

🦞 Hermes Multi-Agent Company v1.1.0