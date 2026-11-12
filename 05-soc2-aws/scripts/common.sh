#!/usr/bin/env bash
# Shared settings for the Ardent SOC 2 AWS lab. Sourced by the other scripts.
set -euo pipefail
export AWS_PAGER=""
REGION="${REGION:-eu-west-1}"
export AWS_DEFAULT_REGION="$REGION"
export AWS_REGION="$REGION"   # CloudShell sets AWS_REGION, which overrides AWS_DEFAULT_REGION
ACCT="$(aws sts get-caller-identity --query Account --output text)"
PREFIX="ardent-soc2-lab"
LOG_BUCKET="${PREFIX}-logs-${ACCT}"
DATA_BUCKET="${PREFIX}-data-${ACCT}"
TRAIL="ardent-account-trail"
KMS_ALIAS="alias/${PREFIX}-data"
ANALYZER="ardent-account-analyzer"
say() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
