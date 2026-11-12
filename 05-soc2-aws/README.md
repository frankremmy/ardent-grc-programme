# 05 — SOC 2 controls on AWS: built, evidenced, mapped

> Simulated engagement for Ardent Ledger (fictional). **The AWS account and the evidence are real.** I built these controls in my own AWS account using the scripts here. Every result in the evidence summary comes from the AWS APIs, with the account ID masked.

**Status:** scripts ready · build and evidence pending

## What this shows

Ardent's US customers want a SOC 2 report. SOC 2 doesn't specify controls. It sets criteria (the Trust Services Criteria) and asks the company to show how its controls meet them. This project takes 12 controls Ardent needs on AWS and, for each one:

1. builds it with a script, so it can be repeated and reviewed;
2. collects evidence straight from the AWS APIs, so it's machine-generated rather than screenshots;
3. maps it to the SOC 2 criteria, the ISO 27001 control in the [SoA](../01-compliance-programme/), and the risk it treats.

## Control mapping

| # | Control | SOC 2 TSC | ISO 27001:2022 | Risk |
|---|---|---|---|---|
| C1 | Root account MFA | CC6.1 | 8.5 | R-01 |
| C2 | No root access keys | CC6.1 | 8.2, 5.17 | R-01 |
| C3 | IAM password policy (14+ chars, complexity, no reuse) | CC6.1 | 5.17 | R-01 |
| C4 | Human IAM users are console-only (no access keys) with MFA; work runs in CloudShell with short-lived session credentials | CC6.1, CC6.2 | 5.16, 5.17, 8.2 | R-01, R-13 |
| C5 | CloudTrail across all regions, log file validation, **S3 data events on the customer-data bucket** | CC7.2, CC4.1 | 8.15 | R-12 |
| C6 | S3 Block Public Access at account level | CC6.6, C1.1 | 8.9, 8.20 | R-04 |
| C7 | EBS encryption by default | CC6.1 | 8.24 | R-04 |
| C8 | Customer-managed KMS key with automatic rotation | CC6.1 | 8.24 | R-04 |
| C9 | Customer-data bucket: KMS encryption, versioning, TLS-only policy | C1.1, A1.2, CC6.7 | 8.24, 8.13, 5.14 | R-04, R-05 |
| C10 | GuardDuty threat detection | CC7.2, CC7.3 | 8.16 | R-01, R-12 |
| C11 | AWS Config recording, plus 8 managed rules checking the controls above | CC7.1, CC8.1 | 8.9, 5.36 | R-04 |
| C12 | IAM Access Analyzer (external access findings) | CC6.3, CC6.6 | 5.15, 8.3 | R-04, R-07 |

**Links to the tabletop.** C5's S3 data events and C10's GuardDuty are lessons L1 and L2 from [TTX-01](../04-incident-response/). In that exercise, Ardent couldn't prove which files were read because S3 data events were off. Here they're on.

## How to run it

Run from **AWS CloudShell** (eu-west-1), signed in as an MFA-protected, console-only admin user. No access keys exist anywhere, which is control C4 itself.

**Design decision.** On the AWS free plan, IAM Identity Center needs AWS Organizations, and creating an organization moves the account to paid pricing. A real company would use Identity Center. For this lab, a console-only IAM user with MFA working in CloudShell gives the same property that matters, short-lived credentials and no keys on disk, without changing the account's plan. I recorded this as a deviation rather than hiding it.

```bash
git clone https://github.com/frankremmy/ardent-grc-programme.git
cd ardent-grc-programme/05-soc2-aws/scripts
./01-setup.sh              # builds the controls (asks for confirmation)
# wait ~15 minutes for AWS Config to evaluate
./02-collect-evidence.sh   # writes ../evidence/*.json and ../evidence/SUMMARY.md
./03-teardown.sh           # removes everything that costs money
```

**Cost.** Most of this is free tier or a free trial (GuardDuty, Config). The KMS key costs about $1 a month, prorated, and is scheduled for deletion at teardown. CloudTrail data events on one test bucket cost cents.

## Evidence

*Pending first run.* `evidence/SUMMARY.md` will list a PASS/FAIL result for each control, alongside the raw JSON it was based on.
