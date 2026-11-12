# Evidence summary

Collected 2026-11-12T07:19Z from account XXXXXXXXXXXX (eu-west-1) by `02-collect-evidence.sh`. Account ID masked.

| # | Control | SOC 2 | Result | Evidence file |
|---|---|---|---|---|
| C1 | Root account MFA enabled | CC6.1 | PASS | c01-c02-account-summary.json |
| C2 | No root access keys | CC6.1 | PASS | c01-c02-account-summary.json |
| C3 | IAM password policy: 14+ characters, complexity, reuse prevention | CC6.1 | PASS | c03-password-policy.json |
| C4 | Human IAM users: console-only (no access keys) and MFA on every user | CC6.1, CC6.2 | PASS | c04-iam-users.json |
| C5 | CloudTrail logging, multi-region, log file validation, data events on customer-data bucket | CC7.2, CC4.1 | PASS | c05-trail*.json, c05-event-selectors.json |
| C6 | S3 Block Public Access at account level | CC6.6, C1.1 | PASS | c06-s3-account-bpa.json |
| C7 | EBS volumes encrypted by default | CC6.1 | PASS | c07-ebs-default-encryption.json |
| C8 | Customer-managed KMS key with automatic rotation | CC6.1 | PASS | c08-kms-rotation.json |
| C9 | Customer-data bucket: KMS encryption, versioning, TLS-only policy | C1.1, A1.2, CC6.7 | PASS | c09-data-bucket.json |
| C10 | GuardDuty enabled, 15-minute finding publication | CC7.2, CC7.3 | NOT AVAILABLE (account subscription; see file) | c10-guardduty-unavailable.txt |
| C11 | AWS Config recording; managed rules evaluating (non-compliant rules: 0) | CC7.1, CC8.1 | PASS | c11-config-*.json |
| C12 | IAM Access Analyzer active (external access findings reviewed) | CC6.3, CC6.6 | PASS | c12-access-analyzer*.json |

Config rule results:
```
cloud-trail-enabled	COMPLIANT
iam-password-policy	COMPLIANT
iam-root-access-key-check	COMPLIANT
root-account-mfa-enabled	COMPLIANT
s3-bucket-public-read-prohibited	COMPLIANT
s3-bucket-server-side-encryption-enabled	COMPLIANT
s3-bucket-ssl-requests-only	COMPLIANT
s3-bucket-versioning-enabled	COMPLIANT
```
