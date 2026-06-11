# Partner Success AI Enablement — Master Plan

**Owner:** Mihai Gavan · Partner Success · UiPath  
**Started:** 2026-06-11  
**SharePoint:** [GlobalPartnerEnablementNetwork](https://uipath.sharepoint.com/sites/GlobalPartnerEnablementNetwork/Shared%20Documents)

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                     PARTNER SUCCESS AI TOOLKIT                       │
└─────────────────────────────────────────────────────────────────────┘

  INPUT SOURCES                  BRAIN                    OUTPUTS
  ─────────────                 ──────                   ────────
  ┌──────────────┐              ┌──────────────────┐     ┌──────────────────┐
  │  SharePoint  │──────────────▶                  │     │  QBR Drafts      │
  │  (72k docs)  │              │                  │────▶│  Partner Reports │
  └──────────────┘              │   Claude Code    │     │  Health Checks   │
                                │                  │     └──────────────────┘
  ┌──────────────┐              │   Skills Library │     ┌──────────────────┐
  │   Power BI   │──────────────▶                  │────▶│  Data Insights   │
  │  (metrics)   │              │   Agents         │     │  Weekly Digests  │
  └──────────────┘              │                  │     └──────────────────┘
                                └──────────────────┘     ┌──────────────────┐
  ┌──────────────┐                      ▲                │  Slide Decks     │
  │  User Input  │──────────────────────┘                │  Exec Summaries  │
  │  (prompts)   │                                       └──────────────────┘
  └──────────────┘
```

---

## Build Tracks & Status

```
TRACK 1 — FOUNDATIONS          ██████████ 100%   DONE ✅
TRACK 2 — SKILLS LIBRARY       ████░░░░░░  40%   IN PROGRESS  ← /qbr-prep built
TRACK 3 — AGENTS               ██░░░░░░░░  20%   IN PROGRESS  ← ecosystem designed
TRACK 4 — POWER BI AGENT       ░░░░░░░░░░   0%   PLANNED
TRACK 5 — SHAREPOINT AGENT     ████░░░░░░  40%   CONNECTED
TRACK 6 — TEAM ROLLOUT         ░░░░░░░░░░   0%   PLANNED
```

---

## Track 1 — Foundations

**Goal:** Project scaffolding + all integrations live

```
[✅] Project directory created (ClaudeCode-PB/)
[✅] PLAN.md — master roadmap
[✅] CLAUDE.md — Claude project context
[✅] Microsoft 365 / SharePoint connected
[✅] SharePoint indexed (72k+ docs accessible)
[ ] CLAUDE.md shared with team
[ ] Power BI data source identified
[ ] README.md — team onboarding guide
```

---

## Track 2 — Skills Library

**Goal:** 5 reusable `/skills` the whole team can run daily

```
How a skill works:
─────────────────
  User types: /qbr-prep
       │
       ▼
  Claude reads the skill definition (skills/qbr-prep.md)
       │
       ▼
  Prompts user for: partner name, time period, metrics
       │
       ▼
  Searches SharePoint for existing QBR templates
       │
       ▼
  Generates structured QBR draft
       │
       ▼
  Output: ready-to-edit Word/slides format
```

| # | Skill | Description | Data Sources | Status |
|---|-------|-------------|--------------|--------|
| 1 | `/qbr-prep` | Generate QBR draft from partner data | SharePoint (auto-search) + user input | ✅ Built · [skill](.claude/commands/qbr-prep.md) · [docs](skills/qbr-prep.md) |
| 2 | `/partner-health-check` | Summarize partner health from inputs | Partner data, activity logs | 🔲 Planned |
| 3 | `/escalation-triage` | Structure and prioritize escalations | Ticket data, partner context | 🔲 Planned |
| 4 | `/meeting-summary` | Summarize partner meeting notes → action items | Raw notes input | 🔲 Planned |
| 5 | `/action-tracker` | Extract + format action items from any doc | SharePoint docs, meeting notes | 🔲 Planned |

---

## Track 3 — Power BI Data Agent

**Goal:** Conversational agent that answers questions about partner metrics

```
Data Flow:
──────────
  Power BI (export or API)
       │
       ▼  CSV / JSON / REST
  data/ folder or live API call
       │
       ▼
  Agent reads + interprets metrics
       │
       ├──▶ "What's partner X's adoption rate this quarter?"
       ├──▶ "Which partners are at risk of churn?"
       └──▶ Weekly digest → email/Slack summary
```

**Open questions:**
- [ ] Power BI access method: CSV export vs REST API?
- [ ] Which dashboards/reports are most important?

---

## Track 4 — SharePoint Document Agent

**Goal:** Ask questions, get answers grounded in your internal docs

```
Query Flow:
───────────
  "What does our QBR template look like?"
       │
       ▼
  Search SharePoint (mcp__microsoft_365)
       │
       ▼
  Read relevant documents
       │
       ▼
  Synthesize answer with citations + doc links
```

**Status:** SharePoint MCP connected ✅  
**Next:** Build a skill that wraps SharePoint search into a reusable `/find-doc` command

---

## Track 5 — Team Rollout

**Goal:** Entire Partner Success team using these tools daily

```
Rollout Steps:
──────────────
  1. Finish skills library + test with Mihai
  2. Write README.md with setup instructions
  3. Share .claude/ config folder with team
  4. Run demo session (30 min)
  5. Collect feedback → iterate
```

---

## What's Being Built Right Now

```
  TODAY (2026-06-11)
  ──────────────────
  ✅ Connected to SharePoint (72k+ docs)
  ✅ Project structure created (skills/ agents/ templates/ data/)
  ✅ CLAUDE.md — project context for every session
  ✅ /qbr-prep skill — reads real KPI framework from SharePoint docs
       → .claude/commands/qbr-prep.md  (the skill)
       → skills/qbr-prep.md            (team docs + sharing guide)
       → templates/qbr-output-template.md (standalone template)
  → Next: /partner-health-check or /meeting-summary
```

---

## Decisions Log

| Date | Decision | Reason |
|------|----------|--------|
| 2026-06-11 | Start from blank repo | Clean slate, no legacy constraints |
| 2026-06-11 | Skills as primary delivery | Reusable, no infra needed, team uses immediately |
| 2026-06-11 | SharePoint as doc reference | 72k+ team docs already there, MCP gives live access |
| 2026-06-11 | Visual-first approach | Team needs to see what's happening behind the scenes |
