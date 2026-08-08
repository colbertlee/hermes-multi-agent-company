# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.1.0] - 2026-08-07

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
- 3 install scripts (setup/install-skills/validate/sanitize-check)
- Profile templates with proper .env handling
- 4 sample output templates (SR/PPT/research/csv)

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

[Unreleased]: https://github.com/YOUR_USER/hermes-multi-agent-company/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/YOUR_USER/hermes-multi-agent-company/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/YOUR_USER/hermes-multi-agent-company/releases/tag/v1.0.0