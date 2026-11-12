#!/usr/bin/env bash
# Builds the Ardent SOC 2 lab controls in one AWS account (eu-west-1).
# Safe to re-run: steps that already exist are skipped.
# Cost: free tier / trials for most; a KMS key is ~$1/month (prorated); Config and CloudTrail data events cost cents.
cd "$(dirname "$0")"; source ./common.sh
echo "Account: $ACCT  Region: $REGION"
read -r -p "Build the lab in this account? Type yes: " ok; [ "$ok" = "yes" ] || exit 1
tmp="$(mktemp -d)"

say "C3  IAM password policy (CC6.1)"
aws iam update-account-password-policy --minimum-password-length 14 \
  --require-symbols --require-numbers --require-uppercase-characters --require-lowercase-characters \
  --password-reuse-prevention 24 --allow-users-to-change-password

say "C6  S3 Block Public Access, account level (CC6.6, C1.1)"
aws s3control put-public-access-block --account-id "$ACCT" --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

say "C7  EBS encryption by default (CC6.1)"
aws ec2 enable-ebs-encryption-by-default >/dev/null

say "Log bucket for CloudTrail and AWS Config"
if ! aws s3api head-bucket --bucket "$LOG_BUCKET" 2>/dev/null; then
  aws s3api create-bucket --bucket "$LOG_BUCKET" --create-bucket-configuration LocationConstraint="$REGION" >/dev/null
fi
aws s3api put-bucket-versioning --bucket "$LOG_BUCKET" --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption --bucket "$LOG_BUCKET" --server-side-encryption-configuration \
  '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
cat > "$tmp/logpolicy.json" <<JSON
{"Version":"2012-10-17","Statement":[
 {"Sid":"CloudTrailAclCheck","Effect":"Allow","Principal":{"Service":"cloudtrail.amazonaws.com"},"Action":"s3:GetBucketAcl","Resource":"arn:aws:s3:::${LOG_BUCKET}","Condition":{"StringEquals":{"aws:SourceArn":"arn:aws:cloudtrail:${REGION}:${ACCT}:trail/${TRAIL}"}}},
 {"Sid":"CloudTrailWrite","Effect":"Allow","Principal":{"Service":"cloudtrail.amazonaws.com"},"Action":"s3:PutObject","Resource":"arn:aws:s3:::${LOG_BUCKET}/AWSLogs/${ACCT}/*","Condition":{"StringEquals":{"s3:x-amz-acl":"bucket-owner-full-control","aws:SourceArn":"arn:aws:cloudtrail:${REGION}:${ACCT}:trail/${TRAIL}"}}},
 {"Sid":"ConfigAclCheck","Effect":"Allow","Principal":{"Service":"config.amazonaws.com"},"Action":["s3:GetBucketAcl","s3:ListBucket"],"Resource":"arn:aws:s3:::${LOG_BUCKET}","Condition":{"StringEquals":{"AWS:SourceAccount":"${ACCT}"}}},
 {"Sid":"ConfigWrite","Effect":"Allow","Principal":{"Service":"config.amazonaws.com"},"Action":"s3:PutObject","Resource":"arn:aws:s3:::${LOG_BUCKET}/AWSLogs/${ACCT}/Config/*","Condition":{"StringEquals":{"s3:x-amz-acl":"bucket-owner-full-control","AWS:SourceAccount":"${ACCT}"}}},
 {"Sid":"DenyInsecureTransport","Effect":"Deny","Principal":"*","Action":"s3:*","Resource":["arn:aws:s3:::${LOG_BUCKET}","arn:aws:s3:::${LOG_BUCKET}/*"],"Condition":{"Bool":{"aws:SecureTransport":"false"}}}
]}
JSON
aws s3api put-bucket-policy --bucket "$LOG_BUCKET" --policy "file://$tmp/logpolicy.json"

say "C8  KMS customer-managed key with automatic rotation (CC6.1)"
KEY_ID="$(aws kms list-aliases --query "Aliases[?AliasName=='${KMS_ALIAS}'].TargetKeyId" --output text)"
if [ -z "$KEY_ID" ] || [ "$KEY_ID" = "None" ]; then
  KEY_ID="$(aws kms create-key --description 'Ardent SOC2 lab - customer data' --query KeyMetadata.KeyId --output text)"
  aws kms create-alias --alias-name "$KMS_ALIAS" --target-key-id "$KEY_ID"
fi
aws kms enable-key-rotation --key-id "$KEY_ID"

say "C9  Customer-data bucket: KMS encryption, versioning, TLS-only, no public access (C1.1, A1.2, CC6.7)"
if ! aws s3api head-bucket --bucket "$DATA_BUCKET" 2>/dev/null; then
  aws s3api create-bucket --bucket "$DATA_BUCKET" --create-bucket-configuration LocationConstraint="$REGION" >/dev/null
