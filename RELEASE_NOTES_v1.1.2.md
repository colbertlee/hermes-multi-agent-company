# Release Notes — v1.1.2

**Release date:** 2026-09-06
**Type:** MINOR (documentation feature)
**Previous:** v1.1.1

## What changed

### 📖 New: User-facing feature documentation

The biggest gap in v1.1.0/v1.1.1 was *what does this thing actually do for me?* — both releases focused on scripts and architecture, not on user outcomes.

v1.1.2 adds **`docs/FEATURES.md`** (359 lines, 11.8 KB) — a complete user-facing feature document.

### FEATURES.md sections

1. **One-line summary** — what 3+1 is in plain English
2. **Six things it can do** — troubleshooting, articles, research, charts, cron, pipelines
3. **What is 3+1** — the four agents (Orchestrator + Specialist × 3) explained as roles
4. **Real deliverables** — what you actually ship, with honest boundaries
5. **Real numbers** — 5/5 WSL2 successes over 5 days (Dell FSE + content)
6. **What it doesn't do** — explicit "no" table (Q: "does it have vector memory?" A: "no")
7. **How to use** — 3-minute quickstart + 30-minute full deployment
8. **Token economics** — single-agent vs 3+1 cost comparison table
9. **Who it's for / not for** — honest target user profile
10. **3 real use cases** + v1.2+ roadmap

### Index update

`index.md` now lists `FEATURES.md` as the ⭐ recommended starting point.

## Why a MINOR (not PATCH)

Per `version-sop`:

| Rule | Triggered? |
|------|-----------|
| New skill / sub-skill | ❌ no |
| New Designer tool | ❌ no |
| **Major documentation addition** | ✅ yes (359-line user-facing doc) |
| Bug fix | ❌ no |

"Major documentation addition" → MINOR.

## Compatibility

- 100% backward compatible with v1.1.1
- No config changes required
- No new dependencies
- Existing users: just `git pull` to get the new docs

## Verification (preflight passed)

- `bash install/sanitize-check.sh` → Safe to push ✅
- `bash install/validate.sh` → All checks passed ✅
- `docs/FEATURES.md` renders correctly (359 lines, 11.8 KB) ✅
- `index.md` link table updated ✅
- `CHANGELOG.md` has new `[1.1.2]` section ✅

## Files changed

```
docs/FEATURES.md           (new, 359 lines)
docs/index.md              (FEATURES.md added to docs table as ⭐)
CHANGELOG.md               ([1.1.2] section added)
README.md                  (badge updated to v1.1.2)
```

## What's next

See v1.2+ roadmap in FEATURES.md §10.

---

*v1.1.2 — FEATURES.md Documentation*
*🦞 Hermes Agent · Multi-Agent Company*