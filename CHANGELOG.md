# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.1.2] - 2026-09-06

### Added
- `docs/FEATURES.md` — User-facing feature documentation (359 lines, 11.8 KB)
  - 10 sections from user perspective: what it does, what it doesn't, token economics
  - 3-minute quickstart + 30-minute full deployment
  - Honest "what it doesn't do" boundaries
  - Real Dell FSE + content content scenarios
- `index.md` updated with FEATURES.md as ⭐ recommended starting point

### Why this release
- v1.1.0/v1.1.1 focused on scripts and architecture — this release adds the missing "what can this do for me?" doc
- Addresses feedback that 3+1 architecture was opaque to new users

## [1.1.1] - 2026-09-03

### Fixed
- `scripts/designer/designer` — hardcoded `/home/colbert/` path replaced with `$HERMES_HOME`/`$HOME` for cross-environment portability
- `install/validate.sh` — fixed false-positive bug in leak check (`if grep | head -1` always returns 0 even when empty)
- `install/sanitize-check.sh` — refined patterns to require assignment syntax, eliminating false positives on documentation text

### Verified
- `validate.sh`: All checks passed ✅
- `sanitize-check.sh`: Safe to push ✅
- Designer scripts (pdf/ppt/chart): 3/3 working ✅

## [1.1.0] - 2026-08-08

### Added (3+1 Architecture)
- ARCHITECTURE_REVIEW.md — Expert review comparing 6+1 vs 3+1 architecture
- A2A_COST_PROTOCOL.md — 6 token-saving hard rules
- ADR-0001 — Decision record for 3+1 architecture choice
- Designer skill-kit (PDF/PPTX/Chart) — Pure tools, no LLM, 0 tokens
- 6 new sub-skills:
  - tech/code-script (Python/Shell scripts)
  - tech/dell-sop (relocation/upgrade SOPs)
  - content/sr-report (Dell SR service reports)
  - content/email (English customer emails)
  - content/ppt-outline (PPT outline design)
- multi-agent-routing skill — Default routing reminder
- kanban-task-templates skill — Quick task creation templates
- 4 install scripts (setup/install-skills/validate/sanitize-check)
- Profile templates with proper .env handling
- 4 sample output templates (SR/PPT/research/csv)
- GitHub Actions CI workflow

### Changed
- COMPANY_ARCHITECTURE.md upgraded to v1.1 with full 3+1 design
- USAGE.md updated to reflect 3+1 architecture
- FIELD_SERVICE_GUIDE.md uses 3+1 model
- 4 Agent/Skill skills → 3 Agent + 10 sub-skills

### Removed
- Separate Developer/Analyst/PM Agent concepts (merged into existing agents)

## [1.0.0] - 2026-08-03

### Added
- Initial 4-agent architecture (Orchestrator + Tech + Content + Research)
- COMPANY_ARCHITECTURE.md v1.0
- 4 core SKILL.md files for each agent
- 4 Hermes profiles (M3 + 3× M2.7)
- Kanban task template skill
- Basic install script

---

## Versioning

- **Major** (X.0.0): Architectural changes (e.g., 3+1 → 4+2)
- **Minor** (1.X.0): New skills, agents, or significant capabilities
- **Patch** (1.1.X): Bug fixes, docs, dependencies

[Unreleased]: https://github.com/YOUR_USER/hermes-multi-agent-company/compare/v1.1.1...HEAD
[1.1.1]: https://github.com/YOUR_USER/hermes-multi-agent-company/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/YOUR_USER/hermes-multi-agent-company/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/YOUR_USER/hermes-multi-agent-company/releases/tag/v1.0.0