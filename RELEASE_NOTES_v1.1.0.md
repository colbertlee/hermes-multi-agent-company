# v1.1.0 — 3+1 Multi-Agent Architecture

**Release Date**: 2026-08-07
**Status**: Stable
**Tag**: `v1.1.0`

## 🎉 Headline

Production-tested **3+1 multi-agent architecture** for [Hermes Agent](https://hermes-agent.nousresearch.com) — 40-90% token savings vs single-agent pipelines.

```
                    User
                      │
                      ▼
              ┌──────────────┐
              │ Orchestrator │  ← MiniMax-M3 (cheap, fast routing)
              │   (云间)     │
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

## ✨ What's New

### Architecture (3+1 design)

- **3 intelligent agents** (M2.7 each): Tech, Content, Research
- **1 skill-kit** (no LLM, 0 tokens): Designer (PDF/PPT/Chart)
- **1 orchestrator** (M3, default): Routes + summarizes
- **Documented expert review** comparing 6+1 vs 3+1 — see `ARCHITECTURE_REVIEW.md`

### Cost Optimization (6 hard rules)

- `A2A_COST_PROTOCOL.md` — 6 token-saving rules
- Specialists do not call each other (avoid token pass-through)
- Failed tasks block instead of retry (no token waste)
- One structured completion per task
- No LLM for deterministic operations (data stats, format conversion)

### Designer Skill Kit (NEW · 0 token)

Pure Python tools for format conversion:

- `md_to_pdf.py` — Markdown → PDF (via reportlab)
- `outline_to_pptx.py` — PPT outline → .pptx (via python-pptx)
- `data_to_chart.py` — CSV → chart PNG (via matplotlib)
- Bash wrapper with shorthand flags (`-i`, `-o`, `-t`, `-x`, `-y`)

### Skills (10 sub-skills)

| Agent | Skill | Purpose |
|-------|-------|---------|
| Orchestrator | `multi-agent-routing` | Default routing reminder |
| Orchestrator | `kanban-task-templates` | Quick task creation templates |
| Tech | `code-script` | Python/Shell scripts |
| Tech | `dell-sop` | Relocation/upgrade SOPs |
| Content | `sr-report` | Service reports |
| Content | `email` | English customer emails |
| Content | `ppt-outline` | PPT outline design |

### Documentation

- `architecture/COMPANY_ARCHITECTURE.md` — Full v1.1 spec
- `architecture/ARCHITECTURE_REVIEW.md` — Why 3+1 (not 6+1)
- `architecture/A2A_COST_PROTOCOL.md` — Cost optimization rules
- `architecture/decisions/0001-3plus1-architecture.md` — ADR
- `docs/USAGE.md` — How to use
- `docs/FIELD_SERVICE_GUIDE.md` — Field Engineer guide
- `CHANGELOG.md` — Version history

## 📊 Performance

| Task | Single Agent | 3+1 Architecture | Savings |
|------|--------------|------------------|---------|
| Simple Q&A | 5K tokens | 0.5K | -90% |
| Tech diagnosis | 15K | 5K | -67% |
| PDF generation | 15K | 5K (Content) + 0 (Designer) | -67% |
| Complex pipeline | 50K | 12K | -76% |

## 📦 Install

```bash
# 1. Clone
git clone https://github.com/YOUR_USER/hermes-multi-agent-company.git
cd hermes-multi-agent-company

# 2. Install Designer deps
bash install/setup.sh

# 3. Install skills
bash install/install-skills.sh

# 4. Verify
bash install/validate.sh
```

## 🔒 Security & Sanitization

This release is **fully sanitized**:
- ✅ No real customer information
- ✅ No API keys (placeholders only)
- ✅ No hostnames or usernames
- ✅ No production SKUs
- ✅ Run `bash install/sanitize-check.sh` to verify

## 🛠️ Known Limitations

- Designer skill-kit requires Python 3.11+ (Hermes venv recommended)
- Skills target Hermes Agent v0.20+
- Tested on Linux/WSL; macOS/Windows should work but not exhaustively tested

## 📝 What's Next

See [GitHub Issues](https://github.com/YOUR_USER/hermes-multi-agent-company/issues) for the roadmap.

Planned for v1.2.0:
- Auto-archive cron integration
- Web dashboard for visualizing task flow
- Multi-profile load balancing

## 🙏 Acknowledgments

Built on [Hermes Agent](https://hermes-agent.nousresearch.com) by Nous Research.

---

🦞 Hermes Multi-Agent Company v1.1.0