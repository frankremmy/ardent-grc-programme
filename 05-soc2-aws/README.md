# 05 — SOC 2 controls on AWS: built, evidenced, mapped

> Simulated engagement for Ardent Ledger (fictional). **The AWS account and the evidence are real.** I built these controls in my own AWS account using the scripts here. Every result in the evidence summary comes from the AWS APIs, with the account ID masked.

**Status:** built and evidenced 2026-11-12 · **11 of 12 controls PASS · 1 not available (GuardDuty) · 8 of 8 Config rules COMPLIANT**

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

Collected 2026-11-12 07:19 UTC from eu-west-1 by `02-collect-evidence.sh`. Raw JSON for every check is in [`evidence/`](evidence/), with the account ID masked. The summary is in [`evidence/SUMMARY.md`](evidence/SUMMARY.md).

| Result | Controls |
|---|---|
| **PASS (11)** | C1 root MFA · C2 no root keys · C3 password policy · C4 console-only users with MFA · C5 CloudTrail (multi-region, validation, S3 data events) · C6 account-level S3 Block Public Access · C7 EBS default encryption · C8 KMS rotation · C9 customer-data bucket (KMS, versioning, TLS-only) · C11 AWS Config · C12 Access Analyzer |
| **Not available (1)** | C10 GuardDuty: the account returned `SubscriptionRequiredException` on the AWS free plan |

AWS Config (C11) independently checks eight of these settings, and all eight rules came back COMPLIANT. Each control is therefore evidenced twice: once by my script and once by AWS's own continuous monitoring. Using two independent sources of evidence is how an auditor gains confidence in a control.

## Findings and exceptions

| # | Finding | Effect | Treatment |
|---|---|---|---|
| E1 | **GuardDuty unavailable.** Threat detection (CC7.2) has no automated control in the lab account | Same gap as SoA 8.16 and TTX-01 lesson L1: a misused key would not raise an alert | In a production (paid) account: enable GuardDuty and send findings to on-call. Here: documented as an exception; CloudTrail data events (C5) still give investigators the record they lacked in TTX-01 |
| E2 | **Deviation: no IAM Identity Center.** On the free plan, Identity Center needs AWS Organizations, which would end the free plan | People sign in as console-only IAM users with MFA instead of SSO | Equivalent for this lab: no access keys exist, and CloudShell uses short-lived session credentials. Production design: Identity Center via Organizations |
| E3 | **Point-in-time evidence.** This shows the controls were in place on one day, which is what a SOC 2 Type I tests | A Type II needs proof the controls ran over 3–12 months | Re-run `02-collect-evidence.sh` on a schedule and keep each run; Config's history covers the period between runs |

## What I learned building it

- **Run-environment details break automation.** CloudShell sets its own `AWS_REGION`, which overrode my script's region, and the first bucket creation failed. The fix was one line. The lesson is to test where the script will actually run, and to fail clearly when something is wrong.
- **Plan restrictions are findings, not obstacles.** GuardDuty being unavailable is the same kind of gap a real company has when a service isn't licensed. The scripts record it as an exception with evidence. They don't stop, and they don't hide it.
- **SOC 2 maps to settings, but auditors test the evidence.** Every control here produces a file an auditor could re-perform from. That matters more than the setting itself.

## Teardown

The lab was torn down on 2026-11-12 after the internal audit sampled it. Both buckets, the trail, the Config rules and recorder, and Access Analyzer were deleted, and the KMS key was scheduled for deletion. Root MFA, the password policy, account-level S3 Block Public Access and EBS default encryption were left on as free hygiene settings. The teardown reported the GuardDuty subscription error again, which matches exception E1.
