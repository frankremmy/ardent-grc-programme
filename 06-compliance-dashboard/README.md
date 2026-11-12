# 06 — Compliance dashboard

**Artefact:** [Ardent compliance dashboard — Google Sheet (view only)](https://docs.google.com/spreadsheets/d/1A9FSIm66tnDNsn0SyD0PrBKcHFIB-mJd2zOjZJPh3ws/edit?usp=sharing)

Sheets: Dashboard · Data - Controls · Data - Risks · Data - Assurance

> Simulated engagement (fictional company). Status as at 2027-01-15, after the internal audit follow-up.

## What management sees

| Tile | Value | Context |
|---|---|---|
| Implementation score | **60.0%** | Target 80% before Stage 1. Baseline was 54.4% |
| Open control actions | **57** | Baseline 63. The plan for January was 52, so actual is **5 behind plan** |
| High risks (residual) | **0** | 6 High before treatment |
| Tier 1 suppliers assessed | **3 / 6** | Zendesk: approve with conditions |
| Audit NCs open | **1 / 5** | The major (NC-01) is closed as implemented; its effectiveness is checked at the April review |
| TTX-01 lessons closed | **6 / 8** | Still open: removing IAM user keys and masking IBANs |
| SOC 2 lab controls passing | **11 / 12** | GuardDuty is a documented exception |
| Next milestone | **Stage 1, Q2 2027** | 20 points of score still to gain |

Charts: Annex A status by theme (stacked), the remediation burndown (plan vs actual), and risks by level (inherent vs residual). There's also a table of the top 6 risks with due dates.

## How it's built

- **Every number is a formula.** Tiles and charts read from three Data sheets. Those sheets hold dated snapshots taken from projects 01, 02, 03, 04, 05 and 07, each with its source noted. Update a Data sheet and the dashboard follows.
- **Plan against actual, not just a count.** The burndown shows Ardent is **5 actions behind plan** in January. A dashboard that only shows the current number hides that. This is the line a CTO would ask about first.
- **It shows how much remains, not only what's done.** Each tile shows a ratio or a target. For example, "1 / 5 NCs open" says more than "4 closed".
- **One honest caveat on the screen:** NC-01 is closed as *implemented*, not *effective*, because one management review doesn't prove the process works.

## Changes since the 2026-11-07 baseline

| Control | Was | Now | Why |
|---|---|---|---|
| 5.1 Policy | Partial | Implemented | Policy v1.0 approved (NC-02 closed) |
| 5.24 IR planning | Partial | Implemented | Plan v1.0/1.1 approved and exercised |
| 5.25 Event assessment | Planned | Implemented | Severity triggers in plan v1.1 |
| 5.26 Incident response | Partial | Implemented | Playbooks and record template |
| 5.27 Learning from incidents | Planned | Implemented | TTX-01 lessons tracked to closure |
| 5.35 Independent review | Planned | Implemented | Internal audit IA-01 |
| 5.36 Compliance checks | Planned | Partial | First quarterly check started |
