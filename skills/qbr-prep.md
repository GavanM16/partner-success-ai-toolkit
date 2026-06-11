# Skill: /qbr-prep
## Generate a complete QBR draft from partner data

---

## What it does

```
┌─────────────────────────────────────────────────────────────────┐
│  You type: /qbr-prep                                            │
│                                                                 │
│  Claude:                                                        │
│    1. Asks for partner name, tier, quarter, data you have       │
│    2. Searches SharePoint for that partner automatically        │
│    3. Combines your data + SharePoint context                   │
│    4. Generates a full, structured QBR in ~30 seconds           │
│    5. Offers: slides format / pre-read email / exec brief       │
└─────────────────────────────────────────────────────────────────┘
```

**Time saved:** ~2–3 hours of manual prep per QBR  
**Output quality:** Executive-ready, KPI-grounded, action-oriented  
**Data sources:** What you paste in + SharePoint (auto-searched)

---

## Output structure

The skill generates a complete QBR with:

| Section | What's inside |
|---------|---------------|
| Executive Summary | Headline result, relationship health indicator |
| Partner Health Scorecard | All 12 KPIs with RAG status (🟢🟡🔴) |
| Performance Review | Revenue, pipeline, agentic adoption, technical health, support |
| Strategic Alignment | FY28/29 motions — where partner plays, where the gaps are |
| Joint Wins | Top wins with business impact |
| Challenges & Risks | Risk table with owners and mitigations |
| Joint Action Plan | 90-day actions, owners, due dates, success metrics |
| Commitments | UiPath commits / Partner commits |
| Next QBR | Suggested date, exec sponsor, agenda focus |

Then offers follow-up formats:
- PowerPoint-ready bullet version
- Pre-read email to partner
- 1-page exec brief for VP of Partner Success
- Action items only (clean task list)

---

## How to use it

### Option A — Interactive (recommended for first use)

Just type:
```
/qbr-prep
```
Claude will ask you for the inputs, then generate the QBR.

### Option B — Pass context upfront (fastest)

```
/qbr-prep Partner: Accenture | Tier: Strategic | Quarter: Q2 FY27 | Region: EMEA
Pipeline this quarter: $2.3M sourced, $8.1M influenced
Certifications: 12 new agentic certs, 45 total
Key win: Closed Heineken deal ($420k ARR)
Risk: Slow migration to Maestro, only 2 of 8 projects converted
```

### Option C — Paste raw notes

```
/qbr-prep
[paste messy meeting notes, email threads, Salesforce exports — anything]
```
Claude will extract structure from whatever you give it.

---

## KPI framework used

This skill uses the official UiPath Partner Success KPI framework:

| KPI | Target | Source doc |
|-----|--------|-----------|
| Partner Churn Reduction | 15–20% reduction | Strategic Partner Model |
| Net Revenue Retention | +10% YoY | Strategic Partner Model |
| Technical Health Score | >85% | Strategic Partner Model |
| Partner-Sourced ARR | +25% YoY | QBR Proposal (May 2026) |
| Agentic Certifications | +50% YoY | Strategic Partner Model |
| Migration Success | >90% | Strategic Partner Model |
| RSI Competency Growth | +20% YoY | Strategic Partner Model |
| Partner Portal Usage | 15k logins/month | Strategic Partner Model |
| Artifact Reuse Rate | ≥60% | Strategic Goals Addendum |
| QBR NPS | >80 | QBR Proposal (May 2026) |

---

## How to share this with your team

### Method 1 — Share the project folder (easiest)
Anyone who has access to this `ClaudeCode-PB/` folder already has all skills.
The skill lives at: `.claude/commands/qbr-prep.md`

### Method 2 — Copy to personal Claude commands (global access)
Run this in terminal to make `/qbr-prep` available in ANY project:

```bash
cp .claude/commands/qbr-prep.md ~/.claude/commands/qbr-prep.md
```

After copying, `/qbr-prep` works everywhere — not just in this project.

### Method 3 — Share the file directly
Send a teammate the file: `.claude/commands/qbr-prep.md`
They paste it into their own `.claude/commands/` folder.

### What teammates need
- Claude Code installed (claude.ai/code or VS Code extension)
- Microsoft 365 MCP connected (for SharePoint search)
  → In Claude Code: type `/mcp` → select "claude.ai Microsoft 365"

---

## Customising for your style

Edit `.claude/commands/qbr-prep.md` to:

- **Add sections** — e.g. a "Partner Investment ROI" section
- **Change the tone** — e.g. make it more conversational for smaller partners
- **Pre-fill your name** — replace `[Your name]` with your actual name
- **Adjust KPIs** — add tier-specific KPIs (e.g. GSI-only metrics for Accenture/Deloitte)
- **Change output format** — make it output JIRA tasks, Salesforce notes, etc.

---

## Version history

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-06-11 | Initial build — grounded in QBR Proposal + Strategic Model |

---

*Part of the UiPath Partner Success AI Toolkit · Built by Mihai Gavan*
