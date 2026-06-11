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
data-driven Quarterly Business Review (QBR) document for a UiPath partner.

The user may have provided context via: $ARGUMENTS

---

## STEP 1 — COLLECT INPUTS

If the user has not already provided the information below, ask for it now in a single, clean prompt.
Do not ask one question at a time. Present all questions together.

Required inputs:
- **Partner name** (company name)
- **Partner tier** — Strategic / Premier / Select
- **Quarter & Fiscal Year** (e.g. Q2 FY27)
- **Partner region** — AMER / EMEA / LATAM / APJ
- **Your name** (PSM running the QBR)
- **Any data you have** — paste metrics, pipeline numbers, certifications, support tickets, wins,
  challenges, anything. Raw is fine. More = better output.
- **(Optional)** Executive sponsor or key contacts at the partner
- **(Optional)** Any specific focus areas or asks for this QBR

If $ARGUMENTS already contains some of this, use it and only ask for what is genuinely missing.

---

## STEP 2 — SEARCH SHAREPOINT FOR PARTNER CONTEXT

Once you have the partner name, automatically search SharePoint for relevant documents using the
Microsoft 365 MCP tools. Run the following searches (do not ask permission — just do it):

1. Search for documents containing the partner name to find past QBRs, account plans, or notes
2. Search for "QBR template" or "partner scorecard" to retrieve the latest standard format
3. Search for any delivery model or program plan docs relevant to their tier