fi
aws s3api put-public-access-block --bucket "$DATA_BUCKET" --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
aws s3api put-bucket-versioning --bucket "$DATA_BUCKET" --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption --bucket "$DATA_BUCKET" --server-side-encryption-configuration \
  "{\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"aws:kms\",\"KMSMasterKeyID\":\"${KEY_ID}\"},\"BucketKeyEnabled\":true}]}"
cat > "$tmp/datapolicy.json" <<JSON
{"Version":"2012-10-17","Statement":[
 {"Sid":"DenyInsecureTransport","Effect":"Deny","Principal":"*","Action":"s3:*","Resource":["arn:aws:s3:::${DATA_BUCKET}","arn:aws:s3:::${DATA_BUCKET}/*"],"Condition":{"Bool":{"aws:SecureTransport":"false"}}}
]}
JSON
aws s3api put-bucket-policy --bucket "$DATA_BUCKET" --policy "file://$tmp/datapolicy.json"
printf 'invoice_id,customer,amount_eur\nINV-0001,Example Ltd,120.00\n' > "$tmp/sample-invoice.csv"
aws s3 cp "$tmp/sample-invoice.csv" "s3://${DATA_BUCKET}/exports/sample-invoice.csv" >/dev/null

say "C5  CloudTrail: multi-region, log file validation, S3 data events on the customer-data bucket (CC7.2, CC4.1)"
if ! aws cloudtrail get-trail --name "$TRAIL" >/dev/null 2>&1; then
  aws cloudtrail create-trail --name "$TRAIL" --s3-bucket-name "$LOG_BUCKET" \
    --is-multi-region-trail --enable-log-file-validation --include-global-service-events >/dev/null
fi
aws cloudtrail put-event-selectors --trail-name "$TRAIL" --advanced-event-selectors "[
 {\"Name\":\"Management events\",\"FieldSelectors\":[{\"Field\":\"eventCategory\",\"Equals\":[\"Management\"]}]},
 {\"Name\":\"Customer-data bucket object access\",\"FieldSelectors\":[
   {\"Field\":\"eventCategory\",\"Equals\":[\"Data\"]},
   {\"Field\":\"resources.type\",\"Equals\":[\"AWS::S3::Object\"]},
   {\"Field\":\"resources.ARN\",\"StartsWith\":[\"arn:aws:s3:::${DATA_BUCKET}/\"]}]}]" >/dev/null
aws cloudtrail start-logging --name "$TRAIL"

say "C10 GuardDuty threat detection (CC7.2, CC7.3)"
if [ -z "$(aws guardduty list-detectors --query 'DetectorIds[0]' --output text | grep -v None || true)" ]; then
  aws guardduty create-detector --enable --finding-publishing-frequency FIFTEEN_MINUTES >/dev/null
fi

say "C12 IAM Access Analyzer (CC6.3, CC6.6)"
aws accessanalyzer get-analyzer --analyzer-name "$ANALYZER" >/dev/null 2>&1 || \
  aws accessanalyzer create-analyzer --analyzer-name "$ANALYZER" --type ACCOUNT >/dev/null

say "C11 AWS Config recorder and managed rules (CC7.1, CC8.1)"
aws iam create-service-linked-role --aws-service-name config.amazonaws.com >/dev/null 2>&1 || true
aws configservice put-configuration-recorder --configuration-recorder \
  "name=default,roleARN=arn:aws:iam::${ACCT}:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig" \
  --recording-group allSupported=true,includeGlobalResourceTypes=true
aws configservice put-delivery-channel --delivery-channel "name=default,s3BucketName=${LOG_BUCKET}"
aws configservice start-configuration-recorder --configuration-recorder-name default
for rule in ROOT_ACCOUNT_MFA_ENABLED IAM_ROOT_ACCESS_KEY_CHECK IAM_PASSWORD_POLICY CLOUD_TRAIL_ENABLED \
            S3_BUCKET_PUBLIC_READ_PROHIBITED S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED \
            S3_BUCKET_VERSIONING_ENABLED S3_BUCKET_SSL_REQUESTS_ONLY; do
  name="$(echo "$rule" | tr 'A-Z_' 'a-z-')"
  aws configservice put-config-rule --config-rule \
    "{\"ConfigRuleName\":\"${name}\",\"Source\":{\"Owner\":\"AWS\",\"SourceIdentifier\":\"${rule}\"}}"
  echo "  rule: $name"
done

rm -rf "$tmp"
say "Done. Wait about 15 minutes for Config rules to evaluate, then run ./02-collect-evidence.sh"
