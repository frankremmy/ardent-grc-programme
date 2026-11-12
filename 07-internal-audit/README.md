# 07 — Internal audit IA-01

**Artefact:** [Internal Audit IA-01: plan, evidence record, findings, report and follow-up — Google Doc (view only)](https://docs.google.com/document/d/18-iXW48czF-Z6BYdcwlGGwNJjisB13ut430eCkeq8_A/edit?usp=sharing)

> Simulated engagement. The record structure (plan, opening meeting, evidence and sampling, findings, closing meeting, corrective action) is adapted from the GRC Mastery example audit records and used with the course owner's permission. **Every finding comes from cross-checking the artefacts in projects 01–05.** I didn't stage any of them. Where an artefact contradicted another, that contradiction became the finding.

## Result

**Well designed, not yet ready for Stage 1.** The audit raised 1 major nonconformity, 4 minor nonconformities, 3 opportunities for improvement and 2 good-practice notes.

| ID | Clause | Finding | Class | Follow-up (2027-01-15) |
|---|---|---|---|---|
| NC-01 | 9.3, 9.2.2 | No management review held and no audit programme | **Major** | Closed, implemented. Effectiveness check at the 2nd review |
| NC-02 | 5.2 | Information security policy still a v0.9 draft, not approved | Minor | Closed, effective |
| NC-03 | 6.1.3 d, 7.5.2 | SoA not updated after the IR plan was approved; still says "draft v0.5" | Minor | Closed, implemented |
| NC-04 | 7.5.2 | IR plan v1.1 changes have no recorded approval | Minor | Closed, effective |
| NC-05 | A.5.19–5.20 | Zendesk assessed after it was already in use; a "before go-live" condition date that had already passed | Minor | Open |
| OFI-1 | 6.1.3 | Traceability runs one way: 41/41 risk→control links trace, but 65 control→risk citations don't appear in treatment plans | OFI | — |
| OFI-2 | A.5.19 | 3 of 6 Tier 1 suppliers not yet assessed | OFI | — |
| OFI-3 | A.8.15–8.16 | Project 05 evidence comes from a sandbox, not production | OFI | — |

## How the findings were found

These are real inconsistencies between my own projects, caught by testing one artefact against another:

- **NC-03:** the SoA (project 01) still describes the IR plan as a draft, but project 04 shows it was approved three days after the SoA baseline.
- **NC-05:** the supplier assessment (project 03) sets a "before go-live" condition for a tool that the company profile and scope already list as in production.
- **T1 / OFI-1:** a script checked all 41 risk→control links between the risk register (project 02) and the SoA. All 41 trace. The reverse check found 65 links that only go one way.
- **T10:** the auditor *re-ran* the AWS evidence script (project 05) instead of inspecting the auditee's copy. Re-running the test is stronger evidence than reading someone else's results.
- **NC-01:** no project produced a management review or audit programme. That gap only shows up when you audit the whole system, not one project at a time.

## Decisions an interviewer might ask about

- **Why NC-01 is major and not minor.** Management review and the audit programme are required *processes*. If they're missing, clause 9 can't be shown to work at all. A certification body wouldn't recommend certification without them.
- **Independence.** The ISMS was built in the ISM's role, and an internal auditor can't audit their own work (9.2.2). So the audit is written from the role of a contracted auditor engaged by the CEO, and the document says this openly. I didn't paper over it.
- **A recorded disagreement.** The ISM argued that the SoA was "a point-in-time baseline" (NC-03). The finding was kept, because a baseline is only acceptable if the document says so and gets re-issued when things change. The disagreement is recorded in the closing meeting record. Fair presentation means the report shows the auditee's view as well as the auditor's.
- **Implemented vs effective.** Two of the closed findings are marked *implemented* rather than *effective*. One management review proves it happened, not that it works. Effectiveness will be checked at the next review.
