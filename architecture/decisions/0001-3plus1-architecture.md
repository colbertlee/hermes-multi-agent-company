# ADR 0001: 3+1 Multi-Agent Architecture

**Status**: Accepted
**Date**: 2026-08-07
**Deciders**: Architecture team
**Supersedes**: ADR-None (initial)

## Context

We needed to design a multi-agent architecture for a personal AI agent system.
Initial analysis suggested 6-7 specialized agents based on "one agent per task type":
- Tech agent
- Content agent
- Research agent
- Developer agent
- Designer agent
- Analyst agent
- Project Manager agent

## Problem

Mapping "task type" 1:1 to "agent" leads to:
1. **Coordination overhead**: 7 agents = 7 trigger keywords = 7 routing decisions per task
2. **Token waste**: Each agent has overhead (~2-5K per task) — 7 agents = 14-35K overhead alone
3. **Cognitive load**: User must remember which agent handles what
4. **Profile explosion**: Each agent needs its own Hermes profile (LLM config, env, skills)

## Decision

Adopt **3+1 architecture**:
- **3 intelligent agents** (M2.7 each): Tech, Content, Research
- **1 skill-kit** (no LLM, 0 tokens): Designer (PDF/PPT/Chart)
- **1 orchestrator** (M3, default): Routes + summarizes

### Why 3 Agents (not 1, not 6+)

| Decision | Reasoning |
|----------|-----------|
| Tech agent | Needs LLM reasoning (diagnosis, architecture) |
| Content agent | Needs LLM generation (writing) |
| Research agent | Needs LLM synthesis (compare, analyze) |
| NOT Developer agent | Code writing is part of Tech agent's responsibility |
| NOT Designer agent | Format conversion is deterministic — use scripts |
| NOT Analyst agent | Data stats is deterministic — use scripts |
| NOT PM agent | Multi-step coordination is what Kanban already does |

### Why Designer as Skill (not Agent)

Format conversion is **deterministic**:
- Markdown → PDF: reportlab does this perfectly, no LLM needed
- PPT outline → PPTX: python-pptx does this perfectly
- CSV → chart: matplotlib does this perfectly

Putting these in LLM agents wastes 5-10K tokens per task and produces worse output.

## Consequences

### Positive
- **Token savings**: 40-90% vs single-agent or 6+1 architecture
- **Simple mental model**: 3 agents + 1 skill-kit = 4 things to remember
- **Fast routing**: M3 orchestrator decides in <500 tokens
- **Zero-token format conversion**: Designer skill doesn't touch LLM
- **Extensible**: Can add more skills to existing agents (no new profile needed)

### Negative
- **Tech agent overloaded**: Now handles diagnosis + scripts + SOP (mitigation: 3 sub-skills)
- **Content agent overloaded**: SR + articles + emails + PPT outlines (mitigation: 4 sub-skills)
- **No specialized PM**: Complex projects handled by Kanban + Orchestrator

### Mitigation

Each Agent uses **specialized sub-skills** within its profile:
- Tech Agent: `dell-diagnosis`, `dell-architecture`, `dell-sop`, `code-script`
- Content Agent: `sr-report`, `article`, `email`, `ppt-outline`
- Research Agent: `tech-research`, `competitive-analysis`

This gives domain specialization *within* an agent without profile explosion.

## When to Revisit

Consider expanding from 3+1 to 5+2 if:
1. **Token budget exceeded**: Total agent overhead > 30K per complex task
2. **Profile queue build-up**: One agent's tasks consistently queued > 5min
3. **Team grows to 5+**: Need PM agent for human coordination
4. **Distinct work mode appears**: Pure-inference task (no execution) needs separate profile

## Related

- [ARCHITECTURE_REVIEW.md](../ARCHITECTURE_REVIEW.md) — Full analysis
- [A2A_COST_PROTOCOL.md](../A2A_COST_PROTOCOL.md) — Cost optimization rules
- [COMPANY_ARCHITECTURE.md](../COMPANY_ARCHITECTURE.md) — Final architecture spec

## Decision Record

Considered alternatives:
- ❌ **6+1 (full specialization)**: Over-engineered for solo/small team use case
- ❌ **1 Agent + many skills**: Loses specialization, M3 too weak for deep reasoning
- ❌ **10+ Agent fleet**: Enterprise-only, massive coordination cost
- ✅ **3+1 (this)**: Right balance for solo / small team