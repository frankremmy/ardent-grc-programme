#!/usr/bin/env bash
# Removes the lab resources that cost money. Keeps free hygiene settings
# (root MFA, password policy, account-level S3 Block Public Access, EBS default encryption).
cd "$(dirname "$0")"; source ./common.sh
echo "Account: $ACCT  Region: $REGION"
read -r -p "Delete the Ardent SOC 2 lab resources in this account? Type delete: " ok; [ "$ok" = "delete" ] || exit 1

say "Config rules, recorder and delivery channel"
for r in $(aws configservice describe-config-rules --query 'ConfigRules[].ConfigRuleName' --output text); do
  aws configservice delete-config-rule --config-rule-name "$r"; done
aws configservice stop-configuration-recorder --configuration-recorder-name default 2>/dev/null || true
aws configservice delete-delivery-channel --delivery-channel-name default 2>/dev/null || true
aws configservice delete-configuration-recorder --configuration-recorder-name default 2>/dev/null || true

say "CloudTrail trail"
aws cloudtrail stop-logging --name "$TRAIL" 2>/dev/null || true
aws cloudtrail delete-trail --name "$TRAIL" 2>/dev/null || true

say "GuardDuty and Access Analyzer"
for d in $(aws guardduty list-detectors --query 'DetectorIds[]' --output text); do aws guardduty delete-detector --detector-id "$d"; done
aws accessanalyzer delete-analyzer --analyzer-name "$ANALYZER" 2>/dev/null || true

empty_bucket() {
  local b="$1" f; f="$(mktemp)"
  for kind in Versions DeleteMarkers; do
    while :; do
      aws s3api list-object-versions --bucket "$b" --max-items 500 \
        --query "{Objects: ${kind}[].{Key:Key,VersionId:VersionId}}" --output json > "$f"
      grep -q '"Key"' "$f" || break
      aws s3api delete-objects --bucket "$b" --delete "file://$f" >/dev/null
    done
  done
  rm -f "$f"
}
say "Buckets"
for b in "$DATA_BUCKET" "$LOG_BUCKET"; do
  if aws s3api head-bucket --bucket "$b" 2>/dev/null; then empty_bucket "$b"; aws s3api delete-bucket --bucket "$b"; echo "  deleted $b"; fi
done

say "KMS key (scheduled for deletion in 7 days, the minimum)"
KEY_ID="$(aws kms list-aliases --query "Aliases[?AliasName=='${KMS_ALIAS}'].TargetKeyId" --output text)"
if [ -n "$KEY_ID" ] && [ "$KEY_ID" != "None" ]; then
  aws kms delete-alias --alias-name "$KMS_ALIAS"
  aws kms schedule-key-deletion --key-id "$KEY_ID" --pending-window-in-days 7 >/dev/null
fi
say "Teardown complete."
