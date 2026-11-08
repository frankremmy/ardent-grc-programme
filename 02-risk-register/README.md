# 02 — Risk register: assessment, heat map and quantification

**Artefact:** [Ardent risk register — Google Sheet (view only)](https://docs.google.com/spreadsheets/d/11GxpylEPevgmE8XV62QuoAibNbC6H5lxfn0bI8CRsjo/edit?usp=sharing)

Sheets: Read me · Criteria · Assets · Risk register (15 risks) · Heat map (live) · FAIR (R-01) · Summary

> Structure adapted from GRC Mastery course templates (asset register → risk assessment → legend), used with the course owner's permission. The criteria, assets, risks, scoring and analysis are my own.

## Results

| | High | Medium | Low |
|---|---|---|---|
| Inherent (before treatment) | 6 | 8 | 1 |
| Residual (after planned treatment) | 0 | 5 | 10 |

**Top 3 for management**

1. **R-01 — leaked or misused AWS access key (20, High).** This is the shortest path to every customer's financial data, and today nothing would alert us. The FAIR estimate puts the annualised loss exposure at **≈ €231k**. Treatment brings it down to **≈ €45k**, at a cost of about **€25k a year**. That is a return of about 6.4× on the spend. Put the other way, the control pays for itself if it removes just 11% of today's exposure.
2. **R-03 and R-08 — customer account takeover and application vulnerabilities (16 each, High).** Either one ends with an attacker changing a customer's bank details or issuing invoices in their name, which is direct harm to customers. The decisions needed are making MFA the default for customer admin users and funding an annual pen test.
3. **R-09 — GDPR non-compliance (16, High).** Production invoices are copied into staging, and closed accounts are never purged. Both are easy findings for an auditor or the IDPC, and both are cheap to fix.

**Accepted:** R-11, lost laptop (6, Low). The DevOps Lead accepted it because MDM encryption and remote wipe already keep it within appetite. It is due for review on 2027-11-07.

## How I built it

1. **Criteria before risks.** Likelihood and impact each have five levels with written definitions, and impact is tied to euro bands for a company with about €14m in revenue. Acceptance criteria say who decides and by when for each level. This is clause 6.1.2(a), and it is what makes two assessors score the same risk the same way.
2. **Assets, then risks.** Each risk names the assets it affects, the threat and the vulnerability, and is written as *event → consequence*. A line like "Data breach" isn't a risk statement.
3. **Existing controls are credited.** The inherent score counts the controls already working (MFA, encryption, MDM), so the register doesn't overstate risk and flatter the treatment.
4. **Every treatment points to the SoA.** The "Linked Annex A controls" column uses the same control IDs as [project 01](../01-compliance-programme/), so the chain from risk to treatment to SoA can be followed in both directions.
5. **Residual risk is a forecast.** Residual scores assume the planned treatment is in place. Each one gets re-scored once the treatment is verified, and that verification is a sample for the internal audit in [project 07](../07-internal-audit/).
6. **FAIR only where it changes a decision.** Only R-01 is quantified, because that's where the spend decision is. The method comes from my [FAIR calculator](https://github.com/frankremmy/grc-mastery/blob/main/deliverables/11-fair-calculator.xlsx). Inputs are min / most likely / max, combined with PERT means, and each input has a stated basis. Every figure is an assumption, and the sheet lets anyone change them.

## Decisions an interviewer might ask about

- **Why R-01 stays Medium (10) after treatment.** Impact remains 5: if a key is ever misused, the data at stake is the same. Treatment lowers the likelihood, not the stakes. I'd rather show that honestly than claim the risk drops to Low.
- **Why the CEO owns R-15.** Losing deals for lack of certification is a business risk. The people who own the decision should own the risk, not the security team.
- **Why only one acceptance.** Accepting a risk is a decision, not a default. The only one accepted here is R-11, which is Low, by its owner, with a review date. That meets the acceptance criteria on the Criteria sheet.
