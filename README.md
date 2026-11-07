# Ardent Ledger — A GRC programme, built end to end

> **Simulated engagement.** Ardent Ledger Ltd is a fictional company. I wrote every document, register and finding here to show how I'd run governance, risk and compliance at a real SaaS business. Where I reused methods from my own earlier work, I link to it.

**The brief.** I join Ardent Ledger as its first Information Security Analyst. EU customers want ISO 27001 certification and US customers want a SOC 2 report. The company has good engineers, some security tooling and almost no governance. My job is to build the programme, prove it works, and be ready for the auditors.

Company profile: [`company-profile.md`](company-profile.md)

| # | Project | What it shows | Status |
|---|---|---|---|
| 01 | [Compliance programme](01-compliance-programme/) · [Sheet](https://docs.google.com/spreadsheets/d/1BPU_WZIlt40nkkxB_cDKS2JhUJ_UNFKknuPUtyj3yc4/edit?usp=sharing) | ISMS scope, Statement of Applicability covering all 93 Annex A controls, SOC 2 and NIST CSF 2.0 crosswalk, gap action plan | ☑ |
| 02 | Risk register | 15 risks scored and heat-mapped, residual risk, FAIR estimate for the top risk | ☐ |
| 03 | Vendor assessment | My own 25-question questionnaire, a scorecard and a supplier report | ☐ |
| 04 | Incident response and tabletop | IR plan, a tabletop on a leaked AWS key, incident report, GDPR Art. 33 decision | ☐ |
| 05 | SOC 2 controls on AWS | Trust Services Criteria mapped to real AWS settings, with CLI evidence | ☐ |
| 06 | Compliance dashboard | Coverage, risk, vendors, findings and remediation in one sheet | ☐ |
| 07 | Internal audit | An ISO 19011-style audit of projects 01–05: plan, evidence, findings, report, follow-up | ☐ |

The projects build on each other. The SoA links to the risk register, the audit samples the other projects, and the dashboard reads from all of them.

Related: [Kestrel Pay DevSecOps case](https://github.com/frankremmy/grc-mastery/tree/main/case-studies/kestrel-pay-devsecops) · [GRC Mastery notes](https://github.com/frankremmy/grc-mastery)
