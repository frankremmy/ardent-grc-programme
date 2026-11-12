# Ardent Ledger Ltd —  Company profile (fictional)

| | |
|---|---|
| **What it does** | Cloud accounting and invoicing for small and mid-sized businesses: invoices, expenses, bank feeds, VAT returns |
| **Where** | Head office in Mosta, Malta; hybrid team |
| **Size** | 120 staff: 45 engineering, 30 customer support, 20 sales and marketing, 25 G&A |
| **Customers** | About 9,000 businesses in the EU and US |
| **Data held** | Customers' financial records (invoices, bank transactions, VAT data), customer contact data, and their end customers' names and addresses |
| **Stack** | AWS (eu-west-1 primary, eu-central-1 backups): ECS, RDS PostgreSQL, S3, CloudFront. Code in GitHub; identity in Google Workspace |
| **Key suppliers** | AWS, Stripe (billing), Postmark (email), Zendesk (support), Google Workspace |
| **Why security now** | Two enterprise deals stalled on "send us your ISO certificate / SOC 2 report". One phishing incident in 2026 |

## People in the case

| Role | Responsibility in the ISMS |
|---|---|
| CEO | Top management. Accountable for the ISMS and approves the policy |
| CTO | Owner of technology risk; the ISA reports to the CTO |
| Information Security Analyst (ISA, me) | Runs the ISMS, risk process, audits and the assessor relationship |
| Head of Engineering | Secure development, change management |
| DevOps Lead | AWS, identity, logging, backups |
| Head of People | Screening, onboarding/offboarding, training records |
| DPO | GDPR: RoPA, DSARs, breach notification |
| Legal Counsel | Contracts, supplier terms, legal register |
| Finance Director | Records retention, supplier spend |
| Office Manager | Physical security of the Mosta office |

## Risk IDs used across the projects

| ID | Risk |
|---|---|
| R-01 | Leaked or misused AWS access key exposes customer financial data |
| R-02 | Phishing or business email compromise leads to fraud or data loss |
| R-03 | Customer account takeover through credential stuffing |
| R-04 | Misconfigured cloud storage exposes data |
| R-05 | Ransomware or destructive deletion of production data, with backups failing to restore |
| R-06 | Breach at a critical supplier |
| R-07 | Privileged insider misuse (staff or support access to customer data) |
| R-08 | Exploitable vulnerability in the application or its dependencies |
| R-09 | GDPR non-compliance (retention, DSARs, test data) |
| R-10 | Prolonged regional outage |
| R-11 | Lost or stolen laptop |
| R-12 | Slow detection of an incident because of weak logging and monitoring |
| R-13 | Leaver access not removed on time |
| R-14 | Unapproved change corrupts financial calculations |
| R-15 | Lost deals or contracts for lack of certification or attestation |
