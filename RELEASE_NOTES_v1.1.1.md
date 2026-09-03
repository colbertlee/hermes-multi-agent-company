# v1.1.1 — Script Reliability Fix

**Release Date**: 2026-09-03
**Type**: Patch release
**Tag**: `v1.1.1`

## 🔧 What's Changed

Three script issues fixed to eliminate false-positive leak warnings and improve cross-environment portability.

### Fixed

1. **Designer wrapper — hardcoded path**
   - File: `scripts/designer/designer`
   - Was: `/home/colbert/.hermes/hermes-agent/venv/bin/python`
   - Now: `$HERMES_HOME/hermes-agent/venv/bin/python` (with `$HOME/.hermes` fallback)
   - Impact: `designer` command now works for **any user** on any machine, not just `colbert`'s setup

2. **validate.sh — false positive bug**
   - File: `install/validate.sh`
   - Was: `if grep | head -1; then` — `head -1` always returns exit 0 even when grep finds nothing
   - Now: `[ -n "$HITS" ]` (proper empty-string check)
   - Impact: `validate.sh` no longer reports leaks that don't exist

3. **sanitize-check.sh — overly broad patterns**
   - File: `install/sanitize-check.sh`
   - Was: `secret`, `token` matched descriptive docs ("Hard-coded secrets", "0 tokens")
   - Now: precise patterns requiring assignment syntax (`API_KEY=`, `password=`, `/home/<user>`)
   - Impact: pre-push check no longer false-warns on documentation

## ✅ Verification

| Test | Before | After |
|------|--------|-------|
| `validate.sh` | ❌ 4 false positives | ✅ All checks passed |
| `sanitize-check.sh` | ❌ 9 false positives | ✅ Safe to push |
| `designer pdf` | ✅ | ✅ |
| `designer ppt` | ✅ | ✅ |
| `designer chart` | ✅ | ✅ |
| Wrapper on non-colbert user | ❌ broken | ✅ works |

## 📦 No Architectural Changes

This is a **patch release** (v1.1.0 → v1.1.1) — no new skills, agents, or design changes.

Token economy (40-90% savings), 3+1 architecture, Designer skill-kit, and all skills unchanged.

## 🔗 Links

- **Repo**: https://github.com/colbertlee/hermes-multi-agent-company
- **v1.1.0 release**: https://github.com/colbertlee/hermes-multi-agent-company/releases/tag/v1.1.0
- **Compare**: https://github.com/colbertlee/hermes-multi-agent-company/compare/v1.1.0...v1.1.1
- **Version SOP**: https://github.com/colbertlee/hermes-multi-agent-company/blob/main/docs/VERSION_SOP.md

---

*Released via 7-step VERSION_SOP · 云间 Orchestrator (M3) + Tech Agent (M2.7)*

🦞 Hermes Multi-Agent Company v1.1.1