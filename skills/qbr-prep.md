# Skill: /qbr-prep
## Generate a Partner Success Team QBR covering your full partner portfolio

---

## What it does

```
┌─────────────────────────────────────────────────────────────────┐
│  You type: /qbr-prep                                            │
│                                                                 │
│  Claude:                                                        │
│    1. Asks for quarter, region, your portfolio data             │
│    2. Searches SharePoint for team reports & partner docs       │
│    3. Combines your data + SharePoint context                   │
│    4. Generates a full team QBR in ~30 seconds                  │
│    5. Offers: PPTX deck / HTML doc / exec brief / pre-read      │
└─────────────────────────────────────────────────────────────────┘
```

**Time saved:** ~3–4 hours of manual prep per QBR
**Output:** Executive-ready, portfolio-wide, action-oriented
**Data sources:** What you paste in + SharePoint (auto-searched)

---

## What this QBR covers

This is a **Partner Success team QBR** — it reviews the team's work, interactions,
and outcomes across all managed partners for the quarter. Not a single-partner review.

| Section | What's inside |
|---------|---------------|
| Executive Summary | Team headline, overall portfolio health indicator |
| Team Performance | Activity stats — QBRs done, meetings, pipeline influenced, certs driven |
| Portfolio Health Overview | One row per partner — tier, health RAG, key metric, risk |
| Partner Interactions | Per-partner: activities done, outcomes, next steps |
| Program Motions Progress | FY strategic motions — how the portfolio tracks against each |
| Wins & Highlights | Top wins across all partners with business impact |
| Risks & Escalations Register | Cross-portfolio risks with owners |
| Team Action Plan | 90-day actions per partner/owner with success metrics |
| Commitments | UiPath leadership commits / PS team commits |
| Next Review | Suggested date, exec sponsor, agenda focus |

Export options after generation:
- 📊 Branded PowerPoint (auto-generated .pptx)
- 🌐 Branded HTML (shareable offline)
- ✉️ Pre-read email to attendees
- 📋 1-page exec brief for VP of Partner Success
- ✅ Action items only (clean task list)

---

## How to use it

### Option A — Interactive (recommended for first use)

Just type:
```
/qbr-prep
```
Claude asks for your quarter, region, and portfolio data, then generates the QBR.

### Option B — Pass context upfront (fastest)

```
/qbr-prep Q2 FY27 | EMEA | PSM: Mihai Gavan

Partner data:
- Accenture (Strategic): QBR held, $2.3M pipeline, 12 agentic certs, Maestro migration at risk
- Capgemini (Premier): Workshop delivered, 5 new certs, co-sell deal closed ($420k ARR)
- Infosys (Select): No activity this quarter, renewal risk

Team activities: 4 QBRs conducted, 3 enablement sessions, 1 escalation resolved
```

### Option C — Paste raw notes

```
/qbr-prep
[paste meeting notes, Salesforce exports, emails, teams messages — anything]
```
Claude extracts structure from whatever you give it. Raw input = fine.

---

## KPI framework used

This skill uses the official UiPath Partner Success KPI framework at team/portfolio level:

| KPI | Target | Level |
|-----|--------|-------|
| Portfolio-wide pipeline influenced | +25% YoY | Team |
| Agentic certifications driven | +50% YoY | Team |
| QBR coverage rate | 100% of Strategic/Premier | Team |
| Partner-sourced ARR growth | +10% YoY | Portfolio |
| Escalation resolution rate | >90% | Team |
| Artifact reuse rate | ≥60% | Portfolio |
| QBR NPS | >80 | Team |

Individual partner KPIs (NRR, Technical Health Score, etc.) are tracked within each
partner's section of the portfolio overview.

---

## How to share this with your team

### Method 1 — Run the installer
Download `install.sh` from the SharePoint `Team Internal/` folder and run:
```bash
bash install.sh
```
This installs `/qbr-prep` and `/deck-builder` globally on your machine in one step.

### Method 2 — Copy from this repo
```bash
cp .claude/commands/qbr-prep.md ~/.claude/commands/qbr-prep.md
```

### What teammates need
- Claude Code installed (claude.ai/code or VS Code extension)
- Microsoft 365 MCP connected (for SharePoint search)
  → In Claude Code: type `/mcp` → select "claude.ai Microsoft 365"

---

## Version history

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | 2026-06-17 | Redesigned as team/portfolio QBR — covers all partners, not single-partner |
| 1.1 | 2026-06-14 | Applied official UiPath 2025 brand palette + PPTX export wiring |
| 1.0 | 2026-06-11 | Initial build — grounded in QBR Proposal + Strategic Model |

---

*Part of the UiPath Partner Success AI Toolkit · Built by Mihai Gavan*
