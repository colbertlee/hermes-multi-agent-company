# Release Notes — v1.1.2

**Release date:** 2026-09-06 (original) / 2026-09-07 (sanitize-check fix rolled in)
**Type:** MINOR (documentation feature) + PATCH (sanitize-check backport)
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

---

## Patch (2026-09-07) — rolled into v1.1.2

### Fixed

- **`install/sanitize-check.sh`** — Replace hardcoded user-home path literals
  in documentation with `$HOME`, so the leak-check script works for any
  user / any machine. The script was incorrectly flagging legitimate
  `$HOME` mentions in docs as "potential leaks" on a fresh install
  (commit `4744d13`, backport from release prep).

If you already installed v1.1.2 without the fix, just re-run
`install/sanitize-check.sh` and the false positives go away.

---

## Why a MINOR (not PATCH)

Per `version-sop`:

| Rule | Triggered? |
|------|-----------|
| New skill / sub-skill | ❌ no |
| New Designer tool | ❌ no |
| **Major documentation addition** | ✅ yes (359-line user-facing doc) |
| Bug fix | ❌ no (came in as backport, not the trigger) |

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
CHANGELOG.md               ([1.1.2] section added + patch entry)
README.md                  (badge updated to v1.1.2)
RELEASE_NOTES_v1.1.2.md    (this file — patch addendum)
install/sanitize-check.sh  ($HOME portability fix, commit 4744d13)
```

## What's next

See v1.2+ roadmap in FEATURES.md §10.

---

*v1.1.2 — FEATURES.md Documentation + sanitize-check portability patch*
*🦞 Hermes Agent · Multi-Agent Company*