Summarize what you found in one sentence before generating the QBR (e.g. "Found 3 relevant docs —
pulled in deal data from X and certification status from Y.")

If nothing is found for the partner, say so briefly and proceed with the data the user provided.

---

## STEP 3 — GENERATE THE QBR DOCUMENT

Produce a complete, polished QBR document using the structure below.

**Tone:** Executive-ready. Confident. Data-first. No fluff. Every section should lead with a
specific number or outcome before adding context. Write as if the PSM is presenting to the
partner's leadership team AND their own VP of Partner Success.

**Format:** Use headers, tables, and bullet points. Make it visually scannable. Use RAG status
indicators (🟢 On Track / 🟡 At Risk / 🔴 Off Track) for all KPIs.

---

# QUARTERLY BUSINESS REVIEW
## [PARTNER NAME] · [QUARTER FY__] · [REGION]
**PSM:** [Your name] · **Date:** [Today's date] · **Tier:** [Strategic / Premier / Select]

---

### EXECUTIVE SUMMARY

Write 3–4 sentences that answer: What was the headline this quarter? What is the state of the
relationship? What is the single most important thing to resolve or accelerate next quarter?

Include a **Relationship Health** indicator: 🟢 Strong / 🟡 Stable / 🔴 Needs Attention

---

### PARTNER HEALTH SCORECARD

Produce a table with all applicable KPIs from the UiPath Partner Success framework.
Fill in actuals from user-provided data. Mark unknowns as "Data needed" — never invent numbers.
Add a RAG status for each.

| KPI | Target | Actual | Status | Trend |
|-----|--------|--------|--------|-------|
| Partner Churn Risk | Low | [actual] | 🟢/🟡/🔴 | ↑/→/↓ |
| Net Revenue Retention (NRR) | +10% YoY | [actual] | 🟢/🟡/🔴 | ↑/→/↓ |
| Technical Health Score | >85% | [actual] | 🟢/🟡/🔴 | ↑/→/↓ |
| Partner-Sourced Pipeline | +25% YoY | [actual] | 🟢/🟡/🔴 | ↑/→/↓ |
| Agentic Certifications | +50% YoY | [actual] | 🟢/🟡/🔴 | ↑/→/↓ |
| Migration Success Rate | 90%+ | [actual] | 🟢/🟡/🔴 | ↑/→/↓ |
| RSI Competency Growth | +20% YoY | [actual] | 🟢/🟡/🔴 | ↑/→/↓ |
| Support Health (P1/P2 SLA) | >95% | [actual] | 🟢/🟡/🔴 | ↑/→/↓ |

Add or remove rows based on what's applicable to the partner's tier.

---

### PERFORMANCE REVIEW — [QUARTER]

#### Revenue & Pipeline
- Partner-sourced ARR this quarter: [value]
- Influenced pipeline: [value]
- Co-sell deals closed: [number] · Avg deal size: [value]
- Key wins: [list]

#### Agentic Adoption & Enablement
- Agentic certifications completed: [number] · Total certified: [number]
- Agentic delivery projects completed / in-flight: [details]
- Vertical specialization areas: [list]
- Academy completion rate: [%]

#### Technical Health
- Active UiPath environments managed: [number]
- Migrations completed this quarter: [number] · Success rate: [%]
- Critical architectural risks identified: [list or "None"]

#### Support & Escalations
- P1 tickets: [number] · Avg resolution time: [hours]
- P2 tickets: [number] · Avg resolution time: [hours]
- Open escalations: [number] · Summary: [details or "None"]
- Support satisfaction score: [value]

---

### STRATEGIC ALIGNMENT — FY28/29 MOTIONS

Map the partner to the UiPath FY28/29 commercial motions. Be specific about where they play
and where the gaps are.

**Motion 1 — Install-Base Extension** (CoE-to-LOB at scale)
- Partner's current involvement: [describe]
- Opportunity / gap: [describe]

**Motion 2 — Vertical Solutions** (commercial-segment economics)
- Verticals where partner leads: [list]
- Targeted verticals for FY27 growth: [list]

**Motion 3 — Test Cloud / Dark Factory** (autonomous testing)
- Partner's test practice maturity: [assess]
- Re-skilling or agentic pivot needed: [yes/no + detail]

**Artifact Contribution**
- Artifacts contributed to library this quarter: [number]
- Reuse rate from library: [%] · Target: ≥60%

---

### JOINT WINS & HIGHLIGHTS

List 2–5 concrete wins from the quarter. Each should have: what happened, business impact,
and the partner team/individual responsible.

1. **[Win title]** — [description] → Impact: [metric or outcome]
2. ...

---

### CHALLENGES & RISKS

| # | Challenge | Impact | Owner | Status |
|---|-----------|--------|-------|--------|
| 1 | [description] | High/Med/Low | UiPath / Partner / Joint | Open/Resolved |
| 2 | ... | | | |

---

### JOINT ACTION PLAN — NEXT 90 DAYS

Generate a concrete action plan. Every item must have an owner and a date.
Group by priority: Must Do → Should Do → Nice to Have.

**MUST DO (commits this meeting)**
| # | Action | Owner | Due Date | Success Metric |
|---|--------|-------|----------|----------------|
| 1 | | | | |

**SHOULD DO (next 60 days)**
| # | Action | Owner | Due Date | Success Metric |
|---|--------|-------|----------|----------------|
| 1 | | | | |

---

### COMMITMENTS

**UiPath commits to:**
- [List 2–4 specific, time-bound commitments from UiPath side]

**[Partner Name] commits to:**
- [List 2–4 specific, time-bound commitments from partner side]

---

### NEXT QBR

**Date:** [Suggest a date ~90 days out]
**Pre-read due:** [1 week before]
**Exec sponsor:** [name if known]
**Key agenda focus:** [based on action plan priorities]

---

## STEP 4 — POST-GENERATION OPTIONS

After generating the QBR, offer the user these follow-up options:

1. **Export-ready** — Reformat as a bulleted list optimised for copying into PowerPoint slides
2. **Email version** — Generate a pre-read email to send to the partner before the meeting
3. **Exec brief** — Generate a 1-page internal summary for the VP of Partner Success
4. **Action items only** — Extract just the joint action plan as a clean task list
5. **Save to SharePoint** — Offer to search for the right folder and save the draft there

Present these as a numbered menu the user can pick from.
SKILL_QBR

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
UiPath Partner Success — Deck Builder Engine v1.0
Usage: python3 generate_deck.py  (reads current_spec.json in same directory)
"""
import json, sys, os
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN

T = {
    "orange":     RGBColor(0xFA,0x46,0x16), "dark":      RGBColor(0x1C,0x1C,0x2E),
    "dark_card":  RGBColor(0x2A,0x2A,0x42), "white":     RGBColor(0xFF,0xFF,0xFF),
    "off_white":  RGBColor(0xF5,0xF5,0xF7), "mid_gray":  RGBColor(0x88,0x88,0xAA),
    "light_gray": RGBColor(0xF0,0xF0,0xF5), "text":      RGBColor(0x1A,0x1A,0x2E),
    "green":      RGBColor(0x2E,0xCC,0x71), "yellow":    RGBColor(0xF3,0x9C,0x12),
    "red":        RGBColor(0xE7,0x4C,0x3C), "blue":      RGBColor(0x34,0x98,0xDB),
    "orange_bg":  RGBColor(0xFF,0xEE,0xE8),
}
COLOR_MAP = {"green":T["green"],"orange":T["orange"],"blue":T["blue"],"red":T["red"],"default":T["orange"]}
W,H = Inches(13.33),Inches(7.5)

def new_prs():
    p=Presentation(); p.slide_width=W; p.slide_height=H; return p

def blank(prs): return prs.slides.add_slide(prs.slide_layouts[6])

def box(s,x,y,w,h,fill=None,line=None,lw=Pt(0)):
    sh=s.shapes.add_shape(1,x,y,w,h); sh.line.fill.background()
    if fill: sh.fill.solid(); sh.fill.fore_color.rgb=fill
    else: sh.fill.background()
    if line: sh.line.color.rgb=line; sh.line.width=lw
    else: sh.line.fill.background()
    return sh

def txt(s,text,x,y,w,h,size=Pt(13),bold=False,color=None,align=PP_ALIGN.LEFT,wrap=True,italic=False):
    color=color or T["text"]
    tb=s.shapes.add_textbox(x,y,w,h); tf=tb.text_frame; tf.word_wrap=wrap
    p=tf.paragraphs[0]; p.alignment=align; r=p.add_run(); r.text=text
    r.font.size=size; r.font.bold=bold; r.font.italic=italic; r.font.color.rgb=color
    return tb

def hdr(s,title,sub=None):
    box(s,0,0,W,Inches(1.1),fill=T["dark"]); box(s,0,Inches(1.1),W,Pt(4),fill=T["orange"])
    txt(s,title,Inches(0.45),Inches(0.15),Inches(10),Inches(0.6),size=Pt(26),bold=True,color=T["white"])
    if sub: txt(s,sub,Inches(0.45),Inches(0.7),Inches(11),Inches(0.35),size=Pt(12),color=T["mid_gray"])

def ftr(s,m):
    box(s,0,Inches(7.18),W,Inches(0.32),fill=T["dark"])
    txt(s,f"{m.get('deck_type','')}  ·  {m.get('title','')}  ·  {m.get('date','')}  ·  CONFIDENTIAL — UiPath Internal",
        Inches(0.35),Inches(7.19),Inches(12.5),Inches(0.3),size=Pt(8),color=T["mid_gray"])

def build_cover(prs,spec,m):
    s=blank(prs); box(s,0,0,W,H,fill=T["dark"])
    box(s,0,Inches(3.0),W,Pt(5),fill=T["orange"]); box(s,0,Inches(5.1),W,Pt(5),fill=T["orange"])
    for i in range(14): box(s,Inches(i),0,Pt(0.5),H,fill=RGBColor(0x28,0x28,0x40))
    txt(s,m.get("deck_type","").upper(),Inches(1),Inches(0.9),Inches(11),Inches(0.4),size=Pt(13),bold=True,color=T["orange"],align=PP_ALIGN.CENTER)
    txt(s,m["title"],Inches(0.5),Inches(1.4),Inches(12.3),Inches(1.1),size=Pt(44),bold=True,color=T["white"],align=PP_ALIGN.CENTER)
    if m.get("subtitle"): txt(s,m["subtitle"],Inches(0.5),Inches(2.6),Inches(12.3),Inches(0.6),size=Pt(22),color=T["orange"],align=PP_ALIGN.CENTER)
    box(s,Inches(4.5),Inches(3.2),Inches(4.3),Pt(2),fill=T["mid_gray"])
    if m.get("presenter"): txt(s,m["presenter"],Inches(0.5),Inches(3.5),Inches(12.3),Inches(0.45),size=Pt(15),color=T["white"],align=PP_ALIGN.CENTER)
    if m.get("date"): txt(s,m["date"],Inches(0.5),Inches(3.95),Inches(12.3),Inches(0.4),size=Pt(13),color=T["mid_gray"],align=PP_ALIGN.CENTER)

def build_agenda(prs,spec,m):
    s=blank(prs); box(s,0,0,W,H,fill=T["white"]); hdr(s,spec.get("title","Agenda")); ftr(s,m)
    items=spec.get("items",[]); cols=2 if len(items)>5 else 1; chunk=(len(items)+1)//2 if cols==2 else len(items)
    for idx,item in enumerate(items):
        col=idx//chunk; row=idx%chunk; x=Inches(0.5)+Inches(6.4)*col; y=Inches(1.5)+Inches(0.82)*row
        box(s,x,y,Inches(0.55),Inches(0.55),fill=T["orange"])
        txt(s,str(idx+1),x,y,Inches(0.55),Inches(0.55),size=Pt(18),bold=True,color=T["white"],align=PP_ALIGN.CENTER)
        txt(s,item,x+Inches(0.65),y+Inches(0.08),Inches(5.6),Inches(0.55),size=Pt(15),bold=True,color=T["text"])

def build_section(prs,spec,m):
    s=blank(prs); box(s,0,0,W,H,fill=T["dark"]); box(s,0,0,Inches(0.18),H,fill=T["orange"])
    for i in range(14): box(s,Inches(i),0,Pt(0.5),H,fill=RGBColor(0x28,0x28,0x40))
    num=spec.get("number","")
    if num: txt(s,num,Inches(0.4),Inches(1.8),Inches(3),Inches(1.8),size=Pt(96),bold=True,color=RGBColor(0x30,0x30,0x50))
    txt(s,spec.get("title",""),Inches(0.5),Inches(2.8),Inches(12),Inches(0.9),size=Pt(38),bold=True,color=T["white"])
    if spec.get("subtitle"):
        box(s,Inches(0.5),Inches(3.8),Inches(1.8),Pt(3),fill=T["orange"])
        txt(s,spec["subtitle"],Inches(0.5),Inches(3.95),Inches(10),Inches(0.4),size=Pt(16),color=T["mid_gray"])
    ftr(s,m)

def build_bullets(prs,spec,m):
    s=blank(prs); box(s,0,0,W,H,fill=T["white"]); hdr(s,spec.get("title",""),spec.get("subtitle")); ftr(s,m)
    for i,b in enumerate(spec.get("bullets",[])[:10]):
        y=Inches(1.35)+Inches(0.58)*i
        box(s,Inches(0.45),y+Inches(0.14),Inches(0.22),Inches(0.22),fill=T["orange"])
        txt(s,b,Inches(0.82),y,Inches(11.9),Inches(0.55),size=Pt(14),color=T["text"])

def build_two_col(prs,spec,m):
    s=blank(prs); box(s,0,0,W,H,fill=T["white"]); hdr(s,spec.get("title","")); ftr(s,m)
    for ci,col in enumerate([spec.get("left",{}),spec.get("right",{})]):
        x=Inches(0.4)+Inches(6.5)*ci
        box(s,x,Inches(1.3),Inches(6.2),Inches(5.65),fill=T["off_white"],line=T["light_gray"],lw=Pt(1))
        box(s,x,Inches(1.3),Inches(6.2),Inches(0.5),fill=T["dark"])
        txt(s,col.get("heading",""),x+Inches(0.15),Inches(1.33),Inches(5.9),Inches(0.45),size=Pt(14),bold=True,color=T["white"])
        for i,b in enumerate(col.get("bullets",[])[:8]):
            y=Inches(1.95)+Inches(0.58)*i
            box(s,x+Inches(0.15),y+Inches(0.14),Inches(0.18),Inches(0.18),fill=T["orange"])
            txt(s,b,x+Inches(0.44),y,Inches(5.6),Inches(0.55),size=Pt(13),color=T["text"])

def build_stat_row(prs,spec,m):
    s=blank(prs); box(s,0,0,W,H,fill=T["white"]); hdr(s,spec.get("title","")); ftr(s,m)
    stats=spec.get("stats",[])[:4]; n=len(stats); bw=Inches(12.5)/n; pad=Inches(0.2)
    for i,st in enumerate(stats):
        x=Inches(0.4)+bw*i; c=COLOR_MAP.get(st.get("color","default"),T["orange"])
        box(s,x+pad,Inches(1.5),bw-pad*2,Inches(4.2),fill=T["off_white"],line=c,lw=Pt(2))
        box(s,x+pad,Inches(1.5),bw-pad*2,Pt(4),fill=c)
        txt(s,st.get("value",""),x+pad,Inches(2.1),bw-pad*2,Inches(1.4),size=Pt(52),bold=True,color=c,align=PP_ALIGN.CENTER)
        txt(s,st.get("label",""),x+pad,Inches(3.55),bw-pad*2,Inches(0.5),size=Pt(14),color=T["text"],align=PP_ALIGN.CENTER)
        if st.get("sub"): txt(s,st["sub"],x+pad,Inches(4.1),bw-pad*2,Inches(0.4),size=Pt(11),color=T["mid_gray"],align=PP_ALIGN.CENTER)

def build_table(prs,spec,m):
    s=blank(prs); box(s,0,0,W,H,fill=T["white"]); hdr(s,spec.get("title","")); ftr(s,m)
    headers=spec.get("headers",[]); rows=spec.get("rows",[])
    if not headers: return
    nc=len(headers); cw=Inches(12.5)/nc; rh=Inches(0.48); top=Inches(1.3)
    box(s,Inches(0.4),top,Inches(12.5),rh,fill=T["dark"])
    for j,h in enumerate(headers): txt(s,h,Inches(0.45)+cw*j,top+Pt(4),cw-Inches(0.1),rh,size=Pt(11),bold=True,color=T["white"])
    for i,row in enumerate(rows[:14]):
        y=top+rh*(i+1); bg=T["off_white"] if i%2==0 else T["white"]
        box(s,Inches(0.4),y,Inches(12.5),rh,fill=bg)
        for j,cell in enumerate(row[:nc]):
            cs=str(cell); cc=T["text"]
            if any(x in cs for x in ["🟢","Ahead","Done"]): cc=T["green"]
            elif any(x in cs for x in ["🔴","Behind","Off"]): cc=T["red"]
            elif any(x in cs for x in ["🟡","At Risk"]): cc=T["yellow"]
            txt(s,cs,Inches(0.45)+cw*j,y+Pt(3),cw-Inches(0.1),rh,size=Pt(11),color=cc,bold=(j==0))

def build_cards(prs,spec,m):
    s=blank(prs); box(s,0,0,W,H,fill=T["white"]); hdr(s,spec.get("title","")); ftr(s,m)
    cards=spec.get("cards",[])[:4]; n=len(cards); cw=Inches(12.5)/n; pad=Inches(0.2)
    for i,c in enumerate(cards):
        x=Inches(0.4)+cw*i
        box(s,x+pad,Inches(1.35),cw-pad*2,Inches(5.5),fill=T["off_white"],line=T["light_gray"],lw=Pt(1))
        box(s,x+pad,Inches(1.35),cw-pad*2,Pt(4),fill=T["orange"])
        txt(s,c.get("icon",""),x+pad,Inches(1.5),cw-pad*2,Inches(0.8),size=Pt(32),align=PP_ALIGN.CENTER)
        txt(s,c.get("title",""),x+pad,Inches(2.4),cw-pad*2,Inches(0.5),size=Pt(14),bold=True,color=T["text"],align=PP_ALIGN.CENTER)
        box(s,x+pad+Inches(0.6),Inches(2.95),cw-pad*2-Inches(1.2),Pt(2),fill=T["orange"])
        txt(s,c.get("body",""),x+pad+Inches(0.1),Inches(3.1),cw-pad*2-Inches(0.2),Inches(3.4),size=Pt(12),color=T["text"],align=PP_ALIGN.CENTER)

def build_timeline(prs,spec,m):
    s=blank(prs); box(s,0,0,W,H,fill=T["white"]); hdr(s,spec.get("title","")); ftr(s,m)
    steps=spec.get("steps",[])[:5]; n=len(steps)
    if not n: return
    sw=Inches(12.5)/n; pad=Inches(0.25); mid_y=Inches(3.8); line_y=mid_y+Inches(0.18)
    box(s,Inches(0.4),line_y,Inches(12.5),Pt(3),fill=T["mid_gray"])
    sc_map={"done":T["green"],"active":T["orange"],"upcoming":T["mid_gray"]}
    for i,step in enumerate(steps):
        x=Inches(0.4)+sw*i; cx=x+sw/2; sc=sc_map.get(step.get("status","upcoming"),T["mid_gray"])
        box(s,cx-Inches(0.28),mid_y,Inches(0.55),Inches(0.55),fill=sc,line=T["white"],lw=Pt(2))
        if step.get("status")=="done": txt(s,"✓",cx-Inches(0.28),mid_y,Inches(0.55),Inches(0.55),size=Pt(14),bold=True,color=T["white"],align=PP_ALIGN.CENTER)
        txt(s,step.get("phase",""),cx-sw/2+pad,Inches(1.5),sw-pad*2,Inches(0.35),size=Pt(11),bold=True,color=sc,align=PP_ALIGN.CENTER)
        txt(s,step.get("title",""),cx-sw/2+pad,Inches(1.9),sw-pad*2,Inches(0.5),size=Pt(14),bold=True,color=T["text"],align=PP_ALIGN.CENTER)
        txt(s,step.get("dates",""),cx-sw/2+pad,Inches(4.55),sw-pad*2,Inches(0.35),size=Pt(11),color=T["mid_gray"],align=PP_ALIGN.CENTER)
        if step.get("detail"): txt(s,step["detail"],cx-sw/2+pad,Inches(2.5),sw-pad*2,Inches(1.1),size=Pt(11),color=T["text"],align=PP_ALIGN.CENTER)

def build_closing(prs,spec,m):
    s=blank(prs); box(s,0,0,W,H,fill=T["dark"]); box(s,0,0,Inches(0.18),H,fill=T["orange"])
    for i in range(14): box(s,Inches(i),0,Pt(0.5),H,fill=RGBColor(0x28,0x28,0x40))
    txt(s,spec.get("title","Thank You"),Inches(0.5),Inches(1.8),Inches(12.3),Inches(1.2),size=Pt(52),bold=True,color=T["white"],align=PP_ALIGN.CENTER)
    if spec.get("message"):
        box(s,Inches(4.5),Inches(3.2),Inches(4.3),Pt(3),fill=T["orange"])
        txt(s,spec["message"],Inches(0.5),Inches(3.4),Inches(12.3),Inches(0.6),size=Pt(20),color=T["orange"],align=PP_ALIGN.CENTER)
    if spec.get("contact"): txt(s,spec["contact"],Inches(0.5),Inches(4.2),Inches(12.3),Inches(0.4),size=Pt(14),color=T["mid_gray"],align=PP_ALIGN.CENTER)
    txt(s,m.get("date",""),Inches(0.5),Inches(6.8),Inches(12.3),Inches(0.35),size=Pt(11),color=T["mid_gray"],align=PP_ALIGN.CENTER)

BUILDERS={"cover":build_cover,"agenda":build_agenda,"section":build_section,"bullets":build_bullets,
           "two_col":build_two_col,"stat_row":build_stat_row,"table":build_table,
           "cards":build_cards,"timeline":build_timeline,"closing":build_closing}

def main():
    here=os.path.dirname(os.path.abspath(__file__))
    spec_path=os.path.join(here,"current_spec.json")
    with open(spec_path) as f: spec=json.load(f)
    meta={k:spec.get(k,"") for k in ["title","subtitle","presenter","date","deck_type"]}
    prs=new_prs(); built=0; skipped=[]
    for sl in spec.get("slides",[]):
        t=sl.get("type","")
        if t in BUILDERS: BUILDERS[t](prs,sl,meta); built+=1
        else: skipped.append(t)
    fn=spec.get("output_filename","deck_output.pptx")
    out_dir=os.path.join(here,"../../exports"); os.makedirs(out_dir,exist_ok=True)
    out=os.path.abspath(os.path.join(out_dir,fn)); prs.save(out)
    print(f"✅  {built} slides built → {out}")
    if skipped: print(f"⚠️  Unknown types skipped: {skipped}")

if __name__=="__main__": main()
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
