# 03 — Supplier security assessment: Zendesk

**Artefact:** [Ardent supplier assessment: Zendesk — Google Sheet (view only)](https://docs.google.com/spreadsheets/d/1cTJYx1Pe84g7wE_XPOu2SiulBZT_EZQXCa9RaZAiPnI/edit?usp=sharing)

Sheets: Read me · Tiering (10 suppliers) · Questionnaire (26 questions) · Scorecard (live) · Conditions (9)

> Ardent Ledger is fictional. **Zendesk is a real supplier.** Every answer comes from Zendesk's public security documentation or from public reporting as at 8 November 2026. Nothing came from Zendesk directly, so this is the desk review a TPRM analyst does before the questionnaire goes out. The questionnaire layout is adapted from the GRC Mastery TPRM template, used with the course owner's permission. The questions, scoring and analysis are my own.

## Assessment report (one page)

**Supplier:** Zendesk, the customer support platform. **Tier:** 1. Customers attach invoices and bank screenshots to support tickets, so ticket history is a second copy of customer financial data held outside Ardent's AWS. **Linked risk:** R-06, breach at a critical supplier.

**Result: 67% overall. Approve with conditions.**

| Domain | Weight | Score |
|---|---|---|
| Governance | 15% | 70% |
| Access control | 25% | 67% |
| Data protection | 25% | 67% |
| Incident response | 20% | 60% |
| Compliance | 15% | 75% |

Answers: 13 Yes · 9 Partial · 0 No · 4 Unknown. Evidence quality: 19 Documented · 6 Attested · 1 Verified.

**Strengths.** Zendesk has the certifications an EU customer would expect: ISO 27001, 27017, 27018 and 27701, plus an annual SOC 2 Type II. Encryption at rest and in transit is in place. SSO and IP restrictions are supported. Zendesk staff can only access Ardent's account when Ardent's admins allow it, and that access can be time-limited. Pen tests are annual and run by a third party.

**Concerns:**
1. **Agent accounts are the attack surface.** Native 2FA allows SMS, and API tokens bypass SSO. How tokens are scoped and rotated isn't documented.
2. **Two useful controls cost extra.** Customer-managed keys and data-access logs both sit in a paid add-on.
3. **The incident record is mixed.** In 2022, an SMS phishing campaign against Zendesk staff exposed some customers' service data, and the disclosure was criticised as vague. In 2024, an email-spoofing flaw in ticket collaboration was first rejected by the bug bounty as out of scope, then fixed.
4. **Four questions have no public answer:** sub-processor notice, API tokens, deletion on exit and breach-notice time. They score 0 until evidenced.

**Fourth-party lesson.** In 2025, Discord's support data was stolen through a third-party support provider that had access to Discord's Zendesk. The provider denied its systems were hacked. The point for Ardent is that the risk isn't only Zendesk's platform. It's also **everyone who can log into our instance**. Condition 7 bans outsourced agents unless they've been approved.

**Decision requested from Legal Counsel (R-06 owner):** approve, subject to these conditions:

| # | Condition | When |
|---|---|---|
| 1 | Make Google SSO mandatory for all agents, and turn off native passwords and SMS 2FA | Before go-live |
| 2 | Inventory and scope API tokens, rotate them every 90 days, and alert on token use from new IPs | Jan 2027 |
| 3 | Review the SOC 2 report and certificates, including exceptions and the complementary user-entity controls Ardent must run | Jan 2027 |
| 4 | Change the DPA: breach notice within 48h, deletion within 30 days of exit with confirmation, and a sub-processor list with change notice | Renewal |
| 5 | Confirm EU data location, and switch off features that process data outside the region | Jan 2027 |
| 6 | Turn on card redaction, keep no IBANs or full card numbers in tickets, and delete attachments after 90 days | Dec 2026 |
| 7 | Allow no outsourced or BPO agents without ISA approval and a separate assessment | Immediate |
| 8 | Decide on the paid add-on (customer-managed keys, data-access logs) | Mar 2027 |
| 9 | Re-assess annually and track certificate and report expiry dates | Nov 2027 |

## How I built it

1. **Tier first.** A one-page tiering rule sorts Ardent's 10 suppliers into three tiers. Tier 1 gets this level of review. Not every supplier gets 26 questions.
2. **Every question says why Ardent asks it.** That keeps the questionnaire tied to Ardent's risks and avoids a generic checklist. It's the gap I found in the client's own questionnaire during the [Horizon Labs assessment](https://github.com/frankremmy/grc-mastery/blob/main/deliverables/09-horizon-labs-assessment.md).
3. **"Unknown" scores zero.** A question with no public answer is a gap in evidence. It can't be assumed to be a control.
4. **Evidence quality sits beside every answer.** A desk review is mostly *Documented*. Condition 3 is what turns those answers into *Verified* before renewal. A score with no evidence-quality column overstates confidence.
5. **Conditions land on both sides.** Five of the nine conditions are controls *Ardent* runs: SSO, tokens, redaction, the agent policy and data location. Much supplier risk is managed in your own configuration, not in the contract.

Sources: [Zendesk Trust Center](https://www.zendesk.com/trust-center/) · [Zendesk security & compliance](https://www.zendesk.com/trust-center/security-compliance/) · [Zendesk security overview](https://support.zendesk.com/hc/en-us/articles/360036130213) · [Dark Reading, Jan 2023](https://www.darkreading.com/application-security/compromised-zendesk-employee-credentials-breach) · [CX Today, Oct 2024](https://www.cxtoday.com/crm/hacker-exposes-zendesk-security-flaw-accesses-confidential-customer-info/) · [Cybernews, Oct 2025 (5CA / Discord)](https://cybernews.com/news/discord-breach-zendesk-partner-5ca-denies-third-party-platform-hack/)
