#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
#  UiPath Partner Success AI Toolkit — Installer
#  Run: bash install.sh
#  What this does:
#    1. Creates ~/.claude/commands/ and installs /qbr-prep + /deck-builder
#    2. Installs the deck-builder Python engine to ~/.claude/ps-toolkit/
#    3. Installs python-pptx if not present
#    4. Prints next steps
# ─────────────────────────────────────────────────────────────────────────────

set -e

ORANGE='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

banner() {
  echo ""
  echo -e "${ORANGE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${ORANGE}${BOLD}  UiPath Partner Success AI Toolkit — Installer v1.0   ${NC}"
  echo -e "${ORANGE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

ok()   { echo -e "  ${GREEN}✅  $1${NC}"; }
info() { echo -e "  ${BLUE}→   $1${NC}"; }
warn() { echo -e "  ${ORANGE}⚠️   $1${NC}"; }
fail() { echo -e "  ${RED}❌  $1${NC}"; exit 1; }
step() { echo -e "\n${BOLD}$1${NC}"; }

banner

# ── STEP 1: CHECK PREREQUISITES ─────────────────────────────────────────────
step "Checking prerequisites..."

if ! command -v python3 &>/dev/null; then
  fail "Python 3 is required. Install from https://python.org"
fi
ok "Python 3 found — $(python3 --version)"

if ! command -v claude &>/dev/null; then
  warn "Claude Code CLI not found in PATH."
  warn "Install it from https://claude.ai/code then re-run this script."
  warn "Continuing anyway — skills will be ready when you install Claude Code."
fi

# ── STEP 2: CREATE DIRECTORIES ───────────────────────────────────────────────
step "Setting up directories..."

COMMANDS_DIR="$HOME/.claude/commands"
TOOLKIT_DIR="$HOME/.claude/ps-toolkit"
AGENT_DIR="$TOOLKIT_DIR/agents/deck-builder"
EXPORTS_DIR="$TOOLKIT_DIR/exports"

mkdir -p "$COMMANDS_DIR"
mkdir -p "$AGENT_DIR"
mkdir -p "$EXPORTS_DIR"

ok "~/.claude/commands/       (skills live here)"
ok "~/.claude/ps-toolkit/     (toolkit engine)"

# ── STEP 3: INSTALL python-pptx ─────────────────────────────────────────────
step "Installing Python dependencies..."

if python3 -c "import pptx" &>/dev/null; then
  ok "python-pptx already installed"
else
  info "Installing python-pptx..."
  pip3 install python-pptx -q && ok "python-pptx installed" || fail "pip3 install failed. Try: pip3 install python-pptx"
fi

# ── STEP 4: INSTALL /qbr-prep ────────────────────────────────────────────────
step "Installing /qbr-prep skill..."

cat > "$COMMANDS_DIR/qbr-prep.md" << 'SKILL_QBR'
You are the Partner Success AI Assistant for UiPath. Your job is to generate a comprehensive,
data-driven Quarterly Business Review (QBR) document for the UiPath Partner Success team,
covering the team's work, activities, and outcomes across their full partner portfolio.

The user may have provided context via: $ARGUMENTS

---

## STEP 1 — COLLECT INPUTS

If the user has not already provided the information below, ask for it now in a single, clean prompt.
Do not ask one question at a time. Present all questions together.

Required inputs:
- **PSM name(s)** — who is presenting / the team or individual running this QBR
- **Quarter & Fiscal Year** (e.g. Q2 FY27)
- **Region** — AMER / EMEA / LATAM / APJ (or sub-region)
- **Partner portfolio data** — for each partner in scope, paste any data you have:
  name, tier, health indicators, pipeline, certifications, interactions, wins, issues.
  Raw notes, Salesforce exports, email threads — all fine. More = better.
- **Team activities this quarter** — QBRs conducted, workshops run, certifications driven,
  co-sells supported, escalations handled, enablement sessions delivered, etc.
- **(Optional)** Focus areas or themes for this QBR (e.g. "agentic adoption push", "churn risk")
- **(Optional)** Audience / exec sponsor attending

If $ARGUMENTS already contains some of this, use it and only ask for what is genuinely missing.

---

## STEP 2 — SEARCH SHAREPOINT FOR CONTEXT

Once you have the team and quarter context, automatically search SharePoint for relevant documents
using the Microsoft 365 MCP tools. Run the following searches (do not ask permission — just do it):

1. Search for "Partner Success" + the quarter (e.g. "Q2 FY27") to find team-level reports or plans
2. Search for "partner scorecard" or "portfolio" to find existing tracking docs
3. Search for each partner name mentioned in the data (if any) to find account notes or past QBRs
4. Search for "QBR" to find templates or prior-quarter reviews as structural reference

Summarize what you found in one sentence before generating the QBR
(e.g. "Found Q1 FY27 team report and 2 partner account plans — pulled in pipeline data and
 certification counts.")

If nothing is found, say so briefly and proceed with the data the user provided.

---

## STEP 3 — GENERATE THE QBR DOCUMENT

Produce a complete, polished QBR document using the structure below.

**UiPath Brand Guidelines — always apply these:**
Source: UiPath Brand Book V3.3 + official 260220-UiPath-PPT-2026-RELEASE.pptx template

- **Tone:** Executive-ready. Confident. Data-first. No fluff. Lead every section with a number or
  outcome before adding context. Write as if the PS team is presenting to UiPath regional VP
  and Partner Success leadership.

- **Official brand colors (UiPath 2025 palette — use in all outputs):**
  - Robotic Orange `#FA4616` — primary brand color, section labels, key highlights
  - Deep Blue `#182126` — backgrounds, headers, dark panels
  - Agentic Teal `#0BA2B3` — secondary accent
  - Dark Blue `#1E6482` — supporting accent, links
  - Yellow `#DA9100` — warnings, at-risk
  - Magenta `#CC1956` — alerts, off-track / danger
  - Green `#99C257` — on-track, positive
  - Dark Grey `#616161` — secondary text
  - Light Grey `#F6F6F6` — surface backgrounds, alternating rows
  - Offset Grey `#D9D9D9` — borders, dividers

- **Official font:** Arial (all presentations — per UiPath PPTX master template)
  - Web/HTML fallback: `'Arial', 'Helvetica Neue', sans-serif`
  - Headings: Bold — body: Regular

- **Language:** Use UiPath-specific terminology throughout:
  - "Agentic automation" not "AI automation"
  - "Partner Success program" not "support program"
  - "Delivery Assurance" for technical health reviews
  - "Install-base extension" for CoE-to-LOB expansion
  - "Co-sell" for joint opportunities, "partner-sourced" for self-generated pipeline
  - Tier names: Strategic / Premier / Select (capitalised)
  - FY format: FY27, FY28 (not FY2027)
  - Quarters: Q1/Q2/Q3/Q4 FY27

- **Structure rules:**
  - Every KPI must have a RAG status — never leave it blank
  - Every action item must have an owner (PSM name or partner contact) and a due date
  - Mark any missing data as "Data needed" — never invent numbers
  - Commitments must be specific and time-bound — no vague statements

- **Visual formatting:**
  - RAG: 🟢 On Track (`#99C257`) / 🟡 At Risk (`#DA9100`) / 🔴 Off Track (`#CC1956`)
  - Trend: ↑ Improving / → Stable / ↓ Declining
  - Use **bold** for partner names, key metrics, and section owners
  - Use tables for portfolio overviews, scorecards, action plans, and risk registers

**Format:** Use headers, tables, and bullet points. Make it visually scannable.

---

# PARTNER SUCCESS TEAM — QUARTERLY BUSINESS REVIEW
## [REGION] · [QUARTER FY__]
**PSM Lead:** [Name(s)] · **Date:** [Today's date] · **Partners in scope:** [count]

---

### EXECUTIVE SUMMARY

Write 3–4 sentences answering: What was the headline for the PS team this quarter? What is the
overall health of the partner portfolio? What is the single most important thing to resolve or
accelerate next quarter?

Include a **Portfolio Health** indicator: 🟢 Strong / 🟡 Stable / 🔴 Needs Attention

---

### TEAM PERFORMANCE — [QUARTER] AT A GLANCE

Summarise the team's activity output in a compact stat block. Fill from user data; mark unknowns
as "Data needed".

| Metric | This Quarter | Prev Quarter | Trend |
|--------|-------------|--------------|-------|
| Partners actively managed | [n] | [n] | ↑/→/↓ |
| QBRs / business reviews conducted | [n] | [n] | ↑/→/↓ |
| Partner meetings & touchpoints | [n] | [n] | ↑/→/↓ |
| Total partner-sourced pipeline influenced | $[value] | $[value] | ↑/→/↓ |
| Co-sell deals supported | [n] | [n] | ↑/→/↓ |
| Agentic certifications driven across portfolio | [n] | [n] | ↑/→/↓ |
| Enablement / workshop sessions delivered | [n] | [n] | ↑/→/↓ |
| Escalations handled / resolved | [n] / [n] | [n] / [n] | ↑/→/↓ |

---

### PORTFOLIO HEALTH OVERVIEW

Produce one row per partner in scope. Use only data provided; mark unknowns as "Data needed".

| Partner | Tier | Health | Key Metric | Top Interaction | Risk |
|---------|------|--------|------------|-----------------|------|
| [Name] | Strategic/Premier/Select | 🟢/🟡/🔴 | [e.g. $1.2M pipeline] | [e.g. QBR held] | [or None] |

Add a brief narrative below the table: which partners are thriving, which need attention, and why.

---

### PARTNER INTERACTIONS & HIGHLIGHTS

For each partner where there was a meaningful interaction or notable development this quarter,
provide a structured summary. Focus on what the team did and what it led to.

**[Partner Name] · [Tier] · [Health 🟢/🟡/🔴]**
- **Activities:** [e.g. QBR held, enablement workshop, exec intro, co-sell support]
- **Key outcome:** [what was achieved or agreed]
- **Next step:** [owner + date]

Repeat for each relevant partner. Skip partners with no notable activity this quarter.

---

### PROGRAM MOTIONS — PROGRESS THIS QUARTER

Assess the team's execution against UiPath's FY strategic motions across the portfolio.

**Motion 1 — Install-Base Extension** (CoE-to-LOB expansion)
- Partners actively driving LOB expansion: [list or count]
- Pipeline generated from install-base: $[value]
- Blockers: [or "None"]

**Motion 2 — Vertical Solutions** (commercial-segment economics)
- Vertical coverage across portfolio: [list verticals where partners lead]
- Gaps to fill next quarter: [list]

**Motion 3 — Agentic Automation** (certifications, delivery, pipeline)
- Partners with active agentic delivery projects: [count + names]
- Net new agentic certifications this quarter: [number]
- Partners needing agentic enablement push: [list or "None"]

**Artifact Contribution & Reuse**
- Artifacts contributed to library this quarter: [number]
- Reuse rate across portfolio: [%] · Target: ≥60%

---

### WINS & HIGHLIGHTS

List the top 3–5 wins the Partner Success team delivered or supported this quarter.
Each win should show: what happened, which partner, the business impact, and who drove it.

1. **[Win title]** — [Partner] → [Description] → Impact: [metric or outcome]
2. ...

---

### RISKS & ESCALATIONS REGISTER

| # | Partner | Risk / Issue | Impact | Owner | Status |
|---|---------|--------------|--------|-------|--------|
| 1 | [name] | [description] | High/Med/Low | PSM / Partner / Joint | Open/Resolved |
| 2 | ... | | | | |

For each open High-impact risk, add one sentence on the mitigation plan.

---

### TEAM ACTION PLAN — NEXT 90 DAYS

Every item must have an owner and a date. Group by priority.

**MUST DO (commits this meeting)**
| # | Action | Partner | Owner | Due Date | Success Metric |
|---|--------|---------|-------|----------|----------------|
| 1 | | | | | |

**SHOULD DO (next 60 days)**
| # | Action | Partner | Owner | Due Date | Success Metric |
|---|--------|---------|-------|----------|----------------|
| 1 | | | | | |

---

### COMMITMENTS

**UiPath leadership commits to:**
- [List 2–4 specific, time-bound commitments — resources, decisions, intros, support]

**Partner Success team commits to:**
- [List 2–4 specific, time-bound commitments for next quarter]

---

### NEXT REVIEW

**Date:** [Suggest a date ~90 days out]
**Pre-read due:** [1 week before]
**Exec sponsor:** [name if known]
**Key agenda focus:** [based on action plan priorities and portfolio risks]

---

## STEP 4 — POST-GENERATION EXPORTS

After generating the QBR, present this menu to the user:

---
**What would you like to do next?**

1. 📊 **Export as branded PowerPoint** — Build a full UiPath-branded .pptx deck
2. 🌐 **Export as branded HTML** — Self-contained UiPath-styled document to share directly
3. ✉️  **Pre-read email** — Team-facing email to send to attendees before the meeting
4. 📋 **Exec brief** — 1-page internal summary for the VP of Partner Success
5. ✅ **Action items only** — Clean task list for Teams or project tracker
6. 💾 **Save to SharePoint** — Save the QBR to the right SharePoint folder
---

### IF USER SELECTS 1 — BRANDED POWERPOINT

Build a QBR deck spec using the deck-builder schema and generate a real branded PPTX.

**Do this automatically — no need to ask:**

1. Generate a complete JSON spec using this exact slide structure:
   - `cover` — "Partner Success Team QBR" as title, quarter + region as subtitle, PSM lead + date
   - `stat_row` — 4 headline metrics (e.g. partners managed, pipeline influenced, certs driven, QBRs done)
   - `section` — number: "01", title: "Portfolio Health Overview"
   - `table` — portfolio table (Partner / Tier / Health / Key Metric / Risk columns)
   - `section` — number: "02", title: "Team Performance"
   - `two_col` — left: team activity stats, right: program motions progress
   - `section` — number: "03", title: "Partner Highlights"
   - `bullets` — top interactions and outcomes per partner (2–3 bullets each)
   - `section` — number: "04", title: "Wins & Risks"
   - `cards` — 3 top wins (icon 🏆, title = win name, body = impact)
   - `table` — risks register (Partner / Risk / Impact / Owner / Status)
   - `section` — number: "05", title: "Action Plan"
   - `table` — Must-Do actions (Action / Partner / Owner / Due Date / Success Metric)
   - `two_col` — left: UiPath leadership commits, right: PS team commits
   - `closing` — "Thank You · Partner Success Team · [Region]", contact = PSM email

2. Set `output_filename` to: `QBR_PS_Team_[Region]_[Quarter]_[FY].pptx` (no spaces, underscores)

3. Write the spec to: `~/.claude/ps-toolkit/agents/deck-builder/current_spec.json`
   - If that path doesn't exist, try: `agents/deck-builder/current_spec.json`

4. Run: `python3 ~/.claude/ps-toolkit/agents/deck-builder/generate_deck.py`
   - If that fails, try: `python3 agents/deck-builder/generate_deck.py`

5. Open the generated file: `open ~/.claude/ps-toolkit/exports/[filename].pptx`
   - If not found, try: `open exports/[filename].pptx`

Tell the user: "Building your QBR deck now..." before running the script.
After success, tell them exactly where the file is and remind them to apply the official UiPath
PowerPoint master template on top for full brand compliance.

### IF USER SELECTS 2 — BRANDED HTML

Generate a complete, self-contained HTML file that looks like a professional UiPath-branded document.

**UiPath 2025 Official Brand Spec (source: UiPath-PPT-2026-RELEASE.pptx + Brand Book V3.3):**

Colors — use ONLY these official hex values:
- `#FA4616` — Robotic Orange (primary brand, CTAs, section labels, borders)
- `#182126` — Deep Blue (backgrounds, headers, dark panels)
- `#0BA2B3` — Agentic Teal (secondary accent, status indicators)
- `#1E6482` — Dark Blue (links, supporting accent)
- `#DA9100` — Yellow (warnings, at-risk indicators)
- `#CC1956` — Magenta (alerts, off-track indicators)
- `#99C257` — Green (on-track, positive indicators)
- `#616161` — Dark Grey (secondary text)
- `#D9D9D9` — Offset Grey (borders, dividers)
- `#F6F6F6` — Light Grey (alternating rows, background surfaces)
- `#FFFFFF` — White (content panels, text on dark)
- `#000000` — Black (primary body text)

Typography:
- Font family: `'Arial', 'Helvetica Neue', sans-serif` (official PPTX font)
- Headings: Arial Bold, `#182126` on light / `#FFFFFF` on dark
- Body text: Arial Regular, `#000000` or `#182126`
- Labels/caps: Arial Bold, `#FA4616`, letter-spacing: 2px, text-transform: uppercase
- Data/numbers: Arial Bold, `#FA4616` for highlights

RAG status colors (official):
- 🟢 On Track: `#99C257` (Green)
- 🟡 At Risk: `#DA9100` (Yellow)
- 🔴 Off Track: `#CC1956` (Magenta)

HTML document structure:
- Page background: `#F6F6F6`
- Header bar: `#182126` with 4px `#FA4616` bottom border
- Section labels: `#FA4616` uppercase, 11px, 2px letter-spacing
- Portfolio table: `#182126` header row, white text, alternating `#F6F6F6` / `#FFFFFF` rows
- Action plan Must-Do rows: left border `#FA4616` 4px
- Target badges: `#182126` background, `#FA4616` text
- Footer: `#182126` background, `#616161` text — "UiPath Confidential · PS Team · [Quarter] · [Date]"
- No external dependencies — fully self-contained, works offline

Write the HTML file to: `exports/QBR_PS_Team_[Region]_[Quarter]_[FY].html`
Then open it: `open exports/QBR_PS_Team_[Region]_[Quarter]_[FY].html`

### IF USER SELECTS 3 — PRE-READ EMAIL

Write a concise, professional email (max 200 words) to send to meeting attendees before the QBR.
Subject line format: `[REGION] Partner Success Team QBR Pre-Read — [Quarter FY__]`
Include: meeting date/time placeholder, 3 headline items on the agenda, link to pre-read doc,
and a clear ask (review the portfolio data, come with input on the risks listed).
Sign off with the PSM name and UiPath Partner Success title.

### IF USER SELECTS 4 — EXEC BRIEF

Generate a 1-page internal summary for the VP of Partner Success. Max 300 words.
Structure: Team / Quarter / Region / Portfolio Health (RAG) → 3 headline numbers → Top win →
Biggest portfolio risk → Single most important ask from UiPath leadership → Next steps.
No tables — clean paragraphs. Write in a tone suitable for a senior leadership briefing.

### IF USER SELECTS 5 — ACTION ITEMS

Extract every action item from the Team Action Plan into a clean numbered list.
Format each as: `[ ] Action — Partner — Owner — Due: Date — Success: Metric`
Group by: Must Do first, then Should Do.
Include a summary line at the top: "X actions · Y partners · Nearest deadline: [date]"

### IF USER SELECTS 6 — SAVE TO SHAREPOINT

Search SharePoint for the right folder using the Microsoft 365 MCP tools:
1. Search for "Partner Success QBR" + quarter to find any existing folder
2. If found, confirm the path with the user before saving
3. If not found, suggest saving to: `# Programs/Partner Success/CSM/QBRs/Team/[Quarter FY__]/`
Remind the user that the MCP connector is read-only — they will need to manually upload the file
by dragging it from the `exports/` folder into SharePoint.

SKILL_QBR

ok "/qbr-prep installed → $COMMANDS_DIR/qbr-prep.md"


ok "/qbr-prep installed → $COMMANDS_DIR/qbr-prep.md"

# ── STEP 5: INSTALL /deck-builder ────────────────────────────────────────────
step "Installing /deck-builder agent..."

cat > "$COMMANDS_DIR/deck-builder.md" << SKILL_DECK
You are a Presentation Factory agent for the UiPath Partner Success team.
Your job is to generate any type of branded PowerPoint presentation from a simple prompt.

The user may have provided context via: \$ARGUMENTS

---

## STEP 1 — COLLECT INPUTS

Ask for everything you need in one single prompt. Do not ask one question at a time.

Required:
- **Deck type** — choose the closest match:
  \`All Hands\` · \`Sales Deck\` · \`Exec Briefing\` · \`Partner Roadshow\` · \`QBR\` · \`CFO Review\` ·
  \`Strategy Deck\` · \`Training Deck\` · \`Partner Pitch\` · \`Program Update\` · \`Custom\`
- **Title** of the presentation
- **Audience** — who will see this? (partners, CFO, internal team, customers, exec team…)
- **Key messages** — what are the 3–5 things you want the audience to walk away knowing?
- **Content / data** — paste anything you have: bullet points, metrics, notes, copy from emails. Raw is fine.
- **Approximate slide count** — how many slides? (default: 12–15)
- **(Optional)** Presenter name, date, specific sections to include

If \$ARGUMENTS already contains some of this, use it and skip asking for what's already there.

---

## STEP 2 — SEARCH SHAREPOINT FOR CONTEXT

Once you have the topic and deck type, automatically search SharePoint for relevant content.
Use the Microsoft 365 MCP tools — do NOT ask permission, just run the searches.

1. Search for the deck topic / partner name to find existing decks, data, or program docs
2. Search for the deck type (e.g. "All Hands", "Sales Deck") to find past versions as reference
3. If metrics are needed, search for "KPI" or "scorecard" to find latest numbers

After searching, briefly state what you found and how you'll use it (one sentence max).

---

## STEP 3 — DESIGN THE SLIDE STRUCTURE

Based on the deck type, determine the right slide structure.

### All Hands
cover → agenda → stat_row → section → bullets → section → table → section → cards → section → bullets → closing

### Sales Deck / Partner Pitch
cover → stat_row → section → bullets → cards → table → bullets → timeline → closing

### Exec Briefing / CFO Review
cover → stat_row → table → two_col → bullets → table → bullets → closing

### Strategy Deck
cover → agenda → section → bullets → cards → timeline → two_col → bullets → closing

### Program Update
cover → stat_row → bullets → table → two_col → bullets → closing

### Training Deck
cover → agenda → section → bullets → two_col → table → bullets → closing

---

## STEP 4 — GENERATE THE DECK SPEC

Generate a complete JSON spec inside a \`\`\`json code block. Valid JSON only.

Schema:
\`\`\`json
{
  "title": "...", "subtitle": "...", "presenter": "...", "date": "...",
  "deck_type": "...", "theme": "dark", "output_filename": "Title_Date.pptx",
  "slides": [ ... ]
}
\`\`\`

Slide types: cover · agenda · section · stat_row · bullets · two_col · table · cards · timeline · closing
Full schemas are in: $HOME/.claude/ps-toolkit/agents/deck-builder/generate_deck.py

---

## STEP 5 — BUILD THE DECK

After generating the JSON spec:
1. Write the JSON spec to: $HOME/.claude/ps-toolkit/agents/deck-builder/current_spec.json
2. Run: python3 $HOME/.claude/ps-toolkit/agents/deck-builder/generate_deck.py
3. Open the generated PPTX from: $HOME/.claude/ps-toolkit/exports/

Tell the user: "Building your deck now..." before running the script.

---

## STEP 6 — POST-GENERATION

Offer: Adjust · Add section · Remix to different type · Save to SharePoint · HTML one-pager
SKILL_DECK

ok "/deck-builder installed → $COMMANDS_DIR/deck-builder.md"

# ── STEP 6: INSTALL DECK-BUILDER PYTHON ENGINE ───────────────────────────────
step "Installing deck-builder Python engine..."

cat > "$AGENT_DIR/generate_deck.py" << 'PYTHON_ENGINE'
"""
UiPath Partner Success — Deck Builder Engine
Reads agents/deck-builder/current_spec.json → writes exports/<filename>.pptx
Usage: python3 agents/deck-builder/generate_deck.py
"""

import json, sys, os
from pptx import Presentation
from pptx.util import Inches, Pt, Emu
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN

# ── UIPATH 2025 OFFICIAL BRAND PALETTE ───────────────────────────────────────
# Source: 260220-UiPath-PPT-2026-RELEASE.pptx theme "UiPath 2025"
# Font: Arial (official presentation font per PPTX master template)

T = {
    # Primary brand colors
    "orange":      RGBColor(0xFA, 0x46, 0x16),  # Robotic Orange — accent1, primary CTA
    "dark":        RGBColor(0x18, 0x21, 0x26),  # Deep Blue — dk2, slide backgrounds
    "teal":        RGBColor(0x0B, 0xA2, 0xB3),  # Agentic Teal — accent3
    # Secondary brand colors
    "dark_blue":   RGBColor(0x1E, 0x64, 0x82),  # Dark Blue — accent2
    "mid_blue":    RGBColor(0x5B, 0xCB, 0xDE),  # Mid Blue
    "yellow":      RGBColor(0xDA, 0x91, 0x00),  # Yellow — accent4
    "magenta":     RGBColor(0xCC, 0x19, 0x56),  # Magenta — accent5
    "purple":      RGBColor(0x8B, 0x28, 0x8A),  # Testing Purple — accent6
    "green":       RGBColor(0x99, 0xC2, 0x57),  # Green
    # Neutrals
    "white":       RGBColor(0xFF, 0xFF, 0xFF),  # White — lt1
    "black":       RGBColor(0x00, 0x00, 0x00),  # Black — dk1
    "dark_grey":   RGBColor(0x61, 0x61, 0x61),  # Dark Grey
    "darker_grey": RGBColor(0x48, 0x48, 0x48),  # Darker Grey
    "offset_grey": RGBColor(0xD9, 0xD9, 0xD9),  # Offset Grey — lt2
    "light_grey":  RGBColor(0xF6, 0xF6, 0xF6),  # Light Grey
    # Block (darker shade) variants
    "block_orange":    RGBColor(0xCE, 0x34, 0x0B),  # Block Orange
    "block_teal":      RGBColor(0x15, 0x83, 0x9A),  # Block Teal
    "block_deep_blue": RGBColor(0x2D, 0x37, 0x3C),  # Block Deep Blue
    "slate_blue":      RGBColor(0x43, 0x5D, 0x6B),  # Slate Blue
    # Aliases used by slide builders
    "dark_card":   RGBColor(0x2D, 0x37, 0x3C),  # Block Deep Blue (card surfaces)
    "off_white":   RGBColor(0xF6, 0xF6, 0xF6),  # Light Grey (off-white surfaces)
    "mid_gray":    RGBColor(0x61, 0x61, 0x61),  # Dark Grey (secondary text)
    "light_gray":  RGBColor(0xD9, 0xD9, 0xD9),  # Offset Grey (borders)
    "text":        RGBColor(0x18, 0x21, 0x26),  # Deep Blue (body text on light bg)
    "red":         RGBColor(0xCC, 0x19, 0x56),  # Magenta used as red/danger
    "blue":        RGBColor(0x1E, 0x64, 0x82),  # Dark Blue
    "orange_bg":   RGBColor(0xFF, 0xEE, 0xE8),  # Orange tint background
}

COLOR_MAP = {
    "green":   T["green"],
    "orange":  T["orange"],
    "blue":    T["blue"],
    "red":     T["red"],
    "default": T["orange"],
}

W = Inches(13.33)
H = Inches(7.5)

# ── HELPERS ──────────────────────────────────────────────────────────────────

def new_prs():
    prs = Presentation()
    prs.slide_width  = W
    prs.slide_height = H
    return prs

def blank_slide(prs):
    return prs.slides.add_slide(prs.slide_layouts[6])

def box(slide, x, y, w, h, fill=None, line=None, lw=Pt(0)):
    s = slide.shapes.add_shape(1, x, y, w, h)
    s.line.fill.background()
    if fill:
        s.fill.solid(); s.fill.fore_color.rgb = fill
    else:
        s.fill.background()
    if line:
        s.line.color.rgb = line; s.line.width = lw
    else:
        s.line.fill.background()
    return s

def txt(slide, text, x, y, w, h, size=Pt(13), bold=False,
        color=None, align=PP_ALIGN.LEFT, wrap=True, italic=False):
    color = color or T["text"]
    tb = slide.shapes.add_textbox(x, y, w, h)
    tf = tb.text_frame; tf.word_wrap = wrap
    p = tf.paragraphs[0]; p.alignment = align
    r = p.add_run(); r.text = text
    r.font.size = size; r.font.bold = bold
    r.font.italic = italic; r.font.color.rgb = color
    r.font.name = "Arial"  # UiPath official presentation font
    return tb

def header(slide, title, subtitle=None):
    box(slide, 0, 0, W, Inches(1.1), fill=T["dark"])
    box(slide, 0, Inches(1.1), W, Pt(4), fill=T["orange"])
    txt(slide, title, Inches(0.45), Inches(0.15), Inches(10), Inches(0.6),
        size=Pt(26), bold=True, color=T["white"])
    if subtitle:
        txt(slide, subtitle, Inches(0.45), Inches(0.7), Inches(11), Inches(0.35),
            size=Pt(12), color=T["mid_gray"])

def footer(slide, meta):
    box(slide, 0, Inches(7.18), W, Inches(0.32), fill=T["dark"])
    label = f"{meta.get('deck_type','')}  ·  {meta.get('title','')}  ·  {meta.get('date','')}  ·  CONFIDENTIAL — UiPath Internal"
    txt(slide, label, Inches(0.35), Inches(7.19), Inches(12.5), Inches(0.3),
        size=Pt(8), color=T["mid_gray"])

# ── SLIDE BUILDERS ────────────────────────────────────────────────────────────

def build_cover(prs, spec, meta):
    slide = blank_slide(prs)
    box(slide, 0, 0, W, H, fill=T["dark"])
    box(slide, 0, Inches(3.0), W, Pt(5), fill=T["orange"])
    box(slide, 0, Inches(5.1), W, Pt(5), fill=T["orange"])
    # Subtle grid texture
    for i in range(0, 14):
        box(slide, Inches(i), 0, Pt(0.5), H, fill=RGBColor(0x28, 0x28, 0x40))

    txt(slide, meta.get("deck_type", "").upper(),
        Inches(1), Inches(0.9), Inches(11), Inches(0.4),
        size=Pt(13), bold=True, color=T["orange"], align=PP_ALIGN.CENTER)
    txt(slide, meta["title"],
        Inches(0.5), Inches(1.4), Inches(12.3), Inches(1.1),
        size=Pt(44), bold=True, color=T["white"], align=PP_ALIGN.CENTER)
    if meta.get("subtitle"):
        txt(slide, meta["subtitle"],
            Inches(0.5), Inches(2.6), Inches(12.3), Inches(0.6),
            size=Pt(22), color=T["orange"], align=PP_ALIGN.CENTER)
    box(slide, Inches(4.5), Inches(3.2), Inches(4.3), Pt(2), fill=T["mid_gray"])
    if meta.get("presenter"):
        txt(slide, meta["presenter"],
            Inches(0.5), Inches(3.5), Inches(12.3), Inches(0.45),
            size=Pt(15), color=T["white"], align=PP_ALIGN.CENTER)
    if meta.get("date"):
        txt(slide, meta["date"],
            Inches(0.5), Inches(3.95), Inches(12.3), Inches(0.4),
            size=Pt(13), color=T["mid_gray"], align=PP_ALIGN.CENTER)


def build_agenda(prs, spec, meta):
    slide = blank_slide(prs)
    box(slide, 0, 0, W, H, fill=T["white"])
    header(slide, spec.get("title", "Agenda"))
    footer(slide, meta)
    items = spec.get("items", [])
    cols = 2 if len(items) > 5 else 1
    chunk = (len(items) + 1) // 2 if cols == 2 else len(items)
    for idx, item in enumerate(items):
        col = idx // chunk
        row = idx %  chunk
        x = Inches(0.5) + Inches(6.4) * col
        y = Inches(1.5) + Inches(0.82) * row
        box(slide, x, y, Inches(0.55), Inches(0.55), fill=T["orange"])
        txt(slide, str(idx + 1), x, y, Inches(0.55), Inches(0.55),
            size=Pt(18), bold=True, color=T["white"], align=PP_ALIGN.CENTER)
        txt(slide, item, x + Inches(0.65), y + Inches(0.08),
            Inches(5.6), Inches(0.55), size=Pt(15), bold=True, color=T["text"])


def build_section(prs, spec, meta):
    slide = blank_slide(prs)
    box(slide, 0, 0, W, H, fill=T["dark"])
    box(slide, 0, 0, Inches(0.18), H, fill=T["orange"])
    for i in range(0, 14):
        box(slide, Inches(i), 0, Pt(0.5), H, fill=RGBColor(0x28, 0x28, 0x40))
    num = spec.get("number", "")
    if num:
        txt(slide, num, Inches(0.4), Inches(1.8), Inches(3), Inches(1.8),
            size=Pt(96), bold=True, color=RGBColor(0x30, 0x30, 0x50), align=PP_ALIGN.LEFT)
    txt(slide, spec.get("title", ""),
        Inches(0.5), Inches(2.8), Inches(12), Inches(0.9),
        size=Pt(38), bold=True, color=T["white"])
    if spec.get("subtitle"):
        box(slide, Inches(0.5), Inches(3.8), Inches(1.8), Pt(3), fill=T["orange"])
        txt(slide, spec["subtitle"], Inches(0.5), Inches(3.95), Inches(10), Inches(0.4),
            size=Pt(16), color=T["mid_gray"])
    footer(slide, meta)


def build_bullets(prs, spec, meta):
    slide = blank_slide(prs)
    box(slide, 0, 0, W, H, fill=T["white"])
    header(slide, spec.get("title", ""), spec.get("subtitle"))
    footer(slide, meta)
    bullets = spec.get("bullets", [])
    top = Inches(1.35)
    for i, b in enumerate(bullets[:10]):
        y = top + Inches(0.58) * i
        box(slide, Inches(0.45), y + Inches(0.14), Inches(0.22), Inches(0.22), fill=T["orange"])
        txt(slide, b, Inches(0.82), y, Inches(11.9), Inches(0.55),
            size=Pt(14), color=T["text"])


def build_two_col(prs, spec, meta):
    slide = blank_slide(prs)
    box(slide, 0, 0, W, H, fill=T["white"])
    header(slide, spec.get("title", ""))
    footer(slide, meta)
    left  = spec.get("left",  {})
    right = spec.get("right", {})
    for col_idx, col in enumerate([left, right]):
        x = Inches(0.4) + Inches(6.5) * col_idx
        box(slide, x, Inches(1.3), Inches(6.2), Inches(5.65),
            fill=T["off_white"], line=T["light_gray"], lw=Pt(1))
        box(slide, x, Inches(1.3), Inches(6.2), Inches(0.5), fill=T["dark"])
        txt(slide, col.get("heading", ""), x + Inches(0.15), Inches(1.33),
            Inches(5.9), Inches(0.45), size=Pt(14), bold=True, color=T["white"])
        for i, b in enumerate(col.get("bullets", [])[:8]):
            y = Inches(1.95) + Inches(0.58) * i
            box(slide, x + Inches(0.15), y + Inches(0.14),
                Inches(0.18), Inches(0.18), fill=T["orange"])
            txt(slide, b, x + Inches(0.44), y, Inches(5.6), Inches(0.55),
                size=Pt(13), color=T["text"])


def build_stat_row(prs, spec, meta):
    slide = blank_slide(prs)
    box(slide, 0, 0, W, H, fill=T["white"])
    header(slide, spec.get("title", ""))
    footer(slide, meta)
    stats = spec.get("stats", [])[:4]
    n    = len(stats)
    bw   = (Inches(12.5)) / n
    pad  = Inches(0.2)
    for i, s in enumerate(stats):
        x = Inches(0.4) + bw * i
        c = COLOR_MAP.get(s.get("color", "default"), T["orange"])
        box(slide, x + pad, Inches(1.5), bw - pad * 2, Inches(4.2),
            fill=T["off_white"], line=c, lw=Pt(2))
        box(slide, x + pad, Inches(1.5), bw - pad * 2, Pt(4), fill=c)
        txt(slide, s.get("value", ""),
            x + pad, Inches(2.1), bw - pad * 2, Inches(1.4),
            size=Pt(52), bold=True, color=c, align=PP_ALIGN.CENTER)
        txt(slide, s.get("label", ""),
            x + pad, Inches(3.55), bw - pad * 2, Inches(0.5),
            size=Pt(14), color=T["text"], align=PP_ALIGN.CENTER)
        if s.get("sub"):
            txt(slide, s["sub"], x + pad, Inches(4.1), bw - pad * 2, Inches(0.4),
                size=Pt(11), color=T["mid_gray"], align=PP_ALIGN.CENTER)


def build_table(prs, spec, meta):
    slide = blank_slide(prs)
    box(slide, 0, 0, W, H, fill=T["white"])
    header(slide, spec.get("title", ""))
    footer(slide, meta)
    headers = spec.get("headers", [])
    rows    = spec.get("rows", [])
    if not headers: return
    n_cols  = len(headers)
    col_w   = Inches(12.5) / n_cols
    row_h   = Inches(0.48)
    top     = Inches(1.3)
    box(slide, Inches(0.4), top, Inches(12.5), row_h, fill=T["dark"])
    for j, h in enumerate(headers):
        txt(slide, h, Inches(0.45) + col_w * j, top + Pt(4),
            col_w - Inches(0.1), row_h,
            size=Pt(11), bold=True, color=T["white"])
    for i, row in enumerate(rows[:14]):
        y  = top + row_h * (i + 1)
        bg = T["off_white"] if i % 2 == 0 else T["white"]
        box(slide, Inches(0.4), y, Inches(12.5), row_h, fill=bg)
        for j, cell in enumerate(row[:n_cols]):
            cell_str = str(cell)
            cell_color = T["text"]
            if any(x in cell_str for x in ["🟢", "✅", "Ahead", "Done"]):
                cell_color = T["green"]
            elif any(x in cell_str for x in ["🔴", "❌", "Behind", "Off"]):
                cell_color = T["red"]
            elif any(x in cell_str for x in ["🟡", "⚠️", "At Risk"]):
                cell_color = T["yellow"]
            txt(slide, cell_str, Inches(0.45) + col_w * j, y + Pt(3),
                col_w - Inches(0.1), row_h,
                size=Pt(11), color=cell_color,
                bold=(j == 0))


def build_cards(prs, spec, meta):
    slide = blank_slide(prs)
    box(slide, 0, 0, W, H, fill=T["white"])
    header(slide, spec.get("title", ""))
    footer(slide, meta)
    cards = spec.get("cards", [])[:4]
    n    = len(cards)
    cw   = Inches(12.5) / n
    pad  = Inches(0.2)
    for i, c in enumerate(cards):
        x = Inches(0.4) + cw * i
        box(slide, x + pad, Inches(1.35), cw - pad * 2, Inches(5.5),
            fill=T["off_white"], line=T["light_gray"], lw=Pt(1))
        box(slide, x + pad, Inches(1.35), cw - pad * 2, Pt(4), fill=T["orange"])
        txt(slide, c.get("icon", ""), x + pad, Inches(1.5),
            cw - pad * 2, Inches(0.8),
            size=Pt(32), align=PP_ALIGN.CENTER)
        txt(slide, c.get("title", ""), x + pad, Inches(2.4),
            cw - pad * 2, Inches(0.5),
            size=Pt(14), bold=True, color=T["text"], align=PP_ALIGN.CENTER)
        box(slide, x + pad + Inches(0.6), Inches(2.95),
            cw - pad * 2 - Inches(1.2), Pt(2), fill=T["orange"])
        txt(slide, c.get("body", ""), x + pad + Inches(0.1), Inches(3.1),
            cw - pad * 2 - Inches(0.2), Inches(3.4),
            size=Pt(12), color=T["text"], align=PP_ALIGN.CENTER)


def build_timeline(prs, spec, meta):
    slide = blank_slide(prs)
    box(slide, 0, 0, W, H, fill=T["white"])
    header(slide, spec.get("title", ""))
    footer(slide, meta)
    steps  = spec.get("steps", [])[:5]
    n      = len(steps)
    if not n: return
    sw     = Inches(12.5) / n
    pad    = Inches(0.25)
    mid_y  = Inches(3.8)
    line_y = mid_y + Inches(0.18)
    box(slide, Inches(0.4), line_y, Inches(12.5), Pt(3), fill=T["mid_gray"])
    status_colors = {"done": T["green"], "active": T["orange"], "upcoming": T["mid_gray"]}
    for i, step in enumerate(steps):
        x  = Inches(0.4) + sw * i
        cx = x + sw / 2
        sc = status_colors.get(step.get("status", "upcoming"), T["mid_gray"])
        box(slide, cx - Inches(0.28), mid_y, Inches(0.55), Inches(0.55),
            fill=sc, line=T["white"], lw=Pt(2))
        if step.get("status") == "done":
            txt(slide, "✓", cx - Inches(0.28), mid_y, Inches(0.55), Inches(0.55),
                size=Pt(14), bold=True, color=T["white"], align=PP_ALIGN.CENTER)
        txt(slide, step.get("phase", ""), cx - sw/2 + pad, Inches(1.5),
            sw - pad * 2, Inches(0.35), size=Pt(11), bold=True,
            color=sc, align=PP_ALIGN.CENTER)
        txt(slide, step.get("title", ""), cx - sw/2 + pad, Inches(1.9),
            sw - pad * 2, Inches(0.5), size=Pt(14), bold=True,
            color=T["text"], align=PP_ALIGN.CENTER)
        txt(slide, step.get("dates", ""), cx - sw/2 + pad, Inches(4.55),
            sw - pad * 2, Inches(0.35), size=Pt(11),
            color=T["mid_gray"], align=PP_ALIGN.CENTER)
        if step.get("detail"):
            txt(slide, step["detail"], cx - sw/2 + pad, Inches(2.5),
                sw - pad * 2, Inches(1.1), size=Pt(11),
                color=T["text"], align=PP_ALIGN.CENTER)


def build_closing(prs, spec, meta):
    slide = blank_slide(prs)
    box(slide, 0, 0, W, H, fill=T["dark"])
    box(slide, 0, 0, Inches(0.18), H, fill=T["orange"])
    for i in range(0, 14):
        box(slide, Inches(i), 0, Pt(0.5), H, fill=RGBColor(0x28, 0x28, 0x40))
    txt(slide, spec.get("title", "Thank You"),
        Inches(0.5), Inches(1.8), Inches(12.3), Inches(1.2),
        size=Pt(52), bold=True, color=T["white"], align=PP_ALIGN.CENTER)
    if spec.get("message"):
        box(slide, Inches(4.5), Inches(3.2), Inches(4.3), Pt(3), fill=T["orange"])
        txt(slide, spec["message"], Inches(0.5), Inches(3.4), Inches(12.3), Inches(0.6),
            size=Pt(20), color=T["orange"], align=PP_ALIGN.CENTER)
    if spec.get("contact"):
        txt(slide, spec["contact"], Inches(0.5), Inches(4.2), Inches(12.3), Inches(0.4),
            size=Pt(14), color=T["mid_gray"], align=PP_ALIGN.CENTER)
    txt(slide, meta.get("date", ""), Inches(0.5), Inches(6.8), Inches(12.3), Inches(0.35),
        size=Pt(11), color=T["mid_gray"], align=PP_ALIGN.CENTER)


# ── BUILDER REGISTRY ─────────────────────────────────────────────────────────

BUILDERS = {
    "cover":    build_cover,
    "agenda":   build_agenda,
    "section":  build_section,
    "bullets":  build_bullets,
    "two_col":  build_two_col,
    "stat_row": build_stat_row,
    "table":    build_table,
    "cards":    build_cards,
    "timeline": build_timeline,
    "closing":  build_closing,
}

# ── MAIN ─────────────────────────────────────────────────────────────────────

def main():
    spec_path = os.path.join(os.path.dirname(__file__), "current_spec.json")
    with open(spec_path) as f:
        spec = json.load(f)

    meta = {k: spec.get(k, "") for k in ["title", "subtitle", "presenter", "date", "deck_type"]}
    prs  = new_prs()

    built = 0
    skipped = []
    for slide_spec in spec.get("slides", []):
        stype = slide_spec.get("type", "")
        if stype in BUILDERS:
            BUILDERS[stype](prs, slide_spec, meta)
            built += 1
        else:
            skipped.append(stype)

    filename = spec.get("output_filename", "deck_output.pptx")
    out_dir  = os.path.join(os.path.dirname(__file__), "../../exports")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, filename)
    prs.save(out_path)

    abs_path = os.path.abspath(out_path)
    print(f"✅  {built} slides built → {abs_path}")
    if skipped:
        print(f"⚠️  Unknown slide types skipped: {skipped}")

if __name__ == "__main__":
    main()

PYTHON_ENGINE

ok "deck-builder engine installed → $AGENT_DIR/generate_deck.py"

# ── STEP 7: CONNECT MICROSOFT 365 MCP ────────────────────────────────────────
step "Microsoft 365 (SharePoint) — action required"

echo ""
echo -e "  ${ORANGE}${BOLD}Both skills need SharePoint access to search your team's docs.${NC}"
echo -e "  To connect it:"
echo -e "  ${BOLD}  1. Open Claude Code${NC}"
echo -e "  ${BOLD}  2. Type: /mcp${NC}"
echo -e "  ${BOLD}  3. Select: claude.ai Microsoft 365${NC}"
echo -e "  ${BOLD}  4. Sign in with your UiPath Microsoft account${NC}"
echo ""

# ── DONE ─────────────────────────────────────────────────────────────────────
echo -e "${ORANGE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}  Installation complete! 🎉${NC}"
echo -e "${ORANGE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  Installed skills:"
echo -e "  ${GREEN}✅  /qbr-prep${NC}     — QBR draft generator"
echo -e "  ${GREEN}✅  /deck-builder${NC}  — Presentation factory (any deck type → PPTX)"
echo ""
echo -e "  Skills location: ${BOLD}$COMMANDS_DIR${NC}"
echo -e "  Deck engine:     ${BOLD}$AGENT_DIR${NC}"
echo -e "  Exports go to:   ${BOLD}$EXPORTS_DIR${NC}"
echo ""
echo -e "  ${BOLD}To get started:${NC}"
echo -e "  1. Open Claude Code"
echo -e "  2. Connect Microsoft 365 MCP (see above)"
echo -e "  3. Type ${ORANGE}/qbr-prep${NC} or ${ORANGE}/deck-builder${NC}"
echo ""
echo -e "  Questions? Contact ${BOLD}mihai.gavan@uipath.com${NC}"
echo ""
