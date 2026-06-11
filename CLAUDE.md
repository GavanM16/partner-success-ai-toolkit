# Partner Success AI Toolkit — Claude Context

## Who we are
Partner Success team at UiPath. Building AI-native tooling using Claude Code to multiply team capacity.
Owner: Mihai Gavan (mihai.gavan@uipath.com)

## What this repo is
A collection of reusable Claude Code skills, agents, and templates for the Partner Success team.
All output should be grounded in real UiPath context pulled from SharePoint (see below).

## SharePoint
Site: GlobalPartnerEnablementNetwork
URL: https://uipath.sharepoint.com/sites/GlobalPartnerEnablementNetwork/Shared%20Documents
Key folders: `Team Internal/`, `# Programs/Partner Success/`, `# Programs/Partner Success/CSM/`
Always search SharePoint when building partner-facing content to use real templates and language.

## Project structure
```
ClaudeCode-PB/
├── CLAUDE.md          ← you are here
├── PLAN.md            ← roadmap and status
├── README.md          ← team onboarding guide
├── skills/            ← Claude Code slash command definitions
├── agents/            ← standalone agent workflows
├── templates/         ← partner-facing document templates
└── data/              ← sample/reference data
```

## Conventions
- Every skill file lives in `skills/` and is named `skill-name.md`
- Every agent has its own subfolder in `agents/` with a README
- Keep all output visual — use diagrams, tables, and status indicators
- Reference SharePoint docs when grounding partner content
