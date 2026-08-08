# Contributing to Hermes Multi-Agent Company

Thanks for your interest in contributing! This is a personal-architecture project
that values minimalism and clarity over feature creep.

## Quick Start

```bash
git clone https://github.com/YOUR_USER/hermes-multi-agent-company.git
cd hermes-multi-agent-company
git checkout -b feat/your-feature
```

## What We Want

✅ **Architectural clarity** — design docs that explain *why*, not just *what*
✅ **Real working code** — skills and scripts that actually run
✅ **Token efficiency** — every addition must justify its token cost
✅ **Sensible defaults** — works out-of-the-box for most users

## What We Don't Want

❌ **Bloat** — new agents when skills would suffice (see ADR-0001)
❌ **Vague examples** — placeholder docs without working code
❌ **Hard-coded secrets** — any credentials in committed files
❌ **Single-vendor lock-in** — keep templates portable across providers

## Commit Convention

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new skill for X
fix: correct Y in profile template
docs: clarify Z in USAGE.md
arch: reconsider 3+1 architecture (with ADR)
refactor: consolidate SKILL files
chore: update dependencies
```

## Adding a Skill

1. Create `skills/<your-skill>/SKILL.md` with proper YAML frontmatter
2. Add trigger words to the SKILL description (first 60 chars matter!)
3. Test by running `bash install/install-skills.sh`
4. Update `skills/README.md` if adding a category

## Adding an Architecture Decision

Create `architecture/decisions/NNNN-title.md` with:

```markdown
# ADR NNNN: <Title>

## Status
Proposed | Accepted | Deprecated | Superseded

## Context
What is the issue we're seeing?

## Decision
What did we choose?

## Consequences
What are the trade-offs?
```

## Testing

Before submitting a PR:

```bash
bash install/validate.sh        # Structural validation
bash install/sanitize-check.sh  # Sanitization check
python3 -m py_compile scripts/designer/*.py  # Python syntax
```

## Code Style

- **Python**: PEP 8, type hints for new functions
- **Shell**: shellcheck compatible
- **Markdown**: Use emojis sparingly; prefer tables for structured info

## License

By contributing, you agree that your contributions will be MIT licensed.

## Questions?

Open an issue with the `question` label.