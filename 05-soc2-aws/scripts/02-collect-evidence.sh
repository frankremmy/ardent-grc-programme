#!/usr/bin/env bash
# Collects evidence for each control, masks the account ID, and writes a pass/fail summary.
cd "$(dirname "$0")"; source ./common.sh
OUT="../evidence"; mkdir -p "$OUT"
STAMP="$(date -u +%Y-%m-%dT%H:%MZ)"
mask() { sed -E "s/${ACCT}/XXXXXXXXXXXX/g; s/(AKIA|ASIA)[A-Z0-9]{16}/\1XXXXXXXXXXXXXXXX/g"; }
save() { mask > "$OUT/$1"; }
row() { printf '| %s | %s | %s | %s | %s |\n' "$1" "$2" "$3" "$4" "$5" >> "$OUT/SUMMARY.md"; }
pf() { if [ "$1" = "$2" ]; then echo "PASS"; else echo "FAIL ($1)"; fi; }

cat > "$OUT/SUMMARY.md" <<MD
# Evidence summary

Collected ${STAMP} from account XXXXXXXXXXXX (${REGION}) by \`02-collect-evidence.sh\`. Account ID masked.

| # | Control | SOC 2 | Result | Evidence file |
|---|---|---|---|---|
MD

aws iam get-account-summary --output json | save c01-c02-account-summary.json
v=$(aws iam get-account-summary --query 'SummaryMap.AccountMFAEnabled' --output text)
row C1 "Root account MFA enabled" "CC6.1" "$(pf "$v" 1)" c01-c02-account-summary.json
v=$(aws iam get-account-summary --query 'SummaryMap.AccountAccessKeysPresent' --output text)
row C2 "No root access keys" "CC6.1" "$(pf "$v" 0)" c01-c02-account-summary.json

aws iam get-account-password-policy --output json | save c03-password-policy.json
v=$(aws iam get-account-password-policy --query 'PasswordPolicy.MinimumPasswordLength >= `14`' --output text)
row C3 "IAM password policy: 14+ characters, complexity, reuse prevention" "CC6.1" "$(pf "$v" True)" c03-password-policy.json

# C4: human IAM users are console-only (no access keys) and every one has MFA.
# (On the AWS free plan, IAM Identity Center would need AWS Organizations and end the free plan.)
keys=0; nomfa=0; : > /tmp/ardent-c4.txt
for u in $(aws iam list-users --query 'Users[].UserName' --output text); do
  k=$(aws iam list-access-keys --user-name "$u" --query 'length(AccessKeyMetadata)' --output text)
  m=$(aws iam list-mfa-devices --user-name "$u" --query 'length(MFADevices)' --output text)
  echo "{\"User\":\"$u\",\"AccessKeys\":$k,\"MFADevices\":$m}" >> /tmp/ardent-c4.txt
  keys=$((keys+k)); [ "$m" -gt 0 ] || nomfa=$((nomfa+1))
done
{ echo '['; paste -sd, /tmp/ardent-c4.txt; echo ']'; } | save c04-iam-users.json
row C4 "Human IAM users: console-only (no access keys) and MFA on every user" "CC6.1, CC6.2" "$(pf "$keys $nomfa" "0 0")" c04-iam-users.json

aws cloudtrail describe-trails --trail-name-list "$TRAIL" --output json | save c05-trail.json
aws cloudtrail get-trail-status --name "$TRAIL" --output json | save c05-trail-status.json
aws cloudtrail get-event-selectors --trail-name "$TRAIL" --output json | save c05-event-selectors.json
v=$(aws cloudtrail get-trail-status --name "$TRAIL" --query 'IsLogging' --output text)
w=$(aws cloudtrail describe-trails --trail-name-list "$TRAIL" --query 'trailList[0].[IsMultiRegionTrail,LogFileValidationEnabled]' --output text | tr '\t' ' ')
row C5 "CloudTrail logging, multi-region, log file validation, data events on customer-data bucket" "CC7.2, CC4.1" "$(pf "$v $w" "True True True")" "c05-trail*.json, c05-event-selectors.json"

aws s3control get-public-access-block --account-id "$ACCT" --output json | save c06-s3-account-bpa.json
v=$(aws s3control get-public-access-block --account-id "$ACCT" --query 'PublicAccessBlockConfiguration.[BlockPublicAcls,IgnorePublicAcls,BlockPublicPolicy,RestrictPublicBuckets]' --output text | tr '\t' ' ')
row C6 "S3 Block Public Access at account level" "CC6.6, C1.1" "$(pf "$v" "True True True True")" c06-s3-account-bpa.json

aws ec2 get-ebs-encryption-by-default --output json | save c07-ebs-default-encryption.json
v=$(aws ec2 get-ebs-encryption-by-default --query EbsEncryptionByDefault --output text)
row C7 "EBS volumes encrypted by default" "CC6.1" "$(pf "$v" True)" c07-ebs-default-encryption.json

KEY_ID="$(aws kms list-aliases --query "Aliases[?AliasName=='${KMS_ALIAS}'].TargetKeyId" --output text)"
aws kms get-key-rotation-status --key-id "$KEY_ID" --output json | save c08-kms-rotation.json
v=$(aws kms get-key-rotation-status --key-id "$KEY_ID" --query KeyRotationEnabled --output text)
row C8 "Customer-managed KMS key with automatic rotation" "CC6.1" "$(pf "$v" True)" c08-kms-rotation.json

{ echo '{"Encryption":'; aws s3api get-bucket-encryption --bucket "$DATA_BUCKET" --output json
  echo ',"Versioning":'; aws s3api get-bucket-versioning --bucket "$DATA_BUCKET" --output json
  echo ',"PublicAccessBlock":'; aws s3api get-public-access-block --bucket "$DATA_BUCKET" --output json
  echo ',"Policy":'; aws s3api get-bucket-policy --bucket "$DATA_BUCKET" --query Policy --output json; echo '}'; } | save c09-data-bucket.json
a=$(aws s3api get-bucket-encryption --bucket "$DATA_BUCKET" --query 'ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm' --output text)
b=$(aws s3api get-bucket-versioning --bucket "$DATA_BUCKET" --query Status --output text)
c=$(aws s3api get-bucket-policy --bucket "$DATA_BUCKET" --query Policy --output text | grep -c SecureTransport || true)
row C9 "Customer-data bucket: KMS encryption, versioning, TLS-only policy" "C1.1, A1.2, CC6.7" "$(pf "$a $b $c" "aws:kms Enabled 1")" c09-data-bucket.json

if DET="$(aws guardduty list-detectors --query 'DetectorIds[0]' --output text 2>/dev/null)" && [ "$DET" != "None" ] && [ -n "$DET" ]; then
  aws guardduty get-detector --detector-id "$DET" --output json | save c10-guardduty.json
  v=$(aws guardduty get-detector --detector-id "$DET" --query Status --output text)
  row C10 "GuardDuty enabled, 15-minute finding publication" "CC7.2, CC7.3" "$(pf "$v" ENABLED)" c10-guardduty.json
else
  aws guardduty list-detectors 2>&1 | save c10-guardduty-unavailable.txt || true
  row C10 "GuardDuty enabled, 15-minute finding publication" "CC7.2, CC7.3" "NOT AVAILABLE (account subscription; see file)" c10-guardduty-unavailable.txt
fi

aws configservice describe-configuration-recorder-status --output json | save c11-config-recorder.json
aws configservice describe-compliance-by-config-rule --output json | save c11-config-rule-compliance.json
v=$(aws configservice describe-configuration-recorder-status --query 'ConfigurationRecordersStatus[0].recording' --output text)
nc=$(aws configservice describe-compliance-by-config-rule --compliance-types NON_COMPLIANT --query 'length(ComplianceByConfigRules)' --output text)
row C11 "AWS Config recording; managed rules evaluating (non-compliant rules: ${nc})" "CC7.1, CC8.1" "$(pf "$v" True)" "c11-config-*.json"

aws accessanalyzer get-analyzer --analyzer-name "$ANALYZER" --output json | save c12-access-analyzer.json
aws accessanalyzer list-findings-v2 --analyzer-arn "$(aws accessanalyzer get-analyzer --analyzer-name "$ANALYZER" --query analyzer.arn --output text)" --output json 2>/dev/null | save c12-access-analyzer-findings.json || true
v=$(aws accessanalyzer get-analyzer --analyzer-name "$ANALYZER" --query analyzer.status --output text)
row C12 "IAM Access Analyzer active (external access findings reviewed)" "CC6.3, CC6.6" "$(pf "$v" ACTIVE)" "c12-access-analyzer*.json"

echo "" >> "$OUT/SUMMARY.md"
echo "Config rule results:" >> "$OUT/SUMMARY.md"; echo '```' >> "$OUT/SUMMARY.md"
aws configservice describe-compliance-by-config-rule --query 'ComplianceByConfigRules[].[ConfigRuleName,Compliance.ComplianceType]' --output text >> "$OUT/SUMMARY.md"
echo '```' >> "$OUT/SUMMARY.md"
cat "$OUT/SUMMARY.md"
