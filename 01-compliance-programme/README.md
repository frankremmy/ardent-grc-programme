# 01 — Compliance programme: scope, SoA and gap plan

**Artefact:** [`ardent-iso27001-soa-matrix.xlsx`](ardent-iso27001-soa-matrix.xlsx) · Google Sheet: *link to be added*

Five sheets: Read me · Scope · SoA matrix (93 controls) · Summary (live formulas) · Action plan (63 actions)

## Compliance goal (the one-page summary)

**Scope.** The ISMS covers development, operation and support of the Ardent Ledger platform on AWS (eu-west-1, eu-central-1), plus the people, processes and corporate SaaS behind it, run from the Mosta office and by remote staff. AWS data-centre controls are inherited and evidenced through AWS's own SOC 2 and ISO 27001 reports. The marketing site and customers' own devices are out of scope.

**Goal.** ISO 27001 Stage 1 by Q2 2027. SOC 2 Type I in the same quarter, with the Type II observation window opening in Q3 2027. Before Stage 1, the implementation score should reach at least 80%.

**Where Ardent stands today (7 November 2026):**

| Theme | Applicable | Implemented | Partial | Planned | Score |
|---|---|---|---|---|---|
| Organisational (5.x) | 37 | 4 | 22 | 11 | 40.5% |
| People (6.x) | 8 | 4 | 4 | 0 | 75.0% |
| Physical (7.x) | 13 | 9 | 4 | 0 | 84.6% |
| Technological (8.x) | 32 | 10 | 14 | 8 | 53.1% |
| **Total** | **90** | **27** | **44** | **19** | **54.4%** |

The score counts Partial as half. That leaves a gap of 25.6 points to the target, and 63 controls still to close.

**What the numbers say:**
- **The technology is ahead of the governance.** Engineering has built encryption, SSO, MFA, infrastructure as code and multi-AZ databases. What's missing is mostly organisational: an approved policy, classification, supplier security, incident procedures, independent review. Those are cheap to fix and auditors check them first.
- **The physical score is high because there's little to protect.** Customer data lives only in AWS. A strong 7.x score here doesn't say much about risk, and I wouldn't present it as an achievement.
- **The P1 actions are where risk is concentrated:** long-lived AWS keys (5.17, 8.2), no security monitoring (8.15, 8.16), untested backups in the same account (8.13), production data copied into staging (8.11, 8.33), and no vulnerability SLA (8.8). Each links to a high-rated risk in the register.

## How I built it

1. **Scope first.** I wrote the scope with its interfaces and dependencies before touching a control. An Annex A row can't be judged without knowing where the boundary is.
2. **One row per control, with a reason.** Every applicable control cites the risk it treats, or states that it's a baseline expectation. An auditor can follow each row back to a risk, which is the clause 6.1.3 chain: scope → risk → treatment → SoA.
3. **Evidence-based status.** "Implemented" means it's operating *and* evidenced. Anything working but not provable is "Partial". This is what an internal auditor will test.
4. **Few exclusions, each checked against the rest of the matrix:**
   - **7.6 Working in secure areas.** Ardent has no secure areas, because all customer data sits in AWS.
   - **8.23 Web filtering.** There's no corporate network to filter. The risk is treated through EDR web protection (8.7) and awareness training (6.3).
   - **8.30 Outsourced development.** Ardent has used no external developers in 24 months.

   Each exclusion has a re-assessment trigger. I checked every exclusion against the other rows so the SoA doesn't contradict itself. In my [GRC Mastery clause 6 notes](https://github.com/frankremmy/grc-mastery/blob/main/modules/12-iso27001-lead-auditor/12-clause-6.md) I found that kind of contradiction in an SoA. Here I designed against it.
5. **Crosswalk.** Each control carries an indicative SOC 2 Trust Services Criterion and a NIST CSF 2.0 subcategory. One piece of evidence then serves both audits. Project 05 tests the SOC 2 side on real AWS settings.

## Decisions an interviewer might ask about

- **Why 54% and not a flattering number?** A score built on "Partial = half" is honest about controls that exist but can't yet be shown to an auditor. The gap to 80% is the work plan.
- **Why AWS controls are "inherited" and not "N/A".** The controls still apply. AWS operates them, and Ardent keeps AWS's reports as evidence. Marking them N/A would hide a dependency the certification body will ask about.
- **The action plan's priority logic.** P1 means the action treats a high-rated risk. P2 means planned but lower risk. P3 means partial and lower risk. It's simple on purpose, so an action can't be ranked by whoever argues loudest.

Control titles follow ISO/IEC 27001:2022 Annex A, and the control text isn't reproduced. The crosswalk is my own indicative mapping, not an official one.
