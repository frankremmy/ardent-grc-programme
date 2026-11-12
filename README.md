# Ardent Ledger — A GRC programme, built end to end

> **Simulated engagement.** Ardent Ledger Ltd is a fictional company. I wrote every document, register and finding here to show how I'd run governance, risk and compliance at a real SaaS business. Where I reused methods from my own earlier work, I link to it.

**The brief.** I join Ardent Ledger as its first Information Security Analyst. EU customers want ISO 27001 certification and US customers want a SOC 2 report. The company has good engineers, some security tooling and almost no governance. My job is to build the programme, prove it works, and be ready for the auditors.

Company profile: [`company-profile.md`](company-profile.md)

| # | Project | What it shows | Status |
|---|---|---|---|
| 01 | [Compliance programme](01-compliance-programme/) · [Sheet](https://docs.google.com/spreadsheets/d/1BPU_WZIlt40nkkxB_cDKS2JhUJ_UNFKknuPUtyj3yc4/edit?usp=sharing) | ISMS scope, Statement of Applicability covering all 93 Annex A controls, SOC 2 and NIST CSF 2.0 crosswalk, gap action plan | ☑ |
| 02 | [Risk register](02-risk-register/) · [Sheet](https://docs.google.com/spreadsheets/d/11GxpylEPevgmE8XV62QuoAibNbC6H5lxfn0bI8CRsjo/edit?usp=sharing) | 15 risks with criteria, heat map (inherent and residual), linked SoA controls, FAIR on the top risk | ☑ |
| 03 | [Vendor assessment](03-vendor-assessment/) · [Sheet](https://docs.google.com/spreadsheets/d/1cTJYx1Pe84g7wE_XPOu2SiulBZT_EZQXCa9RaZAiPnI/edit?usp=sharing) | Supplier tiering, a 26-question weighted questionnaire, Zendesk scored from public evidence, approval conditions | ☑ |
| 04 | [Incident response and tabletop](04-incident-response/) · [Plan](https://docs.google.com/document/d/1LLZzONcNENcnrn1ZdpWsJJ8o0zdj9VRLMbrmsmXoKzc/edit?usp=sharing) · [Exercise](https://docs.google.com/document/d/17ro6JKg-mW8UctqNQYahEoc5ifCOoTP_XN6T1r5euJU/edit?usp=sharing) | IR plan v1.1, a 7-inject tabletop on a leaked AWS key, incident report, controller/processor GDPR decision, lessons fed back into the plan | ☑ |
| 05 | [SOC 2 controls on AWS](05-soc2-aws/) | 12 controls built in a real AWS account by script, mapped to SOC 2 TSC and ISO 27001, evidenced from AWS APIs: 11 PASS, 1 documented exception | ☑ |
| 06 | Compliance dashboard | Coverage, risk, vendors, findings and remediation in one sheet | ☐ |
| 07 | Internal audit | An ISO 19011-style audit of projects 01–05: plan, evidence, findings, report, follow-up | ☐ |

The projects build on each other. The SoA links to the risk register, the audit samples the other projects, and the dashboard reads from all of them.

Related: [Kestrel Pay DevSecOps case](https://github.com/frankremmy/grc-mastery/tree/main/case-studies/kestrel-pay-devsecops) · [GRC Mastery notes](https://github.com/frankremmy/grc-mastery)
